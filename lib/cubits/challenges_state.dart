part of 'challenges_cubit.dart';

abstract class ChallengesState {
  const ChallengesState({
    required this.currentChallenge,
    required this.activeChallenges,
    required this.pendingChallenges,
    required this.completedChallenges,
  });
  final PuttingChallenge? currentChallenge;
  final List<PuttingChallenge> activeChallenges;
  final List<PuttingChallenge> pendingChallenges;
  final List<PuttingChallenge> completedChallenges;
}

class ChallengesInitial extends ChallengesState {
  ChallengesInitial(
      {required PuttingChallenge? currentChallenge,
      required List<PuttingChallenge> activeChallenges,
      required List<PuttingChallenge> pendingChallenges,
      required List<PuttingChallenge> completedChallenges})
      : super(
            currentChallenge: currentChallenge,
            activeChallenges: activeChallenges,
            pendingChallenges: pendingChallenges,
            completedChallenges: completedChallenges);
}

class ChallengesLoading extends ChallengesState {
  ChallengesLoading(
      {required PuttingChallenge? currentChallenge,
      required List<PuttingChallenge> activeChallenges,
      required List<PuttingChallenge> pendingChallenges,
      required List<PuttingChallenge> completedChallenges})
      : super(
            currentChallenge: currentChallenge,
            activeChallenges: activeChallenges,
            pendingChallenges: pendingChallenges,
            completedChallenges: completedChallenges);
}

class ChallengesErrorState extends ChallengesState {
  ChallengesErrorState(
      {required PuttingChallenge? currentChallenge,
      required List<PuttingChallenge> activeChallenges,
      required List<PuttingChallenge> pendingChallenges,
      required List<PuttingChallenge> completedChallenges})
      : super(
            currentChallenge: currentChallenge,
            activeChallenges: activeChallenges,
            pendingChallenges: pendingChallenges,
            completedChallenges: completedChallenges);
}

class ChallengeInProgress extends ChallengesState {
  ChallengeInProgress(
      {required PuttingChallenge? currentChallenge,
      required List<PuttingChallenge> activeChallenges,
      required List<PuttingChallenge> pendingChallenges,
      required List<PuttingChallenge> completedChallenges})
      : super(
            currentChallenge: currentChallenge,
            activeChallenges: activeChallenges,
            pendingChallenges: pendingChallenges,
            completedChallenges: completedChallenges);
}

class CurrentUserComplete extends ChallengesState {
  CurrentUserComplete(
      {required PuttingChallenge? currentChallenge,
      required List<PuttingChallenge> activeChallenges,
      required List<PuttingChallenge> pendingChallenges,
      required List<PuttingChallenge> completedChallenges})
      : super(
            currentChallenge: currentChallenge,
            activeChallenges: activeChallenges,
            pendingChallenges: pendingChallenges,
            completedChallenges: completedChallenges);
}

class BothUsersComplete extends ChallengesState {
  BothUsersComplete(
      {required PuttingChallenge? currentChallenge,
      required List<PuttingChallenge> activeChallenges,
      required List<PuttingChallenge> pendingChallenges,
      required List<PuttingChallenge> completedChallenges})
      : super(
            currentChallenge: currentChallenge,
            activeChallenges: activeChallenges,
            pendingChallenges: pendingChallenges,
            completedChallenges: completedChallenges);
}

class OpponentUserComplete extends ChallengesState {
  OpponentUserComplete(
      {required PuttingChallenge? currentChallenge,
      required List<PuttingChallenge> activeChallenges,
      required List<PuttingChallenge> pendingChallenges,
      required List<PuttingChallenge> completedChallenges})
      : super(
            currentChallenge: currentChallenge,
            activeChallenges: activeChallenges,
            pendingChallenges: pendingChallenges,
            completedChallenges: completedChallenges);
}

class NoCurrentChallenge extends ChallengesState {
  NoCurrentChallenge(
      {required PuttingChallenge? currentChallenge,
      required List<PuttingChallenge> activeChallenges,
      required List<PuttingChallenge> pendingChallenges,
      required List<PuttingChallenge> completedChallenges})
      : super(
            currentChallenge: currentChallenge,
            activeChallenges: activeChallenges,
            pendingChallenges: pendingChallenges,
            completedChallenges: completedChallenges);
}
