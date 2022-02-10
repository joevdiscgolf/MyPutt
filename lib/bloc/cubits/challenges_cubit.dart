import 'package:bloc/bloc.dart';
import 'package:myputt/data/types/putting_challenge.dart';
import 'package:myputt/repositories/challenges_repository.dart';

import '../../locator.dart';
import 'package:myputt/data/types/putting_set.dart';

part 'challenges_state.dart';

class ChallengesCubit extends Cubit<ChallengesState> {
  ChallengesState currentState = ChallengesInitial();

  final ChallengesRepository _challengesRepository =
      locator.get<ChallengesRepository>();
  ChallengesCubit() : super(ChallengesInitial()) {
    _challengesRepository.openChallenge();
    openChallenge();
  }

  void openChallenge(/*PuttingChallenge challenge*/) {
    _challengesRepository.openChallenge();
    emit(ChallengeInProgress(
      currentChallenge: _challengesRepository.currentChallenge!,
    ));
  }

  void addSet(PuttingSet set) {
    if (_challengesRepository.currentChallenge != null) {
      var opponentSetsCount =
          _challengesRepository.currentChallenge!.challengerSets.length;
      var currentUserSetsCount =
          _challengesRepository.currentChallenge!.recipientSets.length;
      if (currentUserSetsCount < opponentSetsCount) {
        _challengesRepository.addSet(set);
        _challengesRepository.storeCurrentChallenge();
        opponentSetsCount =
            _challengesRepository.currentChallenge!.challengerSets.length;
        currentUserSetsCount =
            _challengesRepository.currentChallenge!.recipientSets.length;
        if (currentUserSetsCount == opponentSetsCount) {
          print(
              'emitting challenge complete, ${_challengesRepository.currentChallenge?.recipientSets}');
          emit(ChallengeComplete(
              currentChallenge: _challengesRepository.currentChallenge!));
        } else {
          emit(ChallengeInProgress(
              currentChallenge: _challengesRepository.currentChallenge!));
        }
      } else {
        emit(ChallengeComplete(
            currentChallenge: _challengesRepository.currentChallenge!));
      }
    } else {
      emit(ChallengesErrorState());
    }
  }

  void undo() {
    final List<PuttingSet>? recipientSets =
        _challengesRepository.currentChallenge?.recipientSets;
    if (recipientSets?.length == 0) {
      return;
    }
    if (recipientSets == null) {
      return;
    }
    _challengesRepository.deleteSet(recipientSets.last);
    if (_challengesRepository.currentChallenge != null) {
      emit(ChallengeInProgress(
          currentChallenge: _challengesRepository.currentChallenge!));
    } else {
      emit(ChallengesErrorState());
    }
  }
}
