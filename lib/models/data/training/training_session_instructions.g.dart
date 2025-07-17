// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'training_session_instructions.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TrainingSessionInstructions _$TrainingSessionInstructionsFromJson(
        Map<String, dynamic> json) =>
    TrainingSessionInstructions(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      trainingSets: (json['trainingSets'] as List<dynamic>)
          .map((e) => TrainingSet.fromJson(e as Map<String, dynamic>))
          .toList(),
      goals: (json['goals'] as List<dynamic>)
          .map((e) => TrainingGoal.fromJson(e as Map<String, dynamic>))
          .toList(),
      difficulty: $enumDecode(_$DifficultyLevelEnumMap, json['difficulty']),
      estimatedDurationMinutes: json['estimatedDurationMinutes'] as int,
      createdAt: DateTime.parse(json['createdAt'] as String),
      aiModel: json['aiModel'] as String?,
      metadata: json['metadata'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$TrainingSessionInstructionsToJson(
        TrainingSessionInstructions instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'trainingSets': instance.trainingSets.map((e) => e.toJson()).toList(),
      'goals': instance.goals.map((e) => e.toJson()).toList(),
      'difficulty': _$DifficultyLevelEnumMap[instance.difficulty]!,
      'estimatedDurationMinutes': instance.estimatedDurationMinutes,
      'createdAt': instance.createdAt.toIso8601String(),
      'aiModel': instance.aiModel,
      'metadata': instance.metadata,
    };

const _$DifficultyLevelEnumMap = {
  DifficultyLevel.beginner: 'beginner',
  DifficultyLevel.intermediate: 'intermediate',
  DifficultyLevel.advanced: 'advanced',
  DifficultyLevel.expert: 'expert',
};

TrainingSet _$TrainingSetFromJson(Map<String, dynamic> json) => TrainingSet(
      distance: json['distance'] as int,
      puttsRequired: json['puttsRequired'] as int,
      focusArea: json['focusArea'] as String?,
      techniqueTip: json['techniqueTip'] as String?,
    );

Map<String, dynamic> _$TrainingSetToJson(TrainingSet instance) =>
    <String, dynamic>{
      'distance': instance.distance,
      'puttsRequired': instance.puttsRequired,
      'focusArea': instance.focusArea,
      'techniqueTip': instance.techniqueTip,
    };

TrainingGoal _$TrainingGoalFromJson(Map<String, dynamic> json) => TrainingGoal(
      id: json['id'] as String,
      description: json['description'] as String,
      type: $enumDecode(_$GoalTypeEnumMap, json['type']),
      targetCriteria: json['targetCriteria'] as Map<String, dynamic>,
      priority: json['priority'] as int? ?? 1,
    );

Map<String, dynamic> _$TrainingGoalToJson(TrainingGoal instance) =>
    <String, dynamic>{
      'id': instance.id,
      'description': instance.description,
      'type': _$GoalTypeEnumMap[instance.type]!,
      'targetCriteria': instance.targetCriteria,
      'priority': instance.priority,
    };

const _$GoalTypeEnumMap = {
  GoalType.percentageAtDistance: 'percentage_at_distance',
  GoalType.consecutiveMakes: 'consecutive_makes',
  GoalType.totalPercentage: 'total_percentage',
  GoalType.streak: 'streak',
  GoalType.improvement: 'improvement',
};

TrainingSession _$TrainingSessionFromJson(Map<String, dynamic> json) =>
    TrainingSession(
      id: json['id'] as String,
      instructions: TrainingSessionInstructions.fromJson(
          json['instructions'] as Map<String, dynamic>),
      startedAt: DateTime.parse(json['startedAt'] as String),
      completedAt: json['completedAt'] == null
          ? null
          : DateTime.parse(json['completedAt'] as String),
      results: (json['results'] as List<dynamic>?)
              ?.map((e) => TrainingSetResult.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      goalCompletions: (json['goalCompletions'] as Map<String, dynamic>?)?.map(
            (k, e) => MapEntry(k, e as bool),
          ) ??
          const {},
      userId: json['userId'] as String?,
      isCompleted: json['isCompleted'] as bool? ?? false,
    );

Map<String, dynamic> _$TrainingSessionToJson(TrainingSession instance) =>
    <String, dynamic>{
      'id': instance.id,
      'instructions': instance.instructions.toJson(),
      'startedAt': instance.startedAt.toIso8601String(),
      'completedAt': instance.completedAt?.toIso8601String(),
      'results': instance.results.map((e) => e.toJson()).toList(),
      'goalCompletions': instance.goalCompletions,
      'userId': instance.userId,
      'isCompleted': instance.isCompleted,
    };

TrainingSetResult _$TrainingSetResultFromJson(Map<String, dynamic> json) =>
    TrainingSetResult(
      distance: json['distance'] as int,
      puttsMade: json['puttsMade'] as int,
      puttsAttempted: json['puttsAttempted'] as int,
      timestamp: DateTime.parse(json['timestamp'] as String),
      consecutiveMakes: json['consecutiveMakes'] as int?,
      metadata: json['metadata'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$TrainingSetResultToJson(TrainingSetResult instance) =>
    <String, dynamic>{
      'distance': instance.distance,
      'puttsMade': instance.puttsMade,
      'puttsAttempted': instance.puttsAttempted,
      'timestamp': instance.timestamp.toIso8601String(),
      'consecutiveMakes': instance.consecutiveMakes,
      'metadata': instance.metadata,
    };