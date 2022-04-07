import 'package:myputt/data/types/sessions/putting_session.dart';
import 'package:myputt/data/types/sessions/putting_set.dart';
import 'package:myputt/locator.dart';
import 'package:myputt/repositories/user_repository.dart';
import 'package:myputt/services/database_service.dart';

class SessionRepository {
  PuttingSession? currentSession;
  List<PuttingSession> allSessions = [];
  final DatabaseService _databaseService = DatabaseService();
  final UserRepository _userRepository = locator.get<UserRepository>();

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
}
