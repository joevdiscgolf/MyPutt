import 'package:myputt/data/types/putting_session.dart';

class SessionRepository {
  PuttingSession? currentSession;
  List<PuttingSession> allSessions = [];

  void addCompletedSession(PuttingSession session) {
    allSessions.add(session);
  }

  List<PuttingSession> get sessions {
    return allSessions;
  }
}
