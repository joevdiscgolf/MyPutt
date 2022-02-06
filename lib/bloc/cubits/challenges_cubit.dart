import 'package:bloc/bloc.dart';
import 'package:myputt/data/types/putting_challenge.dart';
import 'package:myputt/repositories/challenges_repository.dart';

import '../../locator.dart';
import '../../utils/constants.dart';
import 'package:myputt/data/types/putting_set.dart';

part 'challenges_state.dart';

class ChallengesCubit extends Cubit<ChallengesState> {
  final ChallengesRepository _challengesRepository =
      locator.get<ChallengesRepository>();
  ChallengesCubit() : super(ChallengesInitial());

  void openChallenge(/*PuttingChallenge challenge*/) {
    /*if (challenge.status == ChallengeStatus.pending) {
      challenge.status = ChallengeStatus.active;
      _challengesRepository.activateChallenge(challenge);
      _challengesRepository.currentChallenge = challenge;
    }*/
    _challengesRepository.currentPuttingChallenge = PuttingChallenge(
        challengerSets: [
          PuttingSet(distance: 25, puttsAttempted: 10, puttsMade: 5),
          PuttingSet(distance: 25, puttsAttempted: 10, puttsMade: 6),
          PuttingSet(distance: 25, puttsAttempted: 10, puttsMade: 7)
        ],
        challengerUid: 'challengeruid',
        challengeStructureDistances: [20, 20, 15],
        createdAt: 1643453201,
        id: 'thischallengeId',
        recipientSets: [
          PuttingSet(distance: 25, puttsAttempted: 10, puttsMade: 3),
          PuttingSet(distance: 25, puttsAttempted: 10, puttsMade: 4)
        ],
        recipientUid: 'recipientuid',
        status: ChallengeStatus.active);
    emit(ChallengeInProgress(
        currentChallenge: _challengesRepository.currentPuttingChallenge!));
  }

  void addSet(PuttingSet set) {
    _challengesRepository.addSet(set);
    if (_challengesRepository.currentPuttingChallenge != null) {
      emit(ChallengeInProgress(
          currentChallenge: _challengesRepository.currentPuttingChallenge!));
    } else {
      emit(ChallengesErrorState());
    }
  }
}
