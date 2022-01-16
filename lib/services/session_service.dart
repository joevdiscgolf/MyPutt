import 'package:myputt/data/types/putting_session.dart';

class SessionService {
  PuttingSession currentSession =
      PuttingSession(dateStarted: 'default', uid: 'myuid');
  List<PuttingSession> allSessions = [];
  bool ongoingSession = false;
}
