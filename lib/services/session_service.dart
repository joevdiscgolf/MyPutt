import 'package:myputt/data/types/putting_session.dart';

class SessionService {
  PuttingSession? currentSession;
  List<PuttingSession> allSessions = [];
  bool ongoingSession = false;

  void addCompletedSession(PuttingSession session) {
    allSessions.add(session);
  }
}
