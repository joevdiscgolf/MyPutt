part of 'training_cubit.dart';

abstract class TrainingState extends Equatable {
  const TrainingState();
  
  @override
  List<Object?> get props => [];
}

class TrainingInitial extends TrainingState {}

class TrainingLoading extends TrainingState {}

class TrainingInstructionsGenerated extends TrainingState {
  final TrainingSessionInstructions instructions;
  
  const TrainingInstructionsGenerated({required this.instructions});
  
  @override
  List<Object?> get props => [instructions];
}

class TrainingSessionLoading extends TrainingState {}

class TrainingSessionInProgress extends TrainingState {
  final TrainingSession session;
  final CoachingFeedback currentFeedback;
  final GoalEvaluationResult goalProgress;
  
  const TrainingSessionInProgress({
    required this.session,
    required this.currentFeedback,
    required this.goalProgress,
  });
  
  @override
  List<Object?> get props => [session, currentFeedback, goalProgress];
}

class TrainingSessionCompleted extends TrainingState {
  final TrainingSession session;
  final GoalEvaluationResult finalGoalProgress;
  
  const TrainingSessionCompleted({
    required this.session,
    required this.finalGoalProgress,
  });
  
  @override
  List<Object?> get props => [session, finalGoalProgress];
}

class TrainingError extends TrainingState {
  final String message;
  
  const TrainingError({required this.message});
  
  @override
  List<Object?> get props => [message];
}