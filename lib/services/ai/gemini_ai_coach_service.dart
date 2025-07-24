import 'dart:convert';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:myputt/models/data/sessions/putting_session.dart';
import 'package:myputt/models/data/sessions/putting_set.dart';
import 'package:myputt/models/data/stats/stats.dart';
import 'package:myputt/models/data/training/training_session_instructions.dart';
import 'package:myputt/models/data/ai/gemini_model.dart';
import 'package:myputt/services/ai/ai_coach_service.dart';

class GeminiAICoachService extends AICoachService {
  late GenerativeModel _model;
  final String apiKey;
  GeminiModel _currentModel = GeminiModel.flash;

  GeminiAICoachService({required this.apiKey, GeminiModel? initialModel}) {
    _currentModel = initialModel ?? GeminiModel.flash;
    _initializeModel();
  }
  
  void _initializeModel() {
    final config = _currentModel.generationConfig;
    _model = GenerativeModel(
      model: _currentModel.modelName,
      apiKey: apiKey,
      generationConfig: GenerationConfig(
        temperature: config['temperature'] as double,
        topK: config['topK'] as int,
        topP: config['topP'] as double,
        maxOutputTokens: config['maxOutputTokens'] as int,
      ),
    );
  }
  
  void switchModel(GeminiModel newModel) {
    _currentModel = newModel;
    _initializeModel();
  }
  
  GeminiModel get currentModel => _currentModel;

  @override
  Future<TrainingSessionInstructions> generateTrainingSession({
    required List<PuttingSession> puttingHistory,
    Stats? userStats,
    DifficultyLevel? preferredDifficulty,
    int? targetDurationMinutes,
  }) async {
    try {
      // Limit history to last 3 sessions for faster processing
      final recentHistory = puttingHistory.take(3).toList();
      final historyData = _preparePuttingHistoryData(recentHistory);
      final statsData = _prepareStatsData(userStats);
      
      final prompt = '''
Create a putting training session.

RECENT PERFORMANCE (last 3 sessions):
$historyData

DIFFICULTY: ${preferredDifficulty?.toString().split('.').last ?? 'intermediate'}
DURATION: ${targetDurationMinutes ?? 30} minutes

Requirements:
- All distances >= 10 feet
- Include 3 measurable goals
- Focus on weak areas

Return ONLY valid JSON:
{
  "id": "unique_id",
  "title": "Session Title",
  "description": "Brief description of the session focus",
  "trainingSets": [
    {
      "distance": 10,
      "puttsRequired": 10,
      "focusArea": "Distance control",
      "techniqueTip": "Focus on pendulum motion"
    }
  ],
  "goals": [
    {
      "id": "goal1",
      "description": "Make 75% of putts from 25 feet",
      "type": "percentage_at_distance",
      "targetCriteria": {
        "distance": 25,
        "targetPercentage": 75
      },
      "priority": 1
    }
  ],
  "difficulty": "${preferredDifficulty?.toString().split('.').last ?? 'intermediate'}",
  "estimatedDurationMinutes": ${targetDurationMinutes ?? 30}
}
''';

      final response = await _model.generateContent([Content.text(prompt)]);
      final text = response.text;
      
      if (text == null) {
        throw Exception('No response from Gemini');
      }

      // Extract JSON from response
      final jsonMatch = RegExp(r'\{[\s\S]*\}').firstMatch(text);
      if (jsonMatch == null) {
        throw Exception('No valid JSON in response');
      }

      final json = jsonDecode(jsonMatch.group(0)!);
      
      // Add metadata
      json['createdAt'] = DateTime.now().toIso8601String();
      json['aiModel'] = _currentModel.modelName;
      
      return TrainingSessionInstructions.fromJson(json);
    } catch (e) {
      // Error generating training session
      // Return a fallback training session
      return _createFallbackTrainingSession(preferredDifficulty, targetDurationMinutes);
    }
  }

  @override
  Future<CoachingFeedback> provideCoachingFeedback({
    required TrainingSession currentSession,
    required TrainingSetResult? lastSetResult,
    required int currentSetIndex,
  }) async {
    try {
      // Don't mention performance percentages if no putts have been attempted
      final hasAttempts = currentSession.results.isNotEmpty;
      
      final prompt = '''
You are an encouraging putting coach. Provide feedback based on the current training session progress.

Current Session: ${currentSession.instructions.title}
Set ${currentSetIndex + 1} of ${currentSession.instructions.trainingSets.length}
${lastSetResult != null ? 'Last set: ${lastSetResult.puttsMade}/${lastSetResult.puttsAttempted} from ${lastSetResult.distance} feet' : 'First set - no putts attempted yet'}
${hasAttempts ? 'Overall performance: ${currentSession.overallPercentage.toStringAsFixed(1)}%' : 'Starting fresh - focus on good fundamentals'}

IMPORTANT: If this is the first set or no putts have been attempted yet, DO NOT mention any performance percentages or say that 0% is normal. Instead, focus on preparation, setup, and encouragement for starting the session.

Provide coaching feedback in JSON format:
{
  "message": "Main feedback message",
  "tone": "positive/encouraging/neutral/constructive/celebratory",
  "technicalAdvice": "Optional technical tip",
  "encouragement": "Motivational message",
  "focusPoints": ["Point 1", "Point 2"]
}
''';

      final response = await _model.generateContent([Content.text(prompt)]);
      final text = response.text;
      
      if (text == null) {
        throw Exception('No response from Gemini');
      }

      final jsonMatch = RegExp(r'\{[\s\S]*\}').firstMatch(text);
      if (jsonMatch == null) {
        throw Exception('No valid JSON in response');
      }

      final json = jsonDecode(jsonMatch.group(0)!);
      return CoachingFeedback.fromJson(json);
    } catch (e) {
      // Error providing coaching feedback
      return _createFallbackFeedback(lastSetResult, currentSession.overallPercentage);
    }
  }

  @override
  Future<GoalEvaluationResult> evaluateGoalProgress({
    required List<TrainingGoal> goals,
    required List<TrainingSetResult> results,
    required TrainingSession session,
  }) async {
    try {
      final goalProgress = <String, GoalProgress>{};
      final completedGoalIds = <String>[];

      for (final goal in goals) {
        final progress = _evaluateGoal(goal, results);
        goalProgress[goal.id] = progress;
        if (progress.isCompleted) {
          completedGoalIds.add(goal.id);
        }
      }

      final overallProgress = completedGoalIds.length / goals.length * 100;

      return GoalEvaluationResult(
        goalProgress: goalProgress,
        completedGoalIds: completedGoalIds,
        summary: 'You completed ${completedGoalIds.length} out of ${goals.length} goals!',
        overallProgress: overallProgress,
      );
    } catch (e) {
      // Error evaluating goal progress
      return GoalEvaluationResult(
        goalProgress: {},
        completedGoalIds: [],
        summary: 'Unable to evaluate goals',
        overallProgress: 0,
      );
    }
  }

  @override
  Future<PerformanceAnalysis> analyzePerformance({
    required List<PuttingSession> recentSessions,
    required Stats userStats,
  }) async {
    try {
      final prompt = '''
Analyze the user's putting performance and provide insights.

Recent sessions data:
${_preparePuttingHistoryData(recentSessions)}

Stats:
${_prepareStatsData(userStats)}

Provide analysis in JSON format:
{
  "distancePerformance": {"10": 85.5, "20": 72.3, "30": 45.0},
  "strengths": ["Consistent from 10 feet", "Good distance control"],
  "areasForImprovement": ["Long putts over 30 feet", "Consistency on breaking putts"],
  "overallTrend": 5.2,
  "summary": "Overall performance analysis",
  "insights": [
    {
      "category": "technique",
      "message": "Your short putt accuracy is excellent",
      "importance": 0.9,
      "actionItem": "Maintain current routine"
    }
  ]
}
''';

      final response = await _model.generateContent([Content.text(prompt)]);
      final text = response.text;
      
      if (text == null) {
        throw Exception('No response from Gemini');
      }

      final jsonMatch = RegExp(r'\{[\s\S]*\}').firstMatch(text);
      if (jsonMatch == null) {
        throw Exception('No valid JSON in response');
      }

      final json = jsonDecode(jsonMatch.group(0)!);
      return PerformanceAnalysis.fromJson(json);
    } catch (e) {
      // Error analyzing performance
      return _createFallbackAnalysis(userStats);
    }
  }

  @override
  Future<String> getMotivationalMessage({
    required TrainingSession session,
    required double currentPercentage,
  }) async {
    try {
      final prompt = '''
Provide a short motivational message for a golfer.
Current session: ${session.instructions.title}
Performance: ${currentPercentage.toStringAsFixed(1)}%
Progress: ${session.currentSetIndex} of ${session.instructions.trainingSets.length} sets completed

Return only the motivational message, no JSON or formatting.
''';

      final response = await _model.generateContent([Content.text(prompt)]);
      return response.text ?? 'Keep up the great work!';
    } catch (e) {
      return 'You\'re doing great! Stay focused and trust your stroke.';
    }
  }

  @override
  Future<TrainingAdjustment?> suggestMidSessionAdjustment({
    required TrainingSession session,
    required List<TrainingSetResult> completedSets,
  }) async {
    if (completedSets.length < 3) return null;

    try {
      final recentPerformance = completedSets.take(3).map((s) => s.percentage).reduce((a, b) => a + b) / 3;
      
      if (recentPerformance < 40) {
        // Suggest easier distances
        final remainingSets = session.instructions.trainingSets
            .skip(completedSets.length)
            .map((set) => TrainingSet(
                  distance: ((set.distance * 0.8).round()).clamp(10, 50),
                  puttsRequired: set.puttsRequired,
                  focusArea: set.focusArea,
                  techniqueTip: 'Focus on solid contact and alignment',
                ))
            .toList();

        return TrainingAdjustment(
          reason: 'performance_below_target',
          adjustedSets: remainingSets,
          explanation: 'I\'ve adjusted the distances to help you build confidence. Focus on solid fundamentals.',
        );
      }
      
      return null;
    } catch (e) {
      // Error suggesting adjustment
      return null;
    }
  }

  // Helper methods
  String _preparePuttingHistoryData(List<PuttingSession> sessions) {
    if (sessions.isEmpty) return 'No history';
    
    // Aggregate all distances across sessions for a more concise view
    final distanceAggregates = <int, List<int>>{};
    
    for (final session in sessions) {
      for (final set in session.sets) {
        distanceAggregates.putIfAbsent(set.distance, () => [0, 0]);
        distanceAggregates[set.distance]![0] += set.puttsMade;
        distanceAggregates[set.distance]![1] += set.puttsAttempted;
      }
    }
    
    // Create concise summary
    final summary = distanceAggregates.entries
        .where((e) => e.value[1] > 0)
        .map((e) => '${e.key}ft:${(e.value[0] / e.value[1] * 100).toStringAsFixed(0)}%')
        .join(', ');
    
    return summary.isEmpty ? 'No history' : summary;
  }

  String _prepareStatsData(Stats? stats) {
    if (stats == null) return 'No stats available';
    
    final circle1Stats = stats.circleOnePercentages?.entries
        .map((e) => '${e.key}ft: ${e.value?.toStringAsFixed(1) ?? '0.0'}%')
        .join(', ') ?? 'No data';
    
    final circle2Stats = stats.circleTwoPercentages?.entries
        .map((e) => '${e.key}ft: ${e.value?.toStringAsFixed(1) ?? '0.0'}%')
        .join(', ') ?? 'No data';
    
    final totalMade = stats.generalStats?.totalMade ?? 0;
    final totalAttempts = stats.generalStats?.totalAttempts ?? 0;
    final overallPercentage = totalAttempts > 0 ? (totalMade / totalAttempts * 100).toStringAsFixed(1) : '0.0';
    
    return '''
Circle 1 (3-10ft): $circle1Stats
Circle 2 (10-20ft): $circle2Stats
Overall: $overallPercentage%
''';
  }

