import 'package:myputt/data/types/challenges/challenge_structure_item.dart';
import 'package:myputt/data/types/myputt_user.dart';
import 'package:myputt/data/types/challenges/putting_challenge.dart';
import 'package:myputt/data/types/putting_session.dart';
import 'package:myputt/repositories/user_repository.dart';
import 'package:myputt/services/auth_service.dart';
import 'package:myputt/services/firebase/challenges_data_writer.dart';
import 'package:myputt/services/firebase/sessions_data_loaders.dart';
import 'package:myputt/services/firebase/sessions_data_writers.dart';
import 'package:myputt/locator.dart';
import 'package:myputt/services/firebase/user_data_loader.dart';
import 'package:myputt/utils/utils.dart';

import '../data/types/putting_set.dart';
import 'package:myputt/data/types/challenges/storage_putting_challenge.dart';
import '../utils/constants.dart';
import 'firebase/challenges_data_loader.dart';

class DatabaseService {
  final FBSessionsDataLoader _sessionsDataLoader = FBSessionsDataLoader();
  final FBSessionsDataWriter _sessionsDataWriter = FBSessionsDataWriter();
  final FBChallengesDataWriter _challengesDataWriter = FBChallengesDataWriter();
  final FBChallengesDataLoader _challengesDataLoader = FBChallengesDataLoader();
  final FBUserDataLoader _userDataLoader = FBUserDataLoader();

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

  Future<bool> updatePuttingChallenge(
      PuttingChallenge challengeToUpdate) async {
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

    return _challengesDataWriter.sendPuttingChallenge(
        challenge.opponentUser.uid,
        currentUser,
        StoragePuttingChallenge.fromPuttingChallenge(challenge, currentUser));
  }

  Future<bool> sendStorageChallenge(
      StoragePuttingChallenge storageChallenge) async {
    final UserRepository _userRepository = locator.get<UserRepository>();
    final MyPuttUser? currentUser = _userRepository.currentUser;
    if (currentUser == null) {
      return false;
    }
    print('sending putting challenge');
    if (storageChallenge.recipientUser == null) {
      return false;
    } else {
      return _challengesDataWriter.sendPuttingChallenge(
          storageChallenge.recipientUser!.uid, currentUser, storageChallenge);
    }
  }

  Future<MyPuttUser?> getCurrentUser() {
    final uid = _authService.getCurrentUserId();
    return _userDataLoader.getUser(uid!);
  }

  Future<bool> sendTestChallenge() async {
    final UserRepository _userRepository = locator.get<UserRepository>();
    final MyPuttUser? currentUser = _userRepository.currentUser;
    if (currentUser == null) {
      return false;
    }
    return _challengesDataWriter.sendTestChallenge(
        currentUser.uid,
        MyPuttUser(
            keywords: getPrefixes('joevdiscgolf'),
            username: 'joevdiscgolf',
            displayName: 'joe bro',
            pdgaNum: 132408,
            uid: 'k7W1STgUdlWLZP4ayenPk1a8OI82'),
        StoragePuttingChallenge(
            challengerSets: [
              PuttingSet(distance: 20, puttsAttempted: 10, puttsMade: 5),
              PuttingSet(distance: 25, puttsAttempted: 10, puttsMade: 6),
              PuttingSet(distance: 25, puttsAttempted: 10, puttsMade: 7),
              PuttingSet(distance: 30, puttsAttempted: 10, puttsMade: 7),
              PuttingSet(distance: 30, puttsAttempted: 10, puttsMade: 7)
            ],
            challengerUser: MyPuttUser(
                keywords: getPrefixes('joevdiscgolf'),
                username: 'joevdiscgolf',
                displayName: 'joe bro',
                pdgaNum: 132408,
                uid: 'k7W1STgUdlWLZP4ayenPk1a8OI82'),
            challengeStructure: [
              ChallengeStructureItem(distance: 20, setLength: 10),
              ChallengeStructureItem(distance: 25, setLength: 10),
              ChallengeStructureItem(distance: 25, setLength: 10),
              ChallengeStructureItem(distance: 30, setLength: 10),
              ChallengeStructureItem(distance: 30, setLength: 10)
            ],
            creationTimeStamp: DateTime.now().millisecondsSinceEpoch,
            id: 'k7W1STgUdlWLZP4ayenPk1a8OI82~' +
                DateTime.now().millisecondsSinceEpoch.toString(),
            recipientSets: [],
            recipientUser: currentUser,
            status: ChallengeStatus.pending));
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
}
