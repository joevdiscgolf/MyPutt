import 'package:intl/intl.dart';
import 'package:myputt/data/types/putting_session.dart';
import 'package:myputt/data/types/putting_set.dart';
import 'package:myputt/services/database_service.dart';

class SessionRepository {
  PuttingSession? currentSession;
  List<PuttingSession> allSessions = [];
  final DatabaseService _databaseService = DatabaseService();

  Future<void> addCompletedSession(PuttingSession sessionToAdd) async {
    allSessions.add(sessionToAdd);
    await _databaseService.addCompletedSession(sessionToAdd);
  }

  void deleteSession(PuttingSession sessionToDelete) {
    allSessions.remove(sessionToDelete);
    _databaseService.deleteCompletedSession(sessionToDelete);
  }

  void startCurrentSession() {
    currentSession = PuttingSession(
      timeStamp: DateTime.now().millisecondsSinceEpoch,
      dateStarted:
          '${DateFormat.yMMMMd('en_US').format(DateTime.now()).toString()}, ${DateFormat.jm().format(DateTime.now()).toString()}',
    );
    _databaseService.startCurrentSession(currentSession!);
  }

  void deleteCurrentSession() {
    currentSession = null;
    _databaseService.deleteCurrentSession();
  }

  void addSet(PuttingSet set) {
    if (currentSession != null) {
      currentSession!.addSet(set);
      _databaseService.updateCurrentSession(currentSession!);
    }
  }

  void deleteSet(PuttingSet set) {
    if (currentSession != null && currentSession?.sets != null) {
      currentSession?.sets.remove(set);
    }
  }

  List<PuttingSession> get sessions {
    return allSessions;
  }

  Future<bool> fetchCurrentSession() async {
    final PuttingSession? newCurrentSession =
        await _databaseService.getCurrentSession();
    currentSession = newCurrentSession;
    return true;
  }

  Future<bool> fetchCompletedSessions() async {
    final List<PuttingSession>? newCompletedSessionsList =
        await _databaseService.getCompletedSessions();
    if (newCompletedSessionsList != null) {
      allSessions = newCompletedSessionsList;
    } else {
      allSessions = [];
    }
    return true;
  }

  void clearData() {
    currentSession = null;
    allSessions = [];
  }
}
