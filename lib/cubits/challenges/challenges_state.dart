part of 'challenges_cubit.dart';

enum ChallengeStage {
  ongoing,
  bothUsersComplete,
  currentUserComplete,
  opponentUserComplete,
  finished,
}

abstract class ChallengesState {
  const ChallengesState({
    required this.activeChallenges,
    required this.incomingPendingChallenges,
    required this.completedChallenges,
  });
  final List<PuttingChallenge> activeChallenges;
  final List<PuttingChallenge> incomingPendingChallenges;
  final List<PuttingChallenge> completedChallenges;
}

class ChallengesLoading extends ChallengesState {
  ChallengesLoading({
    required this.currentChallenge,
    required List<PuttingChallenge> activeChallenges,
    required List<PuttingChallenge> pendingChallenges,
    required List<PuttingChallenge> completedChallenges,
  }) : super(
          activeChallenges: activeChallenges,
          incomingPendingChallenges: pendingChallenges,
          completedChallenges: completedChallenges,
        );

  final PuttingChallenge? currentChallenge;
}

class ChallengesErrorState extends ChallengesState {
  ChallengesErrorState({
    required this.currentChallenge,
    List<PuttingChallenge> activeChallenges = const [],
    List<PuttingChallenge> pendingChallenges = const [],
    List<PuttingChallenge> completedChallenges = const [],
  }) : super(
          activeChallenges: activeChallenges,
          incomingPendingChallenges: pendingChallenges,
          completedChallenges: completedChallenges,
        );

  final PuttingChallenge? currentChallenge;
}

class CurrentChallengeState extends ChallengesState {
  CurrentChallengeState({
    required this.challengeStage,
    required this.currentChallenge,
    required List<PuttingChallenge> activeChallenges,
    required List<PuttingChallenge> pendingChallenges,
    required List<PuttingChallenge> completedChallenges,
  }) : super(
          activeChallenges: activeChallenges,
          incomingPendingChallenges: pendingChallenges,
          completedChallenges: completedChallenges,
        );
  final PuttingChallenge currentChallenge;
  final ChallengeStage challengeStage;
}

class NoCurrentChallengeState extends ChallengesState {
  NoCurrentChallengeState({
    required List<PuttingChallenge> activeChallenges,
    required List<PuttingChallenge> pendingChallenges,
    required List<PuttingChallenge> completedChallenges,
  }) : super(
          activeChallenges: activeChallenges,
          incomingPendingChallenges: pendingChallenges,
          completedChallenges: completedChallenges,
        );
}
