part of 'challenges_cubit.dart';

abstract class ChallengesState {
  const ChallengesState();
}

class ChallengesInitial extends ChallengesState {}

class ChallengesErrorState extends ChallengesState {}

class ChallengeInProgress extends ChallengesState {
  ChallengeInProgress({required this.currentChallenge});
  final PuttingChallenge currentChallenge;
}
