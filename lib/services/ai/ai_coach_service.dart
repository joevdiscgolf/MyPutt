import 'package:myputt/models/data/sessions/putting_session.dart';
import 'package:myputt/models/data/training/training_session_instructions.dart';
import 'package:myputt/models/data/stats/stats.dart';

abstract class AICoachService {
  /// Generates a personalized training session based on putting history
  Future<TrainingSessionInstructions> generateTrainingSession({
    required List<PuttingSession> puttingHistory,
    Stats? userStats,
    DifficultyLevel? preferredDifficulty,
    int? targetDurationMinutes,
  });

  /// Provides real-time coaching feedback based on current progress
  Future<CoachingFeedback> provideCoachingFeedback({
    required TrainingSession currentSession,
    required TrainingSetResult? lastSetResult,
    required int currentSetIndex,
  });

  /// Evaluates progress towards session goals
  Future<GoalEvaluationResult> evaluateGoalProgress({
    required List<TrainingGoal> goals,
    required List<TrainingSetResult> results,
    required TrainingSession session,
  });

  /// Analyzes overall performance and provides insights
  Future<PerformanceAnalysis> analyzePerformance({
    required List<PuttingSession> recentSessions,
    required Stats userStats,
  });

  /// Gets a motivational message based on current state
  Future<String> getMotivationalMessage({
    required TrainingSession session,
    required double currentPercentage,
  });

  /// Suggests adjustments to the training plan mid-session
  Future<TrainingAdjustment?> suggestMidSessionAdjustment({
    required TrainingSession session,
    required List<TrainingSetResult> completedSets,
  });
}

class CoachingFeedback {
  final String message;
  final FeedbackTone tone;
  final String? technicalAdvice;
  final String? encouragement;
  final List<String>? focusPoints;

  CoachingFeedback({
    required this.message,
    required this.tone,
    this.technicalAdvice,
    this.encouragement,
    this.focusPoints,
  });

  factory CoachingFeedback.fromJson(Map<String, dynamic> json) {
    return CoachingFeedback(
      message: json['message'] as String,
      tone: FeedbackTone.values.firstWhere(
        (e) => e.toString().split('.').last == json['tone'],
        orElse: () => FeedbackTone.neutral,
      ),
      technicalAdvice: json['technicalAdvice'] as String?,
      encouragement: json['encouragement'] as String?,
      focusPoints: (json['focusPoints'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
        'message': message,
        'tone': tone.toString().split('.').last,
        'technicalAdvice': technicalAdvice,
        'encouragement': encouragement,
        'focusPoints': focusPoints,
      };
}

enum FeedbackTone {
  positive,
  encouraging,
  neutral,
  constructive,
  celebratory,
}

class GoalEvaluationResult {
  final Map<String, GoalProgress> goalProgress;
  final List<String> completedGoalIds;
  final String summary;
  final double overallProgress;

  GoalEvaluationResult({
    required this.goalProgress,
    required this.completedGoalIds,
    required this.summary,
    required this.overallProgress,
  });

  factory GoalEvaluationResult.fromJson(Map<String, dynamic> json) {
    return GoalEvaluationResult(
      goalProgress: (json['goalProgress'] as Map<String, dynamic>).map(
        (key, value) => MapEntry(key, GoalProgress.fromJson(value)),
      ),
      completedGoalIds: List<String>.from(json['completedGoalIds']),
      summary: json['summary'] as String,
      overallProgress: (json['overallProgress'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() => {
        'goalProgress': goalProgress.map((key, value) => MapEntry(key, value.toJson())),
        'completedGoalIds': completedGoalIds,
        'summary': summary,
        'overallProgress': overallProgress,
      };
}

class GoalProgress {
  final String goalId;
  final double progressPercentage;
  final bool isCompleted;
  final String statusMessage;
  final dynamic currentValue;
  final dynamic targetValue;

  GoalProgress({
    required this.goalId,
    required this.progressPercentage,
    required this.isCompleted,
    required this.statusMessage,
    this.currentValue,
    this.targetValue,
  });

  factory GoalProgress.fromJson(Map<String, dynamic> json) {
    return GoalProgress(
      goalId: json['goalId'] as String,
      progressPercentage: (json['progressPercentage'] as num).toDouble(),
      isCompleted: json['isCompleted'] as bool,
      statusMessage: json['statusMessage'] as String,
      currentValue: json['currentValue'],
      targetValue: json['targetValue'],
    );
  }

  Map<String, dynamic> toJson() => {
        'goalId': goalId,
        'progressPercentage': progressPercentage,
        'isCompleted': isCompleted,
        'statusMessage': statusMessage,
        'currentValue': currentValue,
        'targetValue': targetValue,
      };
}

class PerformanceAnalysis {
  final Map<int, double> distancePerformance;
  final List<String> strengths;
  final List<String> areasForImprovement;
  final double overallTrend;
  final String summary;
  final List<InsightPoint> insights;

  PerformanceAnalysis({
    required this.distancePerformance,
    required this.strengths,
    required this.areasForImprovement,
    required this.overallTrend,
    required this.summary,
    required this.insights,
  });

  factory PerformanceAnalysis.fromJson(Map<String, dynamic> json) {
    return PerformanceAnalysis(
      distancePerformance: Map<int, double>.from(
        (json['distancePerformance'] as Map).map(
          (key, value) => MapEntry(int.parse(key.toString()), (value as num).toDouble()),
        ),
      ),
      strengths: List<String>.from(json['strengths']),
      areasForImprovement: List<String>.from(json['areasForImprovement']),
      overallTrend: (json['overallTrend'] as num).toDouble(),
      summary: json['summary'] as String,
      insights: (json['insights'] as List<dynamic>)
          .map((e) => InsightPoint.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
        'distancePerformance': distancePerformance.map((key, value) => MapEntry(key.toString(), value)),
        'strengths': strengths,
        'areasForImprovement': areasForImprovement,
        'overallTrend': overallTrend,
        'summary': summary,
        'insights': insights.map((e) => e.toJson()).toList(),
      };
}

class InsightPoint {
  final String category;
  final String message;
  final double importance;
  final String? actionItem;

  InsightPoint({
    required this.category,
    required this.message,
    required this.importance,
    this.actionItem,
  });

  factory InsightPoint.fromJson(Map<String, dynamic> json) {
    return InsightPoint(
      category: json['category'] as String,
      message: json['message'] as String,
      importance: (json['importance'] as num).toDouble(),
      actionItem: json['actionItem'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'category': category,
        'message': message,
        'importance': importance,
        'actionItem': actionItem,
      };
}

class TrainingAdjustment {
  final String reason;
  final List<TrainingSet> adjustedSets;
  final String explanation;

  TrainingAdjustment({
    required this.reason,
    required this.adjustedSets,
    required this.explanation,
  });

  factory TrainingAdjustment.fromJson(Map<String, dynamic> json) {
    return TrainingAdjustment(
      reason: json['reason'] as String,
      adjustedSets: (json['adjustedSets'] as List<dynamic>)
          .map((e) => TrainingSet.fromJson(e))
          .toList(),
      explanation: json['explanation'] as String,
    );
  }

  Map<String, dynamic> toJson() => {
        'reason': reason,
        'adjustedSets': adjustedSets.map((e) => e.toJson()).toList(),
        'explanation': explanation,
      };
}