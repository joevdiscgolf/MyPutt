import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'training_session_instructions.g.dart';

@JsonSerializable()
class TrainingSessionInstructions extends Equatable {
  final String id;
  final String title;
  final String description;
  final List<TrainingSet> trainingSets;
  final List<TrainingGoal> goals;
  final DifficultyLevel difficulty;
  final int estimatedDurationMinutes;
  final DateTime createdAt;
  final String? aiModel;
  final Map<String, dynamic>? metadata;

  const TrainingSessionInstructions({
    required this.id,
    required this.title,
    required this.description,
    required this.trainingSets,
    required this.goals,
    required this.difficulty,
    required this.estimatedDurationMinutes,
    required this.createdAt,
    this.aiModel,
    this.metadata,
  });

  factory TrainingSessionInstructions.fromJson(Map<String, dynamic> json) =>
      _$TrainingSessionInstructionsFromJson(json);

  Map<String, dynamic> toJson() => _$TrainingSessionInstructionsToJson(this);

  TrainingSessionInstructions copyWith({
    String? id,
    String? title,
    String? description,
    List<TrainingSet>? trainingSets,
    List<TrainingGoal>? goals,
    DifficultyLevel? difficulty,
    int? estimatedDurationMinutes,
    DateTime? createdAt,
    String? aiModel,
    Map<String, dynamic>? metadata,
  }) {
    return TrainingSessionInstructions(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      trainingSets: trainingSets ?? this.trainingSets,
      goals: goals ?? this.goals,
      difficulty: difficulty ?? this.difficulty,
      estimatedDurationMinutes: estimatedDurationMinutes ?? this.estimatedDurationMinutes,
      createdAt: createdAt ?? this.createdAt,
      aiModel: aiModel ?? this.aiModel,
      metadata: metadata ?? this.metadata,
    );
  }

  int get totalPutts => trainingSets.fold(0, (sum, set) => sum + set.puttsRequired);

  @override
  List<Object?> get props => [
        id,
        title,
        description,
        trainingSets,
        goals,
        difficulty,
        estimatedDurationMinutes,
        createdAt,
        aiModel,
        metadata,
      ];
}

@JsonSerializable()
class TrainingSet extends Equatable {
  final int distance;
  final int puttsRequired;
  final String? focusArea;
  final String? techniqueTip;

  const TrainingSet({
    required this.distance,
    required this.puttsRequired,
    this.focusArea,
    this.techniqueTip,
  });

  factory TrainingSet.fromJson(Map<String, dynamic> json) =>
      _$TrainingSetFromJson(json);

  Map<String, dynamic> toJson() => _$TrainingSetToJson(this);

  @override
  List<Object?> get props => [distance, puttsRequired, focusArea, techniqueTip];
}

@JsonSerializable()
class TrainingGoal extends Equatable {
  final String id;
  final String description;
  final GoalType type;
  final Map<String, dynamic> targetCriteria;
  final int priority;

  const TrainingGoal({
    required this.id,
    required this.description,
    required this.type,
    required this.targetCriteria,
    this.priority = 1,
  });

  factory TrainingGoal.fromJson(Map<String, dynamic> json) =>
      _$TrainingGoalFromJson(json);

  Map<String, dynamic> toJson() => _$TrainingGoalToJson(this);

  @override
  List<Object?> get props => [id, description, type, targetCriteria, priority];
}

enum GoalType {
  @JsonValue('percentage_at_distance')
  percentageAtDistance,
  @JsonValue('consecutive_makes')
  consecutiveMakes,
  @JsonValue('total_percentage')
  totalPercentage,
  @JsonValue('streak')
  streak,
  @JsonValue('improvement')
  improvement,
}

enum DifficultyLevel {
  @JsonValue('beginner')
  beginner,
  @JsonValue('intermediate')
  intermediate,
  @JsonValue('advanced')
  advanced,
  @JsonValue('expert')
  expert,
}

@JsonSerializable()
class TrainingSession extends Equatable {
  final String id;
  final TrainingSessionInstructions instructions;
  final DateTime startedAt;
  final DateTime? completedAt;
  final List<TrainingSetResult> results;
  final Map<String, bool> goalCompletions;
  final String? userId;
  final bool isCompleted;

  const TrainingSession({
    required this.id,
    required this.instructions,
    required this.startedAt,
    this.completedAt,
    this.results = const [],
    this.goalCompletions = const {},
    this.userId,
    this.isCompleted = false,
  });

  factory TrainingSession.fromJson(Map<String, dynamic> json) =>
      _$TrainingSessionFromJson(json);

  Map<String, dynamic> toJson() => _$TrainingSessionToJson(this);

  TrainingSession copyWith({
    String? id,
    TrainingSessionInstructions? instructions,
    DateTime? startedAt,
    DateTime? completedAt,
    List<TrainingSetResult>? results,
    Map<String, bool>? goalCompletions,
    String? userId,
    bool? isCompleted,
  }) {
    return TrainingSession(
      id: id ?? this.id,
      instructions: instructions ?? this.instructions,
      startedAt: startedAt ?? this.startedAt,
      completedAt: completedAt ?? this.completedAt,
      results: results ?? this.results,
      goalCompletions: goalCompletions ?? this.goalCompletions,
      userId: userId ?? this.userId,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }

  double get overallPercentage {
    if (results.isEmpty) return 0.0;
    final totalMade = results.fold(0, (sum, result) => sum + result.puttsMade);
    final totalAttempted = results.fold(0, (sum, result) => sum + result.puttsAttempted);
    return totalAttempted > 0 ? (totalMade / totalAttempted) * 100 : 0.0;
  }

  int get currentSetIndex => results.length;

  bool get allSetsCompleted => results.length >= instructions.trainingSets.length;

  @override
  List<Object?> get props => [
        id,
        instructions,
        startedAt,
        completedAt,
        results,
        goalCompletions,
        userId,
        isCompleted,
      ];
}

@JsonSerializable()
class TrainingSetResult extends Equatable {
  final int distance;
  final int puttsMade;
  final int puttsAttempted;
  final DateTime timestamp;
  final int? consecutiveMakes;
  final Map<String, dynamic>? metadata;

  const TrainingSetResult({
    required this.distance,
    required this.puttsMade,
    required this.puttsAttempted,
    required this.timestamp,
    this.consecutiveMakes,
    this.metadata,
  });

  factory TrainingSetResult.fromJson(Map<String, dynamic> json) =>
      _$TrainingSetResultFromJson(json);

  Map<String, dynamic> toJson() => _$TrainingSetResultToJson(this);

  double get percentage => puttsAttempted > 0 ? (puttsMade / puttsAttempted) * 100 : 0.0;

  @override
  List<Object?> get props => [
        distance,
        puttsMade,
        puttsAttempted,
        timestamp,
        consecutiveMakes,
        metadata,
      ];
}