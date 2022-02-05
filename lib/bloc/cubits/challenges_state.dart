part of 'challenges_cubit.dart';

abstract class ChallengesState {
  const ChallengesState();
}

class ChallengesInitial extends ChallengesState {}

class ChallengeInProgress extends ChallengesState {
  ChallengeInProgress(
      {required this.challengeStructureDistances,
      required this.challengerScores,
      required this.currentUserScores});
  final List<int> challengeStructureDistances; // = [10,10,15,15,20,20];
  final List<int> challengerScores; // = [6,6,7,5,4,4];
  final List<int> currentUserScores;
}
