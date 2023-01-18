import 'package:myputt/models/data/sessions/putting_session.dart';

class SessionHelpers {
  static List<PuttingSession> setSyncedToTrue(
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

  static List<PuttingSession> mergeSessions(
    List<PuttingSession> unsyncedSessions,
    List<PuttingSession> allSessions,
  ) {
    final List<String> unsyncedSessionIds =
        unsyncedSessions.map((session) => session.id).toList();

    final List<PuttingSession> mergedSessions = unsyncedSessions;

    mergedSessions.addAll(
      allSessions.where(
        (session) => !unsyncedSessionIds.contains(session.id),
      ),
    );

    return mergedSessions;
  }

  static List<PuttingSession> getNewSessions(
    List<PuttingSession> localSessions,
    List<PuttingSession> cloudSessions,
  ) {
    final List<String> localSessionIds = List.from(
      localSessions.map((session) => session.id),
    );

    return List.from(cloudSessions
        .where((cloudSession) => !localSessionIds.contains(cloudSession.id)));
  }
}
