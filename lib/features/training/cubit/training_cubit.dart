import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:myputt/models/data/sessions/putting_session.dart';
import 'package:myputt/models/data/training/training_session_instructions.dart';
import 'package:myputt/services/ai/ai_coach_service.dart';

part 'training_state.dart';

class TrainingCubit extends Cubit<TrainingState> {
  final AICoachService aiCoachService;
  
  TrainingSession? _currentSession;
  final List<int> _consecutiveMakesTracker = [];

  TrainingCubit({required this.aiCoachService}) : super(TrainingInitial());

  Future<void> generateTrainingSession({
    required List<PuttingSession> puttingHistory,
    DifficultyLevel? difficulty,
    int? targetDurationMinutes,
  }) async {
    emit(TrainingLoading());
    
    try {
      final instructions = await aiCoachService.generateTrainingSession(
        puttingHistory: puttingHistory,
        preferredDifficulty: difficulty,
        targetDurationMinutes: targetDurationMinutes,
      );
      
      emit(TrainingInstructionsGenerated(instructions: instructions));
    } catch (e) {
      emit(TrainingError(message: 'Failed to generate training session: $e'));
    }
  }

  Future<void> startTrainingSession(TrainingSessionInstructions instructions) async {
    final sessionId = DateTime.now().millisecondsSinceEpoch.toString();
    
    _currentSession = TrainingSession(
      id: sessionId,
      instructions: instructions,
      startedAt: DateTime.now(),
      results: [],
      goalCompletions: {},
    );
    
    _consecutiveMakesTracker.clear();
    
    // Emit initial state without AI calls for instant navigation
    emit(TrainingSessionInProgress(
      session: _currentSession!,
      currentFeedback: CoachingFeedback(
        message: 'Welcome! Let\'s start with your first set.',
        tone: FeedbackTone.encouraging,
        encouragement: 'Take a deep breath and focus on your fundamentals.',
        focusPoints: ['Set up with good alignment', 'Keep a steady tempo'],
      ),
      goalProgress: GoalEvaluationResult(
        goalProgress: {},
        completedGoalIds: [],
        summary: 'Ready to begin your training session!',
        overallProgress: 0,
      ),
    ));
  }

  Future<void> addSetResult({
    required int puttsMade,
    required int puttsAttempted,
  }) async {
    if (_currentSession == null) return;
    
    final currentSetIndex = _currentSession!.currentSetIndex;
    if (currentSetIndex >= _currentSession!.instructions.trainingSets.length) return;
    
    final currentSet = _currentSession!.instructions.trainingSets[currentSetIndex];
    
    // Track consecutive makes
    int consecutiveMakes = 0;
    if (puttsMade == puttsAttempted && puttsAttempted > 0) {
      _consecutiveMakesTracker.add(puttsMade);
      consecutiveMakes = _consecutiveMakesTracker.fold(0, (sum, count) => sum + count);
    } else {
      _consecutiveMakesTracker.clear();
    }
    
    final result = TrainingSetResult(
      distance: currentSet.distance,
      puttsMade: puttsMade,
      puttsAttempted: puttsAttempted,
      timestamp: DateTime.now(),
      consecutiveMakes: consecutiveMakes > 0 ? consecutiveMakes : null,
    );
    
    final updatedResults = List<TrainingSetResult>.from(_currentSession!.results)
      ..add(result);
    
    _currentSession = _currentSession!.copyWith(results: updatedResults);
    
    // Check if all sets are completed
    if (_currentSession!.allSetsCompleted) {
      await _completeSession();
    } else {
      await _updateSessionState();
    }
  }

  Future<void> undoLastSet() async {
    if (_currentSession == null || _currentSession!.results.isEmpty) return;
    
    final updatedResults = List<TrainingSetResult>.from(_currentSession!.results)
      ..removeLast();
    
    _currentSession = _currentSession!.copyWith(results: updatedResults);
    
    // Recalculate consecutive makes
    _recalculateConsecutiveMakes();
    
    await _updateSessionState();
  }

  Future<void> _updateSessionState() async {
    if (_currentSession == null) return;
    
    emit(TrainingSessionLoading());
    
    try {
      // Get coaching feedback
      final lastResult = _currentSession!.results.isNotEmpty 
          ? _currentSession!.results.last 
          : null;
      
      // Skip AI calls if this is the initial state with no results
      if (_currentSession!.results.isEmpty) {
        emit(TrainingSessionInProgress(
          session: _currentSession!,
          currentFeedback: CoachingFeedback(
            message: 'Ready for your first set! Take your time and focus on your setup.',
            tone: FeedbackTone.encouraging,
            encouragement: 'You\'ve got this!',
            focusPoints: ['Maintain good posture', 'Keep your eyes on the ball'],
          ),
          goalProgress: GoalEvaluationResult(
            goalProgress: {},
            completedGoalIds: [],
            summary: 'Complete your sets to start tracking goals!',
            overallProgress: 0,
          ),
        ));
        return;
      }
      
      final feedback = await aiCoachService.provideCoachingFeedback(
        currentSession: _currentSession!,
        lastSetResult: lastResult,
        currentSetIndex: _currentSession!.currentSetIndex,
      );
      
      // Evaluate goal progress
      final goalEvaluation = await aiCoachService.evaluateGoalProgress(
        goals: _currentSession!.instructions.goals,
        results: _currentSession!.results,
        session: _currentSession!,
      );
      
      // Update goal completions
      final goalCompletions = <String, bool>{};
      for (final goalId in goalEvaluation.completedGoalIds) {
        goalCompletions[goalId] = true;
      }
      
      _currentSession = _currentSession!.copyWith(
        goalCompletions: goalCompletions,
      );
      
      emit(TrainingSessionInProgress(
        session: _currentSession!,
        currentFeedback: feedback,
        goalProgress: goalEvaluation,
      ));
    } catch (e) {
      emit(TrainingError(message: 'Failed to update session: $e'));
    }
  }

