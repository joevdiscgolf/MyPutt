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

  ChallengesState getStateFromChallenge(PuttingChallenge challenge) {
    late final ChallengeStage challengeStage;
    final structureLength =
        _challengesRepository.currentChallenge!.challengeStructure.length;
    final currentUserSetsCount =
        _challengesRepository.currentChallenge!.currentUserSets.length;
    final opponentUserSetsCount =
        _challengesRepository.currentChallenge!.opponentSets.length;
    if (challenge.status == ChallengeStatus.complete &&
        _challengesRepository.finishedChallenge != null) {
      challengeStage = ChallengeStage.finished;
    }
    if ((currentUserSetsCount == opponentUserSetsCount &&
        currentUserSetsCount == structureLength)) {
      challengeStage = ChallengeStage.bothUsersComplete;
    } else if (currentUserSetsCount == structureLength &&
        opponentUserSetsCount < structureLength) {
      challengeStage = ChallengeStage.currentUserComplete;
    } else if (opponentUserSetsCount == structureLength &&
        currentUserSetsCount < structureLength) {
      challengeStage = ChallengeStage.opponentUserComplete;
    } else {
      challengeStage = ChallengeStage.ongoing;
    }
    return currentChallengeWithStage(challengeStage);
  }

  CurrentChallengeState currentChallengeWithStage(
      ChallengeStage challengeStage) {
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
