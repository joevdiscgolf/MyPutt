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
    final challenge = _challengesRepository.pendingChallenges[0];
    _challengesRepository.openChallenge(challenge);
    emit(ChallengeInProgress(
        currentChallenge: _challengesRepository.currentChallenge!));
  }

  void addSet(PuttingSet set) {
    _challengesRepository.addSet(set);
    if (_challengesRepository.currentChallenge != null) {
      _challengesRepository.addSet(set);
      emit(ChallengeInProgress(
          currentChallenge: _challengesRepository.currentChallenge!));
    } else {
      emit(ChallengesErrorState());
    }
  }
}