  Future<void> _completeSession() async {
    if (_currentSession == null) return;
    
    _currentSession = _currentSession!.copyWith(
      completedAt: DateTime.now(),
      isCompleted: true,
    );
    
    // Get final evaluation
    final goalEvaluation = await aiCoachService.evaluateGoalProgress(
      goals: _currentSession!.instructions.goals,
      results: _currentSession!.results,
      session: _currentSession!,
    );
    
    emit(TrainingSessionCompleted(
      session: _currentSession!,
      finalGoalProgress: goalEvaluation,
    ));
  }

  void _recalculateConsecutiveMakes() {
    _consecutiveMakesTracker.clear();
    
    for (final result in _currentSession!.results.reversed) {
      if (result.puttsMade == result.puttsAttempted && result.puttsAttempted > 0) {
        _consecutiveMakesTracker.insert(0, result.puttsMade);
      } else {
        break;
      }
    }
  }

  Future<void> abandonSession() async {
    _currentSession = null;
    _consecutiveMakesTracker.clear();
    emit(TrainingInitial());
  }

  void updateRealtimeFeedback({
    required int puttsMade,
    required int puttsToAttempt,
  }) {
    if (_currentSession == null || state is! TrainingSessionInProgress) return;
    
    final currentState = state as TrainingSessionInProgress;
    final percentage = puttsToAttempt > 0 ? (puttsMade / puttsToAttempt * 100) : 0.0;
    
    // Determine feedback based on current selection
    String message;
    String? encouragement;
    FeedbackTone tone;
    
    if (puttsMade == puttsToAttempt && puttsToAttempt > 0) {
      // Perfect score
      if (puttsToAttempt >= 20) {
        message = "Incredible! $puttsToAttempt for $puttsToAttempt - you're on fire!";
        encouragement = "Your focus and consistency are paying off. Keep this momentum going!";
        tone = FeedbackTone.celebratory;
      } else if (puttsToAttempt >= 10) {
        message = "Perfect set! You made all $puttsToAttempt putts!";
        encouragement = "Excellent work - your stroke is dialed in.";
        tone = FeedbackTone.celebratory;
      } else {
        message = "Great job! All $puttsToAttempt putts made!";
        encouragement = "Keep up the solid putting.";
        tone = FeedbackTone.positive;
      }
    } else if (percentage >= 80) {
      message = "Excellent putting! $puttsMade out of $puttsToAttempt is strong performance.";
      encouragement = "You're showing great consistency.";
      tone = FeedbackTone.positive;
    } else if (percentage >= 60) {
      message = "Good work making $puttsMade out of $puttsToAttempt putts.";
      encouragement = "Focus on your setup and alignment for the next set.";
      tone = FeedbackTone.encouraging;
    } else if (percentage >= 40) {
      message = "Keep working on it. $puttsMade out of $puttsToAttempt is progress.";
      encouragement = "Take a deep breath and focus on your fundamentals.";
      tone = FeedbackTone.constructive;
    } else if (puttsMade == 0 && puttsToAttempt > 0) {
      message = "Tough set, but don't get discouraged.";
      encouragement = "Reset, refocus, and trust your practice. Every putt is a new opportunity.";
      tone = FeedbackTone.encouraging;
    } else {
      message = "Keep your head steady and follow through to your target.";
      encouragement = "Focus on making solid contact with each putt.";
      tone = FeedbackTone.neutral;
    }
    
    final updatedFeedback = CoachingFeedback(
      message: message,
      tone: tone,
      encouragement: encouragement,
      focusPoints: currentState.currentFeedback.focusPoints,
      technicalAdvice: currentState.currentFeedback.technicalAdvice,
    );
    
    emit(TrainingSessionInProgress(
      session: currentState.session,
      currentFeedback: updatedFeedback,
      goalProgress: currentState.goalProgress,
    ));
  }

  Future<void> loadPreviousSession(TrainingSession session) async {
    _currentSession = session;
    _recalculateConsecutiveMakes();
    await _updateSessionState();
  }

  Future<void> requestMidSessionAdjustment() async {
    if (_currentSession == null || state is! TrainingSessionInProgress) return;
    
    final adjustment = await aiCoachService.suggestMidSessionAdjustment(
      session: _currentSession!,
      completedSets: _currentSession!.results,
    );
    
    if (adjustment != null) {
      // Update remaining sets
      final completedCount = _currentSession!.results.length;
      final updatedSets = [
        ..._currentSession!.instructions.trainingSets.take(completedCount),
        ...adjustment.adjustedSets,
      ];
      
      final updatedInstructions = _currentSession!.instructions.copyWith(
        trainingSets: updatedSets,
      );
      
      _currentSession = _currentSession!.copyWith(
        instructions: updatedInstructions,
      );
      
      await _updateSessionState();
    }
  }
}