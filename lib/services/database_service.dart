import 'package:myputt/data/types/myputt_user.dart';
import 'package:myputt/data/types/putting_challenge.dart';
import 'package:myputt/data/types/putting_session.dart';
import 'package:myputt/repositories/user_repository.dart';
import 'package:myputt/services/auth_service.dart';
import 'package:myputt/services/firebase/challenges_data_writer.dart';
import 'package:myputt/services/firebase/sessions_data_loaders.dart';
import 'package:myputt/services/firebase/sessions_data_writers.dart';
import 'package:myputt/locator.dart';
import 'package:myputt/services/firebase/user_data_loader.dart';

import '../data/types/putting_set.dart';
import '../data/types/storage_putting_challenge.dart';
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

  Future<List<PuttingChallenge>> getChallengesWithFilters(
      List<ChallengeStatus> filters) async {
    final UserRepository _userRepository = locator.get<UserRepository>();
    final MyPuttUser? currentUser = _userRepository.currentUser;
    if (currentUser == null) {
      print('current user : $currentUser');
      return [];
    }

    return _challengesDataLoader.getPuttingChallenges(currentUser, filters);
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
    const recipientUid = 'k7W1STgUdlWLZP4ayenPk1a8OI82';
    return _challengesDataWriter.sendPuttingChallenge(
        currentUser.uid,
        recipientUid,
        StoragePuttingChallenge(
            challengerSets: [
              PuttingSet(distance: 30, puttsAttempted: 8, puttsMade: 5),
              PuttingSet(distance: 25, puttsAttempted: 10, puttsMade: 6),
              PuttingSet(distance: 20, puttsAttempted: 10, puttsMade: 7),
              PuttingSet(distance: 25, puttsAttempted: 10, puttsMade: 7),
              PuttingSet(distance: 25, puttsAttempted: 10, puttsMade: 7)
            ],
            challengerUser: MyPuttUser(
                username: 'joevdiscgolf',
                displayName: 'joe bro',
                pdgaNum: 132408,
                uid: 'k7W1STgUdlWLZP4ayenPk1a8OI82'),
            challengeStructureDistances: [20, 20, 15, 15, 15],
            creationTimeStamp: DateTime.now().millisecondsSinceEpoch,
            id: 'k7W1STgUdlWLZP4ayenPk1a8OI82~' +
                DateTime.now().millisecondsSinceEpoch.toString(),
            recipientSets: [],
            recipientUser: currentUser,
            status: ChallengeStatus.pending));
  }
}
