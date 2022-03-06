import 'package:bloc/bloc.dart';
import 'package:myputt/data/types/challenges/putting_challenge.dart';
import 'package:myputt/data/types/challenges/storage_putting_challenge.dart';
import 'package:myputt/data/types/users/myputt_user.dart';
import 'package:myputt/repositories/challenges_repository.dart';
import 'package:myputt/repositories/presets_repository.dart';
import 'package:myputt/repositories/user_repository.dart';
import 'package:myputt/services/database_service.dart';
import 'package:myputt/locator.dart';
import 'package:myputt/data/types/putting_set.dart';
import 'package:myputt/data/types/putting_session.dart';
import 'package:myputt/utils/constants.dart';
import 'package:myputt/utils/enums.dart';
import 'package:myputt/utils/string_helpers.dart';

part 'challenges_state.dart';

class ChallengesCubit extends Cubit<ChallengesState> {
  final ChallengesRepository _challengesRepository =
      locator.get<ChallengesRepository>();
  final UserRepository _userRepository = locator.get<UserRepository>();
  final PresetsRepository _presetsRepository = locator.get<PresetsRepository>();
  final DatabaseService _databaseService = locator.get<DatabaseService>();

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
    await _challengesRepository.completeCurrentChallenge();
    emit(_noCurrentChallenge());
  }

  void deleteChallenge(PuttingChallenge challenge) {
    _challengesRepository.deleteChallenge(challenge);
  }

  void exitChallenge() {
    _challengesRepository.exitChallenge();
    emit(_noCurrentChallenge());
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
    if (currentUserSets?.length == 0) {
      return;
    }
    if (currentUserSets == null) {
      return;
    }
    await _challengesRepository.deleteSet(currentUserSets.last);
    if (_challengesRepository.currentChallenge != null) {
      emit(_challengeInProgress());
    } else {
      emit(ChallengesErrorState());
    }
  }

  void declineChallenge(PuttingChallenge challenge) {
    _challengesRepository.declineChallenge(challenge);
    if (_challengesRepository.currentChallenge != null) {
      emit(_challengeInProgress());
    } else {
      emit(_noCurrentChallenge());
    }
  }

  // Generate a challenge from a completed session and send to an opponent.
  Future<bool> sendChallengeFromSession(
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
      return _databaseService.setSharedChallenge(generatedChallenge);
    }
  }

  // Generate a challenge and send to the opponent without creating a session first.
  Future<bool> directChallengeWithUsername(
      ChallengePreset preset, MyPuttUser recipientUser) async {
    final MyPuttUser? currentUser = _userRepository.currentUser;
    if (currentUser == null) {
      return false;
    }
    StoragePuttingChallenge storageChallenge = StoragePuttingChallenge(
        status: ChallengeStatus.pending,
        creationTimeStamp: DateTime.now().millisecondsSinceEpoch,
        id: generateChallengeId(currentUser.uid),
        challengerUser: currentUser,
        challengeStructure: _presetsRepository.presetStructures[preset]!,
        challengerSets: [],
        recipientSets: [],
        recipientUser: recipientUser);
    return _databaseService.setSharedChallenge(storageChallenge);
  }
}
