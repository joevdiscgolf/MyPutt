import 'package:bloc/bloc.dart';
import 'package:myputt/data/types/challenges/challenge_structure_item.dart';
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
import 'package:myputt/services/dynamic_link_service.dart';
import 'package:myputt/utils/enums.dart';
import 'package:myputt/utils/constants.dart';

part 'challenges_state.dart';

class ChallengesCubit extends Cubit<ChallengesState> {
  final ChallengesRepository _challengesRepository =
      locator.get<ChallengesRepository>();
  final UserRepository _userRepository = locator.get<UserRepository>();
  final DatabaseService _databaseService = locator.get<DatabaseService>();
  final DynamicLinkService _dynamicLinkService =
      locator.get<DynamicLinkService>();
  final PresetsRepository _presetsRepository = locator.get<PresetsRepository>();

  ChallengesCubit()
      : super(ChallengesInitial(
            completedChallenges: [],
            activeChallenges: [],
            currentChallenge: null,
            pendingChallenges: [])) {
    if (_challengesRepository.currentChallenge != null) {
      if (_challengesRepository.currentChallenge?.currentUserSets.length ==
          _challengesRepository.currentChallenge?.challengeStructure.length) {
        emit(_currentUserComplete());
      } else {
        emit(_challengeInProgress());
      }
    } else {
      emit(_noCurrentChallenge());
    }
  }

  @override
  Future<void> close() async {
    super.close();
  }

  CurrentUserComplete _currentUserComplete() {
    return CurrentUserComplete(
      currentChallenge: _challengesRepository.currentChallenge!,
      activeChallenges: _challengesRepository.activeChallenges,
      pendingChallenges: _challengesRepository.pendingChallenges,
      completedChallenges: _challengesRepository.completedChallenges,
    );
  }

  OpponentUserComplete _opponentUserComplete() {
    return OpponentUserComplete(
      currentChallenge: _challengesRepository.currentChallenge!,
      activeChallenges: _challengesRepository.activeChallenges,
      pendingChallenges: _challengesRepository.pendingChallenges,
      completedChallenges: _challengesRepository.completedChallenges,
    );
  }

  BothUsersComplete _bothUsersComplete() {
    return BothUsersComplete(
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
        completedChallenges: _challengesRepository.completedChallenges,
        currentChallenge: null);
  }

  ChallengesState getStateFromChallenge(PuttingChallenge challenge) {
    final structureLength =
        _challengesRepository.currentChallenge!.challengeStructure.length;
    final currentUserSetsCount =
        _challengesRepository.currentChallenge!.currentUserSets.length;
    final opponentUserSetsCount =
        _challengesRepository.currentChallenge!.opponentSets.length;
    if (challenge.status == ChallengeStatus.complete ||
        (currentUserSetsCount == opponentUserSetsCount &&
            currentUserSetsCount == structureLength)) {
      return _bothUsersComplete();
    } else if (currentUserSetsCount == structureLength &&
        opponentUserSetsCount < structureLength) {
      return _currentUserComplete();
    } else if (opponentUserSetsCount == structureLength &&
        currentUserSetsCount < structureLength) {
      return _opponentUserComplete();
    } else {
      return _challengeInProgress();
    }
  }

  Future<void> reload() async {
    await _challengesRepository.fetchAllChallenges();
    if (_challengesRepository.currentChallenge != null) {
      if (_challengesRepository.currentChallenge?.currentUserSets.length ==
          _challengesRepository.currentChallenge?.challengeStructure.length) {
        emit(_currentUserComplete());
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
          _challengesRepository.currentChallenge?.challengeStructure.length) {
        emit(_currentUserComplete());
      } else {
        emit(_challengeInProgress());
      }
    } else {
      emit(ChallengesErrorState(
          completedChallenges: [],
          activeChallenges: [],
          currentChallenge: null,
          pendingChallenges: []));
    }
  }

  Future<void> addSet(PuttingSet set) async {
    if (_challengesRepository.currentChallenge != null) {
      var challengeStructureLength =
          _challengesRepository.currentChallenge!.challengeStructure.length;
      var currentUserSetsCount =
          _challengesRepository.currentChallenge!.currentUserSets.length;
      if (currentUserSetsCount < challengeStructureLength) {
        _challengesRepository.addSet(set);
        emit(getStateFromChallenge(_challengesRepository.currentChallenge!));
        await _challengesRepository.resyncCurrentChallenge();
        emit(getStateFromChallenge(_challengesRepository.currentChallenge!));
      } else {
        emit(getStateFromChallenge(_challengesRepository.currentChallenge!));
        await _challengesRepository.resyncCurrentChallenge();
        emit(getStateFromChallenge(_challengesRepository.currentChallenge!));
      }
    } else {
      emit(ChallengesErrorState(
          completedChallenges: [],
          activeChallenges: [],
          currentChallenge: null,
          pendingChallenges: []));
    }
  }

  Future<void> undo() async {
    final List<PuttingSet>? currentUserSets =
        _challengesRepository.currentChallenge?.currentUserSets;
    if (currentUserSets == null || currentUserSets.isEmpty) {
      return;
    }
    _challengesRepository.currentChallenge?.currentUserSets
        .remove(currentUserSets.last);
    emit(getStateFromChallenge(_challengesRepository.currentChallenge!));
    await _challengesRepository.resyncCurrentChallenge();
    emit(getStateFromChallenge(_challengesRepository.currentChallenge!));
  }

  void updateOpponentSets(Object? rawObject) {
    final Map<String, dynamic>? data = rawObject as Map<String, dynamic>?;
    final MyPuttUser? currentUser = _userRepository.currentUser;
    if (data != null && currentUser != null) {
      final StoragePuttingChallenge storageChallenge =
          StoragePuttingChallenge.fromJson(data);
      final PuttingChallenge challenge =
          PuttingChallenge.fromStorageChallenge(storageChallenge, currentUser);
      if (_challengesRepository.currentChallenge != null &&
          _challengesRepository.currentChallenge?.opponentSets.length !=
              challenge.opponentSets.length) {
        _challengesRepository.currentChallenge = challenge;
        emit(getStateFromChallenge(challenge));
      }
    }
  }

  Future<void> completeCurrentChallenge() async {
    await _challengesRepository.completeChallenge();
    emit(_noCurrentChallenge());
  }

  void deleteChallenge(PuttingChallenge challenge) {
    _challengesRepository.deleteChallenge(challenge);
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
      return _databaseService.setStorageChallenge(generatedChallenge);
    }
  }

  Future<String?> getShareMessageFromSession(PuttingSession session) async {
    final MyPuttUser? currentUser = _userRepository.currentUser;
    if (currentUser == null) {
      return null;
    }
    final StoragePuttingChallenge newChallenge =
        StoragePuttingChallenge.fromSession(session, currentUser);
    await locator.get<DatabaseService>().setUnclaimedChallenge(newChallenge);
    final Uri uri =
        await _dynamicLinkService.generateDynamicLinkFromId(newChallenge.id);
    print(uri);
    return '${currentUser.displayName} is challenging you to a putting competition! $uri';
  }

  Future<String?> getShareMessageFromPreset(ChallengePreset preset) async {
    final List<ChallengeStructureItem>? challengeStructure =
        _presetsRepository.presetStructures[preset];
    if (challengeStructure == null) {
      return null;
    }
    final MyPuttUser? currentUser = _userRepository.currentUser;
    if (currentUser == null) {
      return null;
    }
    final int timeStamp = DateTime.now().millisecondsSinceEpoch;
    final StoragePuttingChallenge newChallenge = StoragePuttingChallenge(
        status: ChallengeStatus.pending,
        creationTimeStamp: timeStamp,
        id: '${currentUser.uid}~$timeStamp',
        challengerUser: currentUser,
        challengeStructure: challengeStructure,
        challengerSets: [],
        recipientSets: []);
    await locator.get<DatabaseService>().setUnclaimedChallenge(newChallenge);
    final Uri uri =
        await _dynamicLinkService.generateDynamicLinkFromId(newChallenge.id);
    print(uri);
    return '${currentUser.displayName} is challenging you to a putting competition! $uri';
  }
}
