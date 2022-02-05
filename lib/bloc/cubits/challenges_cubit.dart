import 'package:bloc/bloc.dart';
import 'package:myputt/data/types/putting_challenge.dart';
import 'package:myputt/repositories/challenges_repository.dart';

import '../../locator.dart';
import '../../utils/constants.dart';

part 'challenges_state.dart';

class ChallengesCubit extends Cubit<ChallengesState> {
  final ChallengesRepository _challengesRepository =
      locator.get<ChallengesRepository>();
  ChallengesCubit() : super(ChallengesInitial());

  void openChallenge(PuttingChallenge challenge) {
    if (challenge.status == ChallengeStatus.pending) {
      challenge.status = ChallengeStatus.active;
      _challengesRepository.activateChallenge(challenge);
    }
    //emit(ChallengeInProgress(challengeStructureDistances: challengeStructureDistances, challengerScores: challengerScores, currentUserScores: currentUserScores));
  }
}
