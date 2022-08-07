import 'dart:developer';

import 'package:myputt/models/data/events/event_player_data.dart';
import 'package:myputt/models/data/sessions/putting_set.dart';
import 'package:myputt/models/data/users/myputt_user.dart';
import 'package:myputt/models/data/challenges/putting_challenge.dart';
import 'package:myputt/models/data/sessions/putting_session.dart';
import 'package:myputt/repositories/user_repository.dart';
import 'package:myputt/services/firebase_auth_service.dart';
import 'package:myputt/services/firebase/challenges_data_writer.dart';
import 'package:myputt/services/firebase/event_data_loader.dart';
import 'package:myputt/services/firebase/event_data_writer.dart';
import 'package:myputt/services/firebase/sessions_data_loaders.dart';
import 'package:myputt/services/firebase/sessions_data_writers.dart';
import 'package:myputt/locator.dart';
import 'package:myputt/services/firebase/user_data_loader.dart';
import 'package:myputt/models/data/challenges/storage_putting_challenge.dart';
import 'package:myputt/utils/constants.dart';
import 'firebase/challenges_data_loader.dart';

class DatabaseService {
  final FBSessionsDataLoader _sessionsDataLoader = FBSessionsDataLoader();
  final FBSessionsDataWriter _sessionsDataWriter = FBSessionsDataWriter();
  final FBChallengesDataWriter _challengesDataWriter = FBChallengesDataWriter();
  final FBChallengesDataLoader _challengesDataLoader = FBChallengesDataLoader();
  final FBUserDataLoader _userDataLoader = FBUserDataLoader();
  final EventDataWriter _eventDataWriter = EventDataWriter();
  final EventDataLoader _eventDataLoader = EventDataLoader();

  final FirebaseAuthService _authService = locator.get<FirebaseAuthService>();

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
    return completedSessions?.toList();
  }

  Future<List<PuttingChallenge>> getChallengesWithStatus(String status) async {
    final UserRepository _userRepository = locator.get<UserRepository>();
    final MyPuttUser? currentUser = _userRepository.currentUser;
    if (currentUser == null) {
      return [];
    }

    return _challengesDataLoader.getPuttingChallengesByStatus(
        currentUser, status);
  }

  Future<List<PuttingChallenge>?> getAllChallenges() async {
    final UserRepository _userRepository = locator.get<UserRepository>();
    final MyPuttUser? currentUser = _userRepository.currentUser;
    if (currentUser == null) {
      return [];
    }

    try {
      return _challengesDataLoader
          .getAllChallenges(currentUser)
          .timeout(shortTimeout);
    } catch (e, trace) {
      log(e.toString());
      log(trace.toString());
      return null;
    }
  }

  Future<PuttingChallenge?> getPuttingChallengeById(String challengeId) async {
    final UserRepository _userRepository = locator.get<UserRepository>();
    final MyPuttUser? currentUser = _userRepository.currentUser;
    if (currentUser == null) {
      return null;
    }
    return _challengesDataLoader.getPuttingChallengeByid(
        currentUser, challengeId);
  }

  Future<bool> setStorageChallenge(
      StoragePuttingChallenge storageChallenge) async {
    final MyPuttUser? recipientUser = storageChallenge.recipientUser;
    final MyPuttUser? challengerUser = storageChallenge.challengerUser;
    if (recipientUser == null || challengerUser == null) {
      return false;
    }
    return _challengesDataWriter.setPuttingChallenge(
        recipientUser.uid, challengerUser.uid, storageChallenge);
  }

  Future<bool> setUnclaimedChallenge(StoragePuttingChallenge storageChallenge) {
    return _challengesDataWriter.uploadUnclaimedChallenge(storageChallenge);
  }

  Future<StoragePuttingChallenge?> retrieveUnclaimedChallenge(
      String challengeId) async {
    return _challengesDataLoader.retrieveUnclaimedChallenge(challengeId);
  }

  Future<bool> removeUnclaimedChallenge(String challengeId) async {
    return true;
  }

  Future<StoragePuttingChallenge?> getChallengeByUid(
      String uid, String challengeId) {
    return _challengesDataLoader.getChallengeByUid(uid, challengeId);
  }

  Future<MyPuttUser?> getCurrentUser() {
    final uid = _authService.getCurrentUserId();
    return _userDataLoader.getUser(uid!);
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

  Future<bool> deleteChallenge(PuttingChallenge challengeToDelete) async {
    final UserRepository _userRepository = locator.get<UserRepository>();
    final MyPuttUser? currentUser = _userRepository.currentUser;
    if (currentUser == null) {
      return false;
    }
    return _challengesDataWriter.deleteChallenge(
        currentUser.uid, challengeToDelete);
  }

  Future<bool> updatePlayerSets(String eventId, List<PuttingSet> sets) async {
    final String? currentUid = _authService.getCurrentUserId();
    if (currentUid == null) {
      return false;
    }
    return _eventDataWriter.updatePlayerSets(currentUid, eventId, sets);
  }

  Future<EventPlayerData?> loadEventPlayerData(String eventId) async {
    final String? currentUid = _authService.getCurrentUserId();
    if (currentUid == null) {
      return null;
    }
    return _eventDataLoader.loadEventPlayerData(currentUid, eventId);
  }
}
