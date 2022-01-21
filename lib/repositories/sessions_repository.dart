import 'package:myputt/data/types/putting_session.dart';
import 'package:myputt/data/types/putting_set.dart';

class SessionRepository {
  PuttingSession? currentSession;
  List<PuttingSession> allSessions = [];

  void addCompletedSession(PuttingSession session) {
    allSessions.add(session);
  }

  void deleteSession(PuttingSession session) {
    allSessions.remove(session);
  }

  void deleteSet(PuttingSet set) {
    if (currentSession != null && currentSession?.sets != null) {
      currentSession?.sets.remove(set);
    }
  }

  List<PuttingSession> get sessions {
    return allSessions;
  }
}
