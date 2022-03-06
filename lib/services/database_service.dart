import 'package:myputt/data/types/users/myputt_user.dart';
import 'package:myputt/data/types/challenges/putting_challenge.dart';
import 'package:myputt/data/types/putting_session.dart';
import 'package:myputt/repositories/user_repository.dart';
import 'package:myputt/services/auth_service.dart';
import 'package:myputt/services/firebase/challenges_data_writer.dart';
import 'package:myputt/services/firebase/sessions_data_loaders.dart';
import 'package:myputt/services/firebase/sessions_data_writers.dart';
import 'package:myputt/locator.dart';
import 'package:myputt/services/firebase/user_data_loader.dart';
import 'package:myputt/data/types/challenges/storage_putting_challenge.dart';
import 'package:myputt/services/firebase/user_data_writer.dart';
import 'package:myputt/utils/string_helpers.dart';
import 'firebase/challenges_data_loader.dart';

class DatabaseService {
  final FBSessionsDataLoader _sessionsDataLoader = FBSessionsDataLoader();
  final FBSessionsDataWriter _sessionsDataWriter = FBSessionsDataWriter();
  final FBChallengesDataWriter _challengesDataWriter = FBChallengesDataWriter();
  final FBChallengesDataLoader _challengesDataLoader = FBChallengesDataLoader();
  final FBUserDataLoader _userDataLoader = FBUserDataLoader();
  final FBUserDataWriter _userDataWriter = FBUserDataWriter();

  final AuthService _authService = locator.get<AuthService>();

  Future<bool> startCurrentSession(PuttingSession currentSession) async {
    final uid = _authService.getCurrentUserId();

    return _sessionsDataWriter.setCurrentSession(currentSession, uid);
  }

  Future<bool> updateCurrentSession(PuttingSession currentSession) async {
    final uid = _authService.getCurrentUserId();

    return _sessionsDataWriter.updateCurrentSession(currentSession, uid);
  }

  Future<bool> deleteCurrentSession() async {
    final uid = _authService.getCurrentUserId();

    return _sessionsDataWriter.deleteCurrentSession(uid);
  }

  Future<bool> addCompletedSession(PuttingSession sessionToAdd) async {
    final uid = _authService.getCurrentUserId();

    return _sessionsDataWriter.addCompletedSession(sessionToAdd, uid);
  }

  Future<bool> deleteCompletedSession(PuttingSession sessionToDelete) async {
    final uid = _authService.getCurrentUserId();

    return _sessionsDataWriter.deleteCompletedSession(sessionToDelete, uid);
  }

  Future<PuttingSession?> getCurrentSession() async {
    final uid = _authService.getCurrentUserId();

    final result = await _sessionsDataLoader.getUserSessionsDocument(uid!);
    if (result == null) {
      return null;
    } else {
      final sessionsDocument = result;
      return sessionsDocument.currentSession;
    }
  }

  Future<List<PuttingSession>?> getCompletedSessions() async {
    final uid = _authService.getCurrentUserId();

    final completedSessions =
        await _sessionsDataLoader.getCompletedSessions(uid!);
    return completedSessions?.where((session) => session != null).toList();
  }

  Future<List<PuttingChallenge>> getChallengesWithStatus(String status) async {
    final UserRepository _userRepository = locator.get<UserRepository>();
    final MyPuttUser? currentUser = _userRepository.currentUser;
    if (currentUser == null) {
      return [];
    }

    return _challengesDataLoader.getPuttingChallengesWithStatus(
        currentUser, status);
  }

  Future<PuttingChallenge?> getCurrentPuttingChallenge() async {
    final UserRepository _userRepository = locator.get<UserRepository>();
    final MyPuttUser? currentUser = _userRepository.currentUser;
    if (currentUser == null) {
      return null;
    }
    return _challengesDataLoader.getCurrentPuttingChallenge(currentUser);
  }

  Future<bool> setPuttingChallenge(PuttingChallenge challengeToUpdate) async {
    final UserRepository _userRepository = locator.get<UserRepository>();
    final MyPuttUser? currentUser = _userRepository.currentUser;
    if (currentUser == null) {
      return false;
    }
    return _challengesDataWriter.setPuttingChallenge(
        currentUser, challengeToUpdate);
  }

  Future<bool> sendCompletedChallenge(PuttingChallenge challenge) async {
    final UserRepository _userRepository = locator.get<UserRepository>();
    final MyPuttUser? currentUser = _userRepository.currentUser;
    if (currentUser == null) {
      return false;
    }

    return _challengesDataWriter.sendChallengeToUser(
        challenge.opponentUser.uid,
        currentUser,
        StoragePuttingChallenge.fromPuttingChallenge(challenge, currentUser));
  }

  Future<bool> setSharedChallenge(
      StoragePuttingChallenge storageChallenge) async {
    final String? sharedDocumentId = getSharedChallengeDocId(storageChallenge);

    if (sharedDocumentId == null) {
      return false;
    }

    final UserRepository _userRepository = locator.get<UserRepository>();
    final MyPuttUser? currentUser = _userRepository.currentUser;
    if (currentUser == null) {
      return false;
    } else {
      return _challengesDataWriter.setSharedChallenge(
          sharedDocumentId, storageChallenge);
    }
  }

  Future<bool> setUnclaimedChallenge(StoragePuttingChallenge storageChallenge) {
    return _challengesDataWriter.setUnclaimedChallenge(storageChallenge);
  }

  Future<StoragePuttingChallenge?> retrieveUnclaimedChallenge(
      String challengeId) async {
    return _challengesDataLoader.retrieveUnclaimedChallenge(challengeId);
  }

  Future<bool> deleteUnclaimedChallenge(String challengeId) {
    return _challengesDataWriter.deleteUnclaimedChallenge(challengeId);
  }

  Future<StoragePuttingChallenge?> getChallengeByUid(
      String uid, String challengeId) {
    return _challengesDataLoader.getChallengeByUid(uid, challengeId);
  }

  Future<bool> deleteSharedChallenge(PuttingChallenge challengeToDelete) async {
    final UserRepository _userRepository = locator.get<UserRepository>();
    final MyPuttUser? currentUser = _userRepository.currentUser;
    if (currentUser == null) {
      return false;
    }

    return _challengesDataWriter.deleteSharedChallenge(
        currentUser.uid, challengeToDelete);
  }

  Future<MyPuttUser?> getCurrentUser() {
    final uid = _authService.getCurrentUserId();
    return _userDataLoader.getUser(uid!);
  }

  Future<MyPuttUser?> getUserByUid(String uid) {
    return _userDataLoader.getUser(uid);
  }

  Future<bool> setUserWithPayload(MyPuttUser user) {
    return _userDataWriter.setUserWithPayload(user);
  }

  Future<List<MyPuttUser>> getUsersByUsername(String username) async {
    final UserRepository _userRepository = locator.get<UserRepository>();
    final MyPuttUser? currentUser = _userRepository.currentUser;
    if (currentUser == null) {
      return [];
    }
    final List<MyPuttUser> users =
        await _userDataLoader.getUsersByUsername(username);
    return users.where((user) => user.uid != currentUser.uid).toList();
  }
}
