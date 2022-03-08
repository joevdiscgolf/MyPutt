part of 'challenges_cubit.dart';

abstract class ChallengesState {
  const ChallengesState();
}

class ChallengesInitial extends ChallengesState {}

class ChallengesLoading extends ChallengesState {}

class ChallengesErrorState extends ChallengesState {}

class ChallengeInProgress extends ChallengesState {
  ChallengeInProgress({
    required this.currentChallenge,
    required this.activeChallenges,
    required this.pendingChallenges,
    required this.completedChallenges,
  });
  final PuttingChallenge currentChallenge;
  final List<PuttingChallenge> activeChallenges;
  final List<PuttingChallenge> pendingChallenges;
  final List<PuttingChallenge> completedChallenges;
}

class CurrentUserComplete extends ChallengesState {
  CurrentUserComplete({
    required this.currentChallenge,
    required this.activeChallenges,
    required this.pendingChallenges,
    required this.completedChallenges,
  });
  final PuttingChallenge currentChallenge;
  final List<PuttingChallenge> activeChallenges;
  final List<PuttingChallenge> pendingChallenges;
  final List<PuttingChallenge> completedChallenges;
}

class NoCurrentChallenge extends ChallengesState {
  NoCurrentChallenge(
      {required this.activeChallenges,
      required this.pendingChallenges,
      required this.completedChallenges});
  final List<PuttingChallenge> activeChallenges;
  final List<PuttingChallenge> pendingChallenges;
  final List<PuttingChallenge> completedChallenges;
}
