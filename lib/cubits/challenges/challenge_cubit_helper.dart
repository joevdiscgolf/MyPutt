import 'package:myputt/cubits/challenges/challenges_cubit.dart';
import 'package:myputt/locator.dart';
import 'package:myputt/models/data/challenges/putting_challenge.dart';
import 'package:myputt/protocols/singleton_consumer.dart';
import 'package:myputt/repositories/challenges_repository.dart';
import 'package:myputt/utils/constants.dart';

class ChallengesCubitHelper implements SingletonConsumer {
  @override
  void initSingletons() {
    _challengesRepository = locator.get<ChallengesRepository>();
  }

  late final ChallengesRepository _challengesRepository;

  ChallengeStage getChallengeStage(PuttingChallenge challenge) {
    final structureLength = challenge.challengeStructure.length;
    final currentUserSetsCount = challenge.currentUserSets.length;
    final opponentUserSetsCount = challenge.opponentSets.length;

    if (challenge.status == ChallengeStatus.complete) {
      return ChallengeStage.finished;
    } else if ((currentUserSetsCount == opponentUserSetsCount &&
        currentUserSetsCount == structureLength)) {
      return ChallengeStage.bothUsersComplete;
    } else if (currentUserSetsCount == structureLength &&
        opponentUserSetsCount < structureLength) {
      return ChallengeStage.currentUserComplete;
    } else if (opponentUserSetsCount == structureLength &&
        currentUserSetsCount < structureLength) {
      return ChallengeStage.opponentUserComplete;
    } else {
      return ChallengeStage.ongoing;
    }
  }

  ChallengesState getStateFromChallenge(PuttingChallenge challenge) {
    return currentChallengeWithStage(getChallengeStage(challenge));
  }

  CurrentChallengeState currentChallengeWithStage(
    ChallengeStage challengeStage,
  ) {
    return CurrentChallengeState(
      challengeStage: challengeStage,
      currentChallenge: _challengesRepository.currentChallenge!,
      activeChallenges: _challengesRepository.activeChallenges,
      pendingChallenges: _challengesRepository.incomingPendingChallenges,
      completedChallenges: _challengesRepository.completedChallenges,
    );
  }

  NoCurrentChallengeState noCurrentChallenge() {
    return NoCurrentChallengeState(
      activeChallenges: _challengesRepository.activeChallenges,
      pendingChallenges: _challengesRepository.incomingPendingChallenges,
      completedChallenges: _challengesRepository.completedChallenges,
    );
  }
}
