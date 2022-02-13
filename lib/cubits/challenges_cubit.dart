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
    print('initializing');
    if (_challengesRepository.currentChallenge != null) {
      emit(ChallengeInProgress(
          currentChallenge: _challengesRepository.currentChallenge!,
          activeChallenges: _challengesRepository.activeChallenges,
          pendingChallenges: _challengesRepository.pendingChallenges,
          completedChallenges: _challengesRepository.completedChallenges));
    } else {
      emit(NoCurrentChallenge(
          activeChallenges: _challengesRepository.activeChallenges,
          pendingChallenges: _challengesRepository.pendingChallenges,
          completedChallenges: _challengesRepository.completedChallenges));
    }
  }

  void reload() {
    print('reloading');
  }

  void openChallenge(PuttingChallenge challenge) {
    print('opening challenge');
    _challengesRepository.openChallenge(challenge);
    if (_challengesRepository.currentChallenge != null) {
      emit(ChallengeInProgress(
          currentChallenge: _challengesRepository.currentChallenge!,
          activeChallenges: _challengesRepository.activeChallenges,
          pendingChallenges: _challengesRepository.pendingChallenges,
          completedChallenges: _challengesRepository.completedChallenges));
    } else {
      emit(ChallengesErrorState());
    }
  }

  void completeCurrentChallenge() {
    print('completing challenge');
    _challengesRepository.completeCurrentChallenge();
    emit(NoCurrentChallenge(
        activeChallenges: _challengesRepository.activeChallenges,
        pendingChallenges: _challengesRepository.pendingChallenges,
        completedChallenges: _challengesRepository.completedChallenges));
  }

  void deleteChallenge(PuttingChallenge challenge) {
    _challengesRepository.deleteChallenge(challenge);
  }

  void exitChallenge() {
    _challengesRepository.exitChallenge();
    emit(NoCurrentChallenge(
        activeChallenges: _challengesRepository.activeChallenges,
        pendingChallenges: _challengesRepository.pendingChallenges,
        completedChallenges: _challengesRepository.completedChallenges));
  }

  void addSet(PuttingSet set) {
    if (_challengesRepository.currentChallenge != null) {
      var opponentSetsCount =
          _challengesRepository.currentChallenge!.opponentSets.length;
      var currentUserSetsCount =
          _challengesRepository.currentChallenge!.currentUserSets.length;
      if (currentUserSetsCount < opponentSetsCount) {
        _challengesRepository.addSet(set);
        _challengesRepository.storeCurrentChallenge();
        opponentSetsCount =
            _challengesRepository.currentChallenge!.opponentSets.length;
        currentUserSetsCount =
            _challengesRepository.currentChallenge!.currentUserSets.length;
        if (currentUserSetsCount == opponentSetsCount) {
          emit(ChallengeComplete(
              currentChallenge: _challengesRepository.currentChallenge!));
        } else {
          emit(ChallengeInProgress(
              currentChallenge: _challengesRepository.currentChallenge!,
              activeChallenges: _challengesRepository.activeChallenges,
              pendingChallenges: _challengesRepository.pendingChallenges,
              completedChallenges: _challengesRepository.completedChallenges));
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
    final List<PuttingSet>? currentUserSets =
        _challengesRepository.currentChallenge?.currentUserSets;
    if (currentUserSets?.length == 0) {
      return;
    }
    if (currentUserSets == null) {
      return;
    }
    _challengesRepository.deleteSet(currentUserSets.last);
    if (_challengesRepository.currentChallenge != null) {
      emit(ChallengeInProgress(
          currentChallenge: _challengesRepository.currentChallenge!,
          activeChallenges: _challengesRepository.activeChallenges,
          pendingChallenges: _challengesRepository.pendingChallenges,
          completedChallenges: _challengesRepository.completedChallenges));
    } else {
      emit(ChallengesErrorState());
    }
  }

  void declineChallenge(PuttingChallenge challenge) {
    _challengesRepository.declineChallenge(challenge);
    if (_challengesRepository.currentChallenge != null) {
      emit(ChallengeInProgress(
          currentChallenge: _challengesRepository.currentChallenge!,
          activeChallenges: _challengesRepository.activeChallenges,
          pendingChallenges: _challengesRepository.pendingChallenges,
          completedChallenges: _challengesRepository.completedChallenges));
    } else {
      emit(NoCurrentChallenge(
          activeChallenges: _challengesRepository.activeChallenges,
          pendingChallenges: _challengesRepository.pendingChallenges,
          completedChallenges: _challengesRepository.completedChallenges));
    }
  }
}
