import 'package:myputt/models/data/sessions/putting_session.dart';

class SessionHelpers {
  static List<PuttingSession> setSyncedForSessions(
    List<PuttingSession> unsyncedSessions,
  ) {
    List<PuttingSession> syncedSessions = [];
    for (PuttingSession session in unsyncedSessions) {
      final Map<String, dynamic> json = session.toJson();
      json['isSynced'] = true;
      syncedSessions.add(PuttingSession.fromJson(json));
    }
    return syncedSessions;
  }
}
