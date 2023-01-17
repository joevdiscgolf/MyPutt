import 'package:myputt/models/data/sessions/putting_session.dart';
import 'package:myputt/models/data/sessions/putting_set.dart';
import 'package:myputt/locator.dart';
import 'package:myputt/repositories/user_repository.dart';
import 'package:myputt/services/database_service.dart';
import 'package:myputt/services/firebase/sessions_data_writers.dart';
import 'package:myputt/services/hive/hive_service.dart';
import 'package:myputt/utils/session_helpers.dart';

class SessionRepository {
  PuttingSession? currentSession;
  List<PuttingSession> allSessions = [];
  final DatabaseService _databaseService = DatabaseService();
  final UserRepository _userRepository = locator.get<UserRepository>();
  bool _allSessionsLoaded = false;

  Future<void> addCompletedSession(PuttingSession sessionToAdd) async {
    allSessions.add(sessionToAdd);
    await _databaseService.addCompletedSession(sessionToAdd);
  }

  void deleteSession(PuttingSession sessionToDelete) {
    allSessions.remove(sessionToDelete);
    _databaseService.deleteCompletedSession(sessionToDelete);
  }

  Future<bool> startNewSession(PuttingSession session) async {
    final String? currentUid = _userRepository.currentUser?.uid;
    if (currentUid != null) {
      final int now = DateTime.now().millisecondsSinceEpoch;
      currentSession = PuttingSession(
        timeStamp: now,
        id: '$currentUid~$now',
      );
      return _databaseService.startCurrentSession(currentSession!);
    }
    return false;
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

  Future<void> saveUnsyncedSessions() async {
    final List<PuttingSession> unsyncedSessions =
        SessionHelpers.setSyncedForSessions(
            allSessions.where((session) => session.isSynced != true).toList());
  }

  Future<bool> fetchCompletedSessions() async {
    final List<PuttingSession>? dbCompletedSessions =
        await _databaseService.getCompletedSessions();

    // loaded successfully
    if (dbCompletedSessions != null) {
      final List<PuttingSession> unsyncedSessions =
          allSessions.where((session) => session.isSynced != true).toList();

      final List<String> unsyncedSessionIds =
          unsyncedSessions.map((session) => session.id).toList();

      final List<PuttingSession> unifiedSessions = unsyncedSessions;

      unifiedSessions.addAll(
        dbCompletedSessions.where(
          (dbSession) => !unsyncedSessionIds.contains(dbSession.id),
        ),
      );

      allSessions = unifiedSessions;
      syncLocalDb();
    } else if (!_allSessionsLoaded) {
      // fetch from local

      final List<PuttingSession>? localDbSessions =
          await locator.get<HiveService>().retrieveCompletedSessions();

      if (localDbSessions != null) {
        allSessions = localDbSessions;
      }
    }
    return true;
  }

  List<PuttingSession> getSessionsWithRange(int range) {
    allSessions.sort((s1, s2) => s1.timeStamp.compareTo(s2.timeStamp));
    final List<PuttingSession> selectedSessions =
        allSessions.take(range).toList();
    return range == 0 ? allSessions : selectedSessions;
  }

  void clearData() {
    currentSession = null;
    allSessions = [];
  }

  Future<void> syncLocalDb() async {
    await locator.get<HiveService>().storeCompletedSessions(allSessions);
  }
}
