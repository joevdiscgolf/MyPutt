import 'package:myputt/data/types/putting_session.dart';
import 'package:myputt/data/types/putting_set.dart';
import 'package:myputt/services/firebase/auth_service.dart';
import 'package:myputt/services/firebase/firebase_data_loaders.dart';
import 'package:myputt/services/firebase/firebase_data_writers.dart';
import 'package:myputt/locator.dart';

class DatabaseService {
  final FBDataLoader _dataLoader = FBDataLoader();
  final FBDataWriter _dataWriter = FBDataWriter();

  final AuthService _authService = locator.get<AuthService>();

  Future<bool> startCurrentSession(PuttingSession currentSession) async {
    final uid = _authService.getCurrentUserId();

    return _dataWriter.setCurrentSession(currentSession, uid);
  }

  Future<bool> updateCurrentSession(PuttingSession currentSession) async {
    final uid = _authService.getCurrentUserId();

    return _dataWriter.updateCurrentSession(currentSession, uid);
  }

  Future<bool> deleteCurrentSession() async {
    final uid = _authService.getCurrentUserId();

    return _dataWriter.deleteCurrentSession(uid);
  }

  Future<bool> addCompletedSession(PuttingSession sessionToAdd) async {
    final uid = _authService.getCurrentUserId();

    return _dataWriter.addCompletedSession(sessionToAdd, uid);
  }

  Future<bool> deleteCompletedSession(PuttingSession sessionToDelete) async {
    final uid = _authService.getCurrentUserId();

    return _dataWriter.deleteCompletedSession(sessionToDelete, uid);
  }

  Future<PuttingSession?> getCurrentSession() async {
    final uid = _authService.getCurrentUserId();
    final sessionsDocument = await _dataLoader.getUserSessionsDocument(uid!);
    if (sessionsDocument == null) {
      return null;
    }
    return sessionsDocument.currentSession;
  }

  Future<List<PuttingSession>?> getCompletedSessions() async {
    final uid = _authService.getCurrentUserId();
    final completedSessions = await _dataLoader.getCompletedSessions(uid!);
    return completedSessions?.where((session) => session != null).toList();
  }
}
