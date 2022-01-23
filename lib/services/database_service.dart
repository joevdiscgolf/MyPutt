import 'package:myputt/data/types/putting_session.dart';
import 'package:myputt/data/types/putting_set.dart';
import 'package:myputt/data/types/sessions_document.dart';
import 'package:myputt/services/firebase/firebase_data_loaders.dart';
import 'package:myputt/services/firebase/firebase_data_writers.dart';

class DatabaseService {
  final _dataLoader = FBDataLoader();
  final _dataWriter = FBDataWriter();
  final String uid = 'BnisFzLsy0PnJuXv26BQ86HTVJk2';

  Future<bool> startCurrentSession(
      /*PuttingSession session, String uid*/) async {
    final session = PuttingSession(dateStarted: DateTime.now().toString());

    /*final PuttingSession? currentSession =
        await _dataLoader.getCurrentSession(uid);

    if (currentSession != null) {
      return false;
    }*/

    return _dataWriter.setCurrentSession(session, uid);
  }

  Future<bool> updateCurrentSession(
      /*PuttingSession session, String uid*/) async {
    final session = PuttingSession(dateStarted: DateTime.now().toString());
    session.addSet(PuttingSet(puttsAttempted: 5, puttsMade: 3, distance: 10));

    /*final PuttingSession? currentSession =
        await _dataLoader.getCurrentSession(uid);

    if (currentSession != null) {
      return false;
    }*/

    return _dataWriter.updateCurrentSession(session, uid);
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

  Future<bool> addCompletedSession(
      /*PuttingSession session, String uid*/) async {
    final session = PuttingSession(dateStarted: DateTime.now().toString());
    session.addSet(PuttingSet(puttsAttempted: 5, puttsMade: 3, distance: 10));

    /*final PuttingSession? currentSession =
        await _dataLoader.getCurrentSession(uid);

    if (currentSession != null) {
      return false;
    }*/

    return _dataWriter.addCompletedSession(session, uid);
  }

  Future<PuttingSession?> getCurrentSession() async {
    return _dataLoader.getCurrentSession(uid);
  }

  Future<List<PuttingSession?>> getCompletedSessions() async {
    final completedSessions = await _dataLoader.getCompletedSessions(uid);
    return completedSessions.where((session) => session != null).toList();
  }
}
