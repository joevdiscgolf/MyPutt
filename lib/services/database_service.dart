import 'package:myputt/data/types/putting_session.dart';
import 'package:myputt/data/types/putting_set.dart';
import 'package:myputt/data/types/sessions_document.dart';
import 'package:myputt/services/firebase/firebase_data_loaders.dart';
import 'package:myputt/services/firebase/firebase_data_writers.dart';

class DatabaseService {
  final _dataLoader = FBDataLoader();
  final _dataWriter = FBDataWriter();
  final String uid = 'BnisFzLsy0PnJuXv26BQ86HTVJk2';

  Future<bool> startCurrentSession(PuttingSession currentSession) async {
    final session = PuttingSession(dateStarted: DateTime.now().toString());

    /*final PuttingSession? currentSession =
        await _dataLoader.getCurrentSession(uid);

    if (currentSession != null) {
      return false;
    }*/

    return _dataWriter.setCurrentSession(currentSession, uid);
  }

  Future<bool> updateCurrentSession(PuttingSession currentSession) async {
    final session = PuttingSession(dateStarted: DateTime.now().toString());
    session.addSet(PuttingSet(puttsAttempted: 5, puttsMade: 3, distance: 10));

    /*final PuttingSession? currentSession =
        await _dataLoader.getCurrentSession(uid);

    if (currentSession != null) {
      return false;
    }*/

    return _dataWriter.updateCurrentSession(currentSession, uid);
  }

  Future<bool> deleteCurrentSession(
      /*PuttingSession session, String uid*/) async {
    final session = PuttingSession(dateStarted: DateTime.now().toString());
    session.addSet(PuttingSet(puttsAttempted: 5, puttsMade: 3, distance: 10));

    /*final PuttingSession? currentSession =
        await _dataLoader.getCurrentSession(uid);

    if (currentSession != null) {
      return false;
    }*/

    return _dataWriter.deleteCurrentSession(session, uid);
  }

  Future<bool> addCompletedSession(PuttingSession sessionToAdd) async {
    final session = PuttingSession(dateStarted: DateTime.now().toString());
    session.addSet(PuttingSet(puttsAttempted: 5, puttsMade: 3, distance: 10));

    /*final PuttingSession? currentSession =
        await _dataLoader.getCurrentSession(uid);

    if (currentSession != null) {
      return false;
    }*/

    return _dataWriter.addCompletedSession(sessionToAdd, uid);
  }

  Future<bool> deleteCompletedSession(PuttingSession sessionToDelete) async {
    final session = PuttingSession(dateStarted: DateTime.now().toString());
    session.addSet(PuttingSet(puttsAttempted: 5, puttsMade: 3, distance: 10));

    /*final PuttingSession? currentSession =
        await _dataLoader.getCurrentSession(uid);

    if (currentSession != null) {
      return false;
    }*/

    return _dataWriter.deleteCompletedSession(sessionToDelete, uid);
  }

  Future<PuttingSession?> getCurrentSession() async {
    final sessionsDocument = await _dataLoader.getUserSessionsDocument(uid);
    if (sessionsDocument == null) {
      return null;
    }
    return sessionsDocument.currentSession;
  }

  Future<List<PuttingSession>?> getCompletedSessions() async {
    final completedSessions = await _dataLoader.getCompletedSessions(uid);
    return completedSessions?.where((session) => session != null).toList();
  }
}
