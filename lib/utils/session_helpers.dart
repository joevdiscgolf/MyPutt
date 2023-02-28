import 'package:myputt/models/data/sessions/putting_session.dart';

abstract class SessionHelpers {
  static List<PuttingSession> removeSession(
      String idToRemove, List<PuttingSession> allSessions) {
    return allSessions.where((session) => session.id != idToRemove).toList();
  }

  static List<PuttingSession> removeSessions(
    List<PuttingSession> sessionsToRemove,
    List<PuttingSession> allSessions,
  ) {
    final Iterable<String> idsToRemove =
        sessionsToRemove.map((sessionToRemove) => sessionToRemove.id);
    return allSessions
        .where((session) => !idsToRemove.contains(session.id))
        .toList();
  }

  static List<PuttingSession> setSessionToDeleted(
    String idToDelete,
    List<PuttingSession> allSessions,
  ) {
    try {
      final int index =
          allSessions.indexWhere((session) => session.id == idToDelete);
      final Map<String, dynamic> sessionJson = allSessions[index].toJson();
      sessionJson['isDeleted'] = true;
      allSessions[index] = PuttingSession.fromJson(sessionJson);
      return allSessions;
    } catch (e) {
      return allSessions;
    }
  }

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

  static List<PuttingSession> mergeCloudSessions(
    List<PuttingSession> localSessions,
    List<PuttingSession> cloudSessions,
  ) {
    final List<String> localSessionIds =
        localSessions.map((session) => session.id).toList();

    // include the local unsynced sessions
    // include cloud sessions if the cloud session is not stored locally and the device Id does not match
    // if the device id does match, that means the session has been deleted locally but not in the cloud yet
    return [
      ...localSessions,
      ...cloudSessions.where(
        (cloudSession) => !localSessionIds.contains(cloudSession.id),
      )
    ];
  }

  static List<PuttingSession> mergeSyncedSessions(
    List<PuttingSession> newlySyncedSessions,
    List<PuttingSession> allSessions,
  ) {
    final List<String> newlySyncedSessionIds =
        newlySyncedSessions.map((session) => session.id).toList();

    return [
      ...newlySyncedSessions,
      ...allSessions.where(
        (session) => !newlySyncedSessionIds.contains(session.id),
      ),
    ];
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

  static List<PuttingSession> getSessionsDeletedInCloud(
    List<PuttingSession> localSessions,
    List<PuttingSession> cloudSessions,
  ) {
    final List<String> cloudSessionIds =
        cloudSessions.map((cloudSession) => cloudSession.id).toList();

    final List<PuttingSession> syncedLocalSessions = localSessions
        .where((localSession) => localSession.isSynced == true)
        .toList();

    // session has been deleted in the cloud if the synced local session exists, but not the cloud session.
    return syncedLocalSessions
        .where((syncedLocalSession) =>
            !cloudSessionIds.contains(syncedLocalSession.id))
        .toList();
  }

  static List<PuttingSession> getSessionsDeletedLocally(
    List<PuttingSession> localSessions,
    List<PuttingSession> cloudSessions,
  ) {
    // session has been deleted locally if marked as such.
    return localSessions
        .where((localSession) => localSession.isDeleted == true)
        .toList();
  }

  List<PuttingSession> getSessionsWithRange(
    int range,
    List<PuttingSession> completedSessions,
  ) {
    completedSessions.sort((s1, s2) => s1.timeStamp.compareTo(s2.timeStamp));
    final List<PuttingSession> selectedSessions =
        completedSessions.take(range).toList();
    return range == 0 ? completedSessions : selectedSessions;
  }
}