  GoalProgress _evaluateGoal(TrainingGoal goal, List<TrainingSetResult> results) {
    switch (goal.type) {
      case GoalType.percentageAtDistance:
        final targetDistance = goal.targetCriteria['distance'] as int;
        final targetPercentage = goal.targetCriteria['targetPercentage'] as num;
        
        final relevantSets = results.where((r) => r.distance == targetDistance).toList();
        if (relevantSets.isEmpty) {
          return GoalProgress(
            goalId: goal.id,
            progressPercentage: 0,
            isCompleted: false,
            statusMessage: 'No attempts at $targetDistance feet yet',
            currentValue: 0,
            targetValue: targetPercentage,
          );
        }
        
        final totalMade = relevantSets.fold(0, (sum, set) => sum + set.puttsMade);
        final totalAttempted = relevantSets.fold(0, (sum, set) => sum + set.puttsAttempted);
        final percentage = totalAttempted > 0 ? (totalMade / totalAttempted * 100) : 0.0;
        
        return GoalProgress(
          goalId: goal.id,
          progressPercentage: (percentage / targetPercentage * 100).clamp(0, 100),
          isCompleted: percentage >= targetPercentage,
          statusMessage: '${percentage.toStringAsFixed(1)}% from $targetDistance feet',
          currentValue: percentage,
          targetValue: targetPercentage,
        );
        
      case GoalType.consecutiveMakes:
        final targetCount = goal.targetCriteria['count'] as int;
        int maxConsecutive = 0;
            
        for (final result in results) {
          if (result.consecutiveMakes != null) {
            maxConsecutive = result.consecutiveMakes! > maxConsecutive 
                ? result.consecutiveMakes! 
                : maxConsecutive;
          }
        }
        
        return GoalProgress(
          goalId: goal.id,
          progressPercentage: (maxConsecutive / targetCount * 100).clamp(0, 100),
          isCompleted: maxConsecutive >= targetCount,
          statusMessage: 'Best streak: $maxConsecutive putts',
          currentValue: maxConsecutive,
          targetValue: targetCount,
        );
        
      default:
        return GoalProgress(
          goalId: goal.id,
          progressPercentage: 0,
          isCompleted: false,
          statusMessage: 'Goal evaluation not implemented',
        );
    }
  }

  TrainingSessionInstructions _createFallbackTrainingSession(
    DifficultyLevel? difficulty,
    int? duration,
  ) {
    final id = DateTime.now().millisecondsSinceEpoch.toString();
    final sets = <TrainingSet>[];
    
    // Create a balanced session based on difficulty
    switch (difficulty ?? DifficultyLevel.intermediate) {
      case DifficultyLevel.beginner:
        sets.addAll([
          TrainingSet(distance: 10, puttsRequired: 10, focusArea: 'Setup and alignment'),
          TrainingSet(distance: 10, puttsRequired: 10, focusArea: 'Distance control'),
          TrainingSet(distance: 15, puttsRequired: 10, focusArea: 'Smooth stroke'),
        ]);
        break;
      case DifficultyLevel.intermediate:
        sets.addAll([
          TrainingSet(distance: 10, puttsRequired: 10, focusArea: 'Consistency'),
          TrainingSet(distance: 20, puttsRequired: 10, focusArea: 'Distance control'),
          TrainingSet(distance: 30, puttsRequired: 10, focusArea: 'Lag putting'),
        ]);
        break;
      case DifficultyLevel.advanced:
      case DifficultyLevel.expert:
        sets.addAll([
          TrainingSet(distance: 15, puttsRequired: 10, focusArea: 'Precision'),
          TrainingSet(distance: 25, puttsRequired: 10, focusArea: 'Distance control'),
          TrainingSet(distance: 35, puttsRequired: 10, focusArea: 'Lag putting'),
          TrainingSet(distance: 45, puttsRequired: 5, focusArea: 'Long range'),
        ]);
        break;
    }
    
    final goals = [
      TrainingGoal(
        id: 'goal1',
        description: 'Make 70% of putts from 10 feet',
        type: GoalType.percentageAtDistance,
        targetCriteria: {'distance': 10, 'targetPercentage': 70},
        priority: 1,
      ),
      TrainingGoal(
        id: 'goal2',
        description: 'Make 5 putts in a row',
        type: GoalType.consecutiveMakes,
        targetCriteria: {'count': 5},
        priority: 2,
      ),
      TrainingGoal(
        id: 'goal3',
        description: 'Achieve 60% overall',
        type: GoalType.totalPercentage,
        targetCriteria: {'targetPercentage': 60},
        priority: 3,
      ),
    ];
    
    return TrainingSessionInstructions(
      id: id,
      title: 'Balanced Putting Practice',
      description: 'A well-rounded session to improve your putting at various distances',
      trainingSets: sets,
      goals: goals,
      difficulty: difficulty ?? DifficultyLevel.intermediate,
      estimatedDurationMinutes: duration ?? 30,
      createdAt: DateTime.now(),
      aiModel: 'fallback',
    );
  }

