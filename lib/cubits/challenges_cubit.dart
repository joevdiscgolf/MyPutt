import 'package:bloc/bloc.dart';
import 'package:myputt/data/types/challenges/putting_challenge.dart';
import 'package:myputt/data/types/challenges/storage_putting_challenge.dart';
import 'package:myputt/data/types/users/myputt_user.dart';
import 'package:myputt/repositories/challenges_repository.dart';
import 'package:myputt/repositories/user_repository.dart';
import 'package:myputt/services/database_service.dart';
import 'package:myputt/locator.dart';
import 'package:myputt/data/types/putting_set.dart';
import 'package:myputt/data/types/putting_session.dart';

part 'challenges_state.dart';

class ChallengesCubit extends Cubit<ChallengesState> {
  final ChallengesRepository _challengesRepository =
      locator.get<ChallengesRepository>();
  final UserRepository _userRepository = locator.get<UserRepository>();
  final DatabaseService _databaseService = locator.get<DatabaseService>();

  ChallengeComplete _challengeComplete() {
    return ChallengeComplete(
      currentChallenge: _challengesRepository.currentChallenge!,
      activeChallenges: _challengesRepository.activeChallenges,
      pendingChallenges: _challengesRepository.pendingChallenges,
      completedChallenges: _challengesRepository.completedChallenges,
    );
  }

  ChallengeInProgress _challengeInProgress() {
    return ChallengeInProgress(
      currentChallenge: _challengesRepository.currentChallenge!,
      activeChallenges: _challengesRepository.activeChallenges,
      pendingChallenges: _challengesRepository.pendingChallenges,
      completedChallenges: _challengesRepository.completedChallenges,
    );
  }

  NoCurrentChallenge _noCurrentChallenge() {
    return NoCurrentChallenge(
        activeChallenges: _challengesRepository.activeChallenges,
        pendingChallenges: _challengesRepository.pendingChallenges,
        completedChallenges: _challengesRepository.completedChallenges);
  }

  ChallengesCubit() : super(ChallengesInitial()) {
    if (_challengesRepository.currentChallenge != null) {
      if (_challengesRepository.currentChallenge?.currentUserSets.length ==
          _challengesRepository.currentChallenge?.opponentSets.length) {
        emit(_challengeComplete());
      } else {
        emit(_challengeInProgress());
      }
    } else {
      emit(_noCurrentChallenge());
    }
  }

  Future<void> reload() async {
    await _challengesRepository.fetchAllChallenges();
    if (_challengesRepository.currentChallenge != null) {
      if (_challengesRepository.currentChallenge?.currentUserSets.length ==
          _challengesRepository.currentChallenge?.opponentSets.length) {
        emit(_challengeComplete());
      } else {
        emit(_challengeInProgress());
      }
    } else {
      emit(_noCurrentChallenge());
    }
  }

  void openChallenge(PuttingChallenge challenge) {
    _challengesRepository.openChallenge(challenge);
    if (_challengesRepository.currentChallenge != null) {
      if (_challengesRepository.currentChallenge?.currentUserSets.length ==
          _challengesRepository.currentChallenge?.opponentSets.length) {
        emit(_challengeComplete());
      } else {
        emit(_challengeInProgress());
      }
    } else {
      emit(ChallengesErrorState());
    }
  }

  Future<void> completeCurrentChallenge() async {
    await _challengesRepository.completeChallenge();
    emit(_noCurrentChallenge());
  }

  void deleteChallenge(PuttingChallenge challenge) {
    _challengesRepository.deleteChallenge(challenge);
  }

  void addSet(PuttingSet set) {
    if (_challengesRepository.currentChallenge != null) {
      var opponentSetsCount =
          _challengesRepository.currentChallenge!.opponentSets.length;
      var currentUserSetsCount =
          _challengesRepository.currentChallenge!.currentUserSets.length;
      if (currentUserSetsCount < opponentSetsCount) {
        _challengesRepository.addSet(set);
        opponentSetsCount =
            _challengesRepository.currentChallenge!.opponentSets.length;
        currentUserSetsCount =
            _challengesRepository.currentChallenge!.currentUserSets.length;
        if (currentUserSetsCount ==
            _challengesRepository.currentChallenge?.challengeStructure.length) {
          emit(_challengeComplete());
        } else {
          emit(_challengeInProgress());
        }
      } else {
        emit(_challengeComplete());
      }
    } else {
      emit(ChallengesErrorState());
    }
  }

  Future<void> undo() async {
    final List<PuttingSet>? currentUserSets =
        _challengesRepository.currentChallenge?.currentUserSets;
    if (currentUserSets == null || currentUserSets.isEmpty) {
      return;
    }
    await _challengesRepository.deleteSet(currentUserSets.last);
    emit(_challengeInProgress());
  }

  void declineChallenge(PuttingChallenge challenge) {
    _challengesRepository.declineChallenge(challenge);
    if (_challengesRepository.currentChallenge != null) {
      emit(_challengeInProgress());
    } else {
      emit(_noCurrentChallenge());
    }
  }

  Future<bool> generateAndSendChallengeToUser(
      PuttingSession session, MyPuttUser recipientUser) async {
    final MyPuttUser? currentUser = _userRepository.currentUser;
    if (currentUser == null) {
      return false;
    } else {
      final generatedChallenge = StoragePuttingChallenge.fromSession(
        session,
        currentUser,
        opponentUser: recipientUser,
      );
      return _databaseService.sendStorageChallenge(generatedChallenge);
    }
  }
}
