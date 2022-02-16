import 'package:bloc/bloc.dart';
import 'package:myputt/data/types/challenges/putting_challenge.dart';
import 'package:myputt/data/types/challenges/storage_putting_challenge.dart';
import 'package:myputt/data/types/myputt_user.dart';
import 'package:myputt/repositories/challenges_repository.dart';
import 'package:myputt/repositories/user_repository.dart';
import 'package:myputt/services/database_service.dart';
import 'package:myputt/utils/utils.dart';

import '../../locator.dart';
import 'package:myputt/data/types/putting_set.dart';

import '../data/types/putting_session.dart';

part 'challenges_state.dart';

class ChallengesCubit extends Cubit<ChallengesState> {
  ChallengesState currentState = ChallengesInitial();

  final ChallengesRepository _challengesRepository =
      locator.get<ChallengesRepository>();
  final UserRepository _userRepository = locator.get<UserRepository>();
  final DatabaseService _databaseService = locator.get<DatabaseService>();
  ChallengesCubit() : super(ChallengesInitial()) {
    print('initializing');
    if (_challengesRepository.currentChallenge != null) {
      if (_challengesRepository.currentChallenge?.currentUserSets.length ==
          _challengesRepository.currentChallenge?.opponentSets.length) {
        emit(ChallengeComplete(
          currentChallenge: _challengesRepository.currentChallenge!,
          activeChallenges: _challengesRepository.activeChallenges,
          pendingChallenges: _challengesRepository.pendingChallenges,
          completedChallenges: _challengesRepository.completedChallenges,
        ));
      } else {
        emit(ChallengeInProgress(
          currentChallenge: _challengesRepository.currentChallenge!,
          activeChallenges: _challengesRepository.activeChallenges,
          pendingChallenges: _challengesRepository.pendingChallenges,
          completedChallenges: _challengesRepository.completedChallenges,
        ));
      }
    } else {
      emit(NoCurrentChallenge(
          activeChallenges: _challengesRepository.activeChallenges,
          pendingChallenges: _challengesRepository.pendingChallenges,
          completedChallenges: _challengesRepository.completedChallenges));
    }
  }

  Future<void> reload() async {
    emit(ChallengesLoading());
    print('reloading challenges');
    await _challengesRepository.fetchAllChallenges();
    if (_challengesRepository.currentChallenge != null) {
      if (_challengesRepository.currentChallenge?.currentUserSets.length ==
          _challengesRepository.currentChallenge?.opponentSets.length) {
        emit(ChallengeComplete(
          currentChallenge: _challengesRepository.currentChallenge!,
          activeChallenges: _challengesRepository.activeChallenges,
          pendingChallenges: _challengesRepository.pendingChallenges,
          completedChallenges: _challengesRepository.completedChallenges,
        ));
      } else {
        emit(ChallengeInProgress(
          currentChallenge: _challengesRepository.currentChallenge!,
          activeChallenges: _challengesRepository.activeChallenges,
          pendingChallenges: _challengesRepository.pendingChallenges,
          completedChallenges: _challengesRepository.completedChallenges,
        ));
      }
    } else {
      emit(NoCurrentChallenge(
          activeChallenges: _challengesRepository.activeChallenges,
          pendingChallenges: _challengesRepository.pendingChallenges,
          completedChallenges: _challengesRepository.completedChallenges));
    }
  }

  void openChallenge(PuttingChallenge challenge) {
    print('opening challenge');
    _challengesRepository.openChallenge(challenge);
    if (_challengesRepository.currentChallenge != null) {
      print(_challengesRepository.currentChallenge?.toJson());
      if (_challengesRepository.currentChallenge?.currentUserSets.length ==
          _challengesRepository.currentChallenge?.opponentSets.length) {
        emit(ChallengeComplete(
          currentChallenge: _challengesRepository.currentChallenge!,
          activeChallenges: _challengesRepository.activeChallenges,
          pendingChallenges: _challengesRepository.pendingChallenges,
          completedChallenges: _challengesRepository.completedChallenges,
        ));
      } else {
        emit(ChallengeInProgress(
          currentChallenge: _challengesRepository.currentChallenge!,
          activeChallenges: _challengesRepository.activeChallenges,
          pendingChallenges: _challengesRepository.pendingChallenges,
          completedChallenges: _challengesRepository.completedChallenges,
        ));
      }
    } else {
      emit(ChallengesErrorState());
    }
  }

  Future<void> completeCurrentChallenge() async {
    print('completing challenge');
    await _challengesRepository.completeCurrentChallenge();
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
            currentChallenge: _challengesRepository.currentChallenge!,
            activeChallenges: _challengesRepository.activeChallenges,
            pendingChallenges: _challengesRepository.pendingChallenges,
            completedChallenges: _challengesRepository.completedChallenges,
          ));
        } else {
          emit(ChallengeInProgress(
            currentChallenge: _challengesRepository.currentChallenge!,
            activeChallenges: _challengesRepository.activeChallenges,
            pendingChallenges: _challengesRepository.pendingChallenges,
            completedChallenges: _challengesRepository.completedChallenges,
          ));
        }
      } else {
        emit(ChallengeComplete(
          currentChallenge: _challengesRepository.currentChallenge!,
          activeChallenges: _challengesRepository.activeChallenges,
          pendingChallenges: _challengesRepository.pendingChallenges,
          completedChallenges: _challengesRepository.completedChallenges,
        ));
      }
    } else {
      emit(ChallengesErrorState());
    }
  }

  Future<void> undo() async {
    final List<PuttingSet>? currentUserSets =
        _challengesRepository.currentChallenge?.currentUserSets;
    if (currentUserSets?.length == 0) {
      return;
    }
    if (currentUserSets == null) {
      return;
    }
    await _challengesRepository.deleteSet(currentUserSets.last);
    if (_challengesRepository.currentChallenge != null) {
      emit(ChallengeInProgress(
        currentChallenge: _challengesRepository.currentChallenge!,
        activeChallenges: _challengesRepository.activeChallenges,
        pendingChallenges: _challengesRepository.pendingChallenges,
        completedChallenges: _challengesRepository.completedChallenges,
      ));
    } else {
      emit(ChallengesErrorState());
    }
  }

  void declineChallenge(PuttingChallenge challenge) {
    _challengesRepository.declineChallenge(challenge);
    if (_challengesRepository.currentChallenge != null) {
      final int setLength = _challengesRepository
          .currentChallenge!
          .opponentSets[
              _challengesRepository.currentChallenge!.currentUserSets.length -
                  1]
          .puttsAttempted as int;
      emit(ChallengeInProgress(
        currentChallenge: _challengesRepository.currentChallenge!,
        activeChallenges: _challengesRepository.activeChallenges,
        pendingChallenges: _challengesRepository.pendingChallenges,
        completedChallenges: _challengesRepository.completedChallenges,
      ));
    } else {
      emit(NoCurrentChallenge(
          activeChallenges: _challengesRepository.activeChallenges,
          pendingChallenges: _challengesRepository.pendingChallenges,
          completedChallenges: _challengesRepository.completedChallenges));
    }
  }

  Future<bool> sendChallenge(PuttingSession session) async {
    print('sending challenge');
    final MyPuttUser? currentUser = _userRepository.currentUser;
    if (currentUser == null) {
      print('current user is null');
      return false;
    } else {
      final generatedChallenge = StoragePuttingChallenge.fromSession(
        session,
        currentUser,
        MyPuttUser(
            keywords: getPrefixes('joevdiscgolf'),
            username: 'joevdiscgolf',
            displayName: 'joe bro',
            pdgaNum: 132408,
            uid: 'k7W1STgUdlWLZP4ayenPk1a8OI82'),
      );
      print(generatedChallenge.toJson());
      return _databaseService.sendStorageChallenge(generatedChallenge);
    }
  }
}