  CoachingFeedback _createFallbackFeedback(
    TrainingSetResult? lastSetResult,
    double overallPercentage,
  ) {
    FeedbackTone tone;
    String message;
    String encouragement;
    
    if (lastSetResult == null) {
      tone = FeedbackTone.encouraging;
      message = 'Let\'s get started! Focus on your setup and take your time.';
      encouragement = 'You\'ve got this!';
    } else if (lastSetResult.percentage >= 80) {
      tone = FeedbackTone.celebratory;
      message = 'Excellent putting! You made ${lastSetResult.puttsMade} out of ${lastSetResult.puttsAttempted}.';
      encouragement = 'Keep up the fantastic work!';
    } else if (lastSetResult.percentage >= 60) {
      tone = FeedbackTone.positive;
      message = 'Good set! You\'re showing solid consistency.';
      encouragement = 'Stay focused and trust your stroke.';
    } else {
      tone = FeedbackTone.constructive;
      message = 'Keep working on your alignment and tempo.';
      encouragement = 'Every putt is a chance to improve!';
    }
    
    return CoachingFeedback(
      message: message,
      tone: tone,
      encouragement: encouragement,
      focusPoints: ['Maintain steady head position', 'Follow through to target'],
    );
  }

  PerformanceAnalysis _createFallbackAnalysis(Stats? stats) {
    final distancePerformance = <int, double>{};
    final strengths = <String>[];
    final improvements = <String>[];
    
    if (stats != null) {
      if (stats.circleOnePercentages != null) {
        distancePerformance.addAll(stats.circleOnePercentages!.map((k, v) => MapEntry(k, v?.toDouble() ?? 0.0)));
      }
      if (stats.circleTwoPercentages != null) {
        distancePerformance.addAll(stats.circleTwoPercentages!.map((k, v) => MapEntry(k, v?.toDouble() ?? 0.0)));
      }
      
      // Identify strengths
      distancePerformance.forEach((distance, percentage) {
        if (percentage >= 70) {
          strengths.add('Strong performance from $distance feet');
        } else if (percentage < 50) {
          improvements.add('Practice more from $distance feet');
        }
      });
    }
    
    if (strengths.isEmpty) strengths.add('Consistent effort and practice');
    if (improvements.isEmpty) improvements.add('Continue building confidence at all distances');
    
    return PerformanceAnalysis(
      distancePerformance: distancePerformance,
      strengths: strengths,
      areasForImprovement: improvements,
      overallTrend: 0,
      summary: 'Keep practicing to improve your putting consistency',
      insights: [
        InsightPoint(
          category: 'practice',
          message: 'Regular practice sessions will improve your muscle memory',
          importance: 0.8,
          actionItem: 'Practice 3-4 times per week',
        ),
      ],
    );
  }
}