import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:myputt/models/data/events/event_enums.dart';
import 'package:myputt/models/data/events/event_player_data.dart';
import 'package:myputt/models/data/sessions/putting_set.dart';
import 'package:myputt/models/data/users/myputt_user.dart';
import 'package:myputt/models/data/challenges/putting_challenge.dart';
import 'package:myputt/models/data/sessions/putting_session.dart';
import 'package:myputt/repositories/user_repository.dart';
import 'package:myputt/services/firebase/utils/fb_constants.dart';
import 'package:myputt/services/firebase/utils/firebase_utils.dart';
import 'package:myputt/services/firebase_auth_service.dart';
import 'package:myputt/services/firebase/challenges_data_writer.dart';
import 'package:myputt/services/firebase/event_data_loader.dart';
import 'package:myputt/services/firebase/event_data_writer.dart';
import 'package:myputt/services/firebase/sessions_data_loaders.dart';
import 'package:myputt/locator.dart';
import 'package:myputt/services/firebase/user_data_loader.dart';
import 'package:myputt/models/data/challenges/storage_putting_challenge.dart';
import 'package:myputt/utils/constants.dart';
import 'package:myputt/utils/constants/flags.dart';
import 'firebase/challenges_data_loader.dart';

class DatabaseService {
  final FBSessionsDataLoader _sessionsDataLoader = FBSessionsDataLoader();
  final FBChallengesDataWriter _challengesDataWriter = FBChallengesDataWriter();
  final FBChallengesDataLoader _challengesDataLoader = FBChallengesDataLoader();
  final FBUserDataLoader _userDataLoader = FBUserDataLoader();
  final EventDataWriter _eventDataWriter = EventDataWriter();
  final EventDataLoader _eventDataLoader = EventDataLoader();

  final FirebaseAuthService _authService = locator.get<FirebaseAuthService>();

  Future<PuttingSession?> getCurrentSession() async {
    final uid = _authService.getCurrentUserId();

    if (uid == null) {
      return null;
    }

    final result = await _sessionsDataLoader.getUserSessionsDocument(uid);
    return result?.currentSession;
  }

  Future<List<PuttingSession>?> getCompletedSessions({
    Duration timeoutDuration = shortTimeout,
  }) async {
    final uid = _authService.getCurrentUserId();

    if (uid == null) {
      return null;
    }

    return _sessionsDataLoader.getCompletedSessions(
      uid,
      timeoutDuration: timeoutDuration,
    );
  }

  Future<List<PuttingChallenge>> getChallengesWithStatus(String status) async {
    final UserRepository userRepository = locator.get<UserRepository>();
    final MyPuttUser? currentUser = userRepository.currentUser;
    if (currentUser == null) {
      return [];
    }

    return _challengesDataLoader.getPuttingChallengesByStatus(
        currentUser, status);
  }

  Future<List<PuttingChallenge>?> getAllChallenges() async {
    _log('[DatabaseService][getAllChallenges] Fetching current user...');
    final MyPuttUser? currentUser = await FBUserDataLoader.instance
        .getCurrentUser(timeoutDuration: tinyTimeout);
    _log(
        '[DatabaseService][getAllChallenges] Fetched current user: $currentUser');
    if (currentUser == null) {
      return null;
    }

    final QuerySnapshot<Map<String, dynamic>>? snapshot = await firestoreQuery(
      path: '$challengesCollection/${currentUser.uid}/$challengesCollection',
    );

    _log('cloud challenges snapshot: $snapshot');
    if (snapshot == null) {
      return null;
    } else {
      _log('returning cloud snapshot docs');
      try {
        return snapshot.docs.map(
          (doc) {
            return PuttingChallenge.fromStorageChallenge(
              StoragePuttingChallenge.fromJson(doc.data()),
              currentUser,
            );
          },
        ).toList();
      } catch (e, trace) {
        _log(e.toString());
        _log(trace.toString());
        return null;
      }
    }
  }

  Future<PuttingChallenge?> getPuttingChallengeById(String challengeId) async {
    final UserRepository userRepository = locator.get<UserRepository>();
    final MyPuttUser? currentUser = userRepository.currentUser;
    if (currentUser == null) {
      return null;
    }
    return _challengesDataLoader.getPuttingChallengeById(
      currentUser,
      challengeId,
    );
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

  Future<List<MyPuttUser>> getUsersByUsername(String username) async {
    final String? currentUid =
        locator.get<FirebaseAuthService>().getCurrentUserId();
    if (currentUid == null) {
      return [];
    }
    final List<MyPuttUser> users =
        await _userDataLoader.getUsersByUsername(username);
    return users.where((user) => user.uid != currentUid).toList();
  }

  Future<bool> deleteChallenge(PuttingChallenge challengeToDelete) async {
    final UserRepository userRepository = locator.get<UserRepository>();
    final MyPuttUser? currentUser = userRepository.currentUser;
    if (currentUser == null) {
      return false;
    }
    return _challengesDataWriter.deleteChallenge(
      currentUser.uid,
      challengeToDelete,
    );
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

  Future<List<EventPlayerData>> loadDivisionStandings(
    String eventId,
    Division division,
  ) async =>
      _eventDataLoader.getDivisionStandings(eventId, division);

  Future<List<EventPlayerData>> loadEventStandings(String eventId) async =>
      _eventDataLoader.getEventStandings(eventId);

  void _log(String message) {
    if (Flags.kDatabaseServiceLogs) {
      log(message);
    }
  }
}
