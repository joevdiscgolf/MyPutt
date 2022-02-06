import 'package:myputt/data/types/putting_challenge.dart';
import 'package:myputt/data/types/putting_session.dart';
import 'package:myputt/services/auth_service.dart';
import 'package:myputt/services/firebase/challenges_data_writer.dart';
import 'package:myputt/services/firebase/sessions_data_loaders.dart';
import 'package:myputt/services/firebase/sessions_data_writers.dart';
import 'package:myputt/locator.dart';

import '../utils/constants.dart';
import 'firebase/challenges_data_loader.dart';

class DatabaseService {
  final FBSessionsDataLoader _sessionsDataLoader = FBSessionsDataLoader();
  final FBSessionsDataWriter _sessionsDataWriter = FBSessionsDataWriter();
  final FBChallengesDataWriter _challengesDataWriter = FBChallengesDataWriter();
  final FBChallengesDataLoader _challengesDataLoader = FBChallengesDataLoader();

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
    final uid = _authService.getCurrentUserId();

    return _challengesDataLoader.getPuttingChallenges(uid!, filters);
  }

  Future<PuttingChallenge?> getCurrentPuttingChallenge() {
    final uid = _authService.getCurrentUserId();
    return _challengesDataLoader.getCurrentPuttingChallenge(uid!);
  }

  Future<bool> updatePuttingChallenge(PuttingChallenge challengeToUpdate) {
    final uid = _authService.getCurrentUserId();
    return _challengesDataWriter.setPuttingChallenge(uid!, challengeToUpdate);
  }
}
