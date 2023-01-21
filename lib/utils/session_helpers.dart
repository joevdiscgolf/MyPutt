import 'package:myputt/locator.dart';
import 'package:myputt/models/data/sessions/putting_session.dart';
import 'package:myputt/services/device_service.dart';

class SessionHelpers {
  static List<PuttingSession> removeSession(
      String idToRemove, List<PuttingSession> allSessions) {
    return allSessions.where((session) => session.id != idToRemove).toList();
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
    List<PuttingSession> localUnsyncedSessions,
    List<PuttingSession> cloudSessions,
  ) {
    final String? deviceId = locator.get<DeviceService>().getDeviceId;
    if (deviceId == null) {
      return <PuttingSession>[];
    }
    final List<String> unsyncedSessionIds =
        localUnsyncedSessions.map((session) => session.id).toList();

    // include the local unsynced sessions
    // include cloud sessions if the cloud session is not stored locally and the device Id does not match
    // if the device id does match, that means the session has been deleted locally but not in the cloud yet
    return [
      ...localUnsyncedSessions,
      ...cloudSessions.where(
        (cloudSession) => !(unsyncedSessionIds.contains(cloudSession.id) ||
            cloudSession.deviceId == deviceId),
      ),
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

  static List<PuttingSession> getDeletedSessions(
    List<PuttingSession> localSessions,
    List<PuttingSession> cloudSessions,
  ) {
    final String? deviceId = locator.get<DeviceService>().getDeviceId;
    if (deviceId == null) {
      return [];
    }

    final List<String> localSessionIds =
        localSessions.map((localSession) => localSession.id).toList();

    // Cloud session deleted if If the session is not stored locally, and the device Id matches the current device
    return cloudSessions
        .where((cloudSession) =>
            !localSessionIds.contains(cloudSession.id) &&
            cloudSession.deviceId == deviceId)
        .toList();
  }
}
