import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:myputt/models/data/sessions/putting_session.dart';
import 'package:myputt/models/data/sessions/putting_set.dart';
import 'package:myputt/locator.dart';
import 'package:myputt/repositories/repository.dart';
import 'package:myputt/services/database_service.dart';
import 'package:myputt/services/device_service.dart';
import 'package:myputt/services/firebase/sessions_data_writers.dart';
import 'package:myputt/services/firebase_auth_service.dart';
import 'package:myputt/services/localDB/local_db_service.dart';
import 'package:myputt/utils/constants.dart';
import 'package:myputt/utils/constants/flags.dart';
import 'package:myputt/utils/session_helpers.dart';

class SessionsRepository extends ChangeNotifier implements Repository {
  @override
  void initializeServices() {
    _databaseService = locator.get<DatabaseService>();
    _firebaseAuthService = locator.get<FirebaseAuthService>();
    _localDBService = locator.get<LocalDBService>();
    _deviceService = locator.get<DeviceService>();
  }

  late final DatabaseService _databaseService;
  late final FirebaseAuthService _firebaseAuthService;
  late final LocalDBService _localDBService;
  late final DeviceService _deviceService;

  PuttingSession? currentSession;
  List<PuttingSession> _completedSessions = [];
  List<PuttingSession> get validCompletedSessions {
    return _completedSessions
        .where((session) => session.isDeleted != true)
        .toList();
  }

  set completedSessions(List<PuttingSession> sessions) {
    _completedSessions = sessions;
    notifyListeners();
  }

  Future<bool> startActiveSession() async {
    final String? currentUid = _firebaseAuthService.getCurrentUserId();
    final String? deviceId = _deviceService.getDeviceId;

    if (currentUid == null || deviceId == null) {
      // toast error
      return false;
    }

    final int now = DateTime.now().millisecondsSinceEpoch;

    final PuttingSession newSession = PuttingSession(
      timeStamp: now,
      id: '$currentUid~$now',
      deviceId: deviceId,
    );
    currentSession = newSession;

    final bool localSaveSuccess = await _storeCurrentSessionInLocalDB();
    if (!localSaveSuccess) {
      return false;
    }

    FBSessionsDataWriter.instance.setCurrentSession(newSession);
    return true;
  }

  void addSet(PuttingSet set) {
    if (currentSession != null) {
      currentSession!.addSet(set);

      _storeCurrentSessionInLocalDB();

      FBSessionsDataWriter.instance
          .setCurrentSession(currentSession!, merge: true);
    }
  }

  void deleteSet(PuttingSet set) {
    if (currentSession != null && currentSession?.sets != null) {
      currentSession?.sets.remove(set);

      _storeCurrentSessionInLocalDB();
      FBSessionsDataWriter.instance
          .setCurrentSession(currentSession!, merge: true);
    }
  }

  void deleteCurrentSession() {
    currentSession = null;
    _storeCurrentSessionInLocalDB();
    FBSessionsDataWriter.instance.deleteCurrentSession();
  }

  Future<bool> finishCurrentSession(PuttingSession sessionToAdd) async {
    _completedSessions.add(sessionToAdd);
    final bool localSaveSuccess = await _storeCompletedSessionsInLocalDB();

    if (!localSaveSuccess) {
      return false;
    }

    FBSessionsDataWriter.instance
        .addCompletedSession(sessionToAdd)
        .then((success) {
      // set session to synced if the session has been uploaded successfully
      if (success) {
        _setCompletedSessionToSynced(sessionToAdd);
      }
    });
    return true;
  }

  Future<bool> deleteCompletedSession(PuttingSession sessionToDelete) async {
    // set deleted to true
    completedSessions = SessionHelpers.setSessionToDeleted(
      sessionToDelete.id,
      _completedSessions,
    );

    final bool localSaveSuccess = await _storeCompletedSessionsInLocalDB();
    if (!localSaveSuccess) {
      return false;
    }

    FBSessionsDataWriter.instance
        .deleteCompletedSession(sessionToDelete.id)
        .then((bool sessionDeletedInCloud) {
      if (sessionDeletedInCloud) {
        // remove completely
        completedSessions = SessionHelpers.removeSession(
          sessionToDelete.id,
          _completedSessions,
        );
        return _storeCompletedSessionsInLocalDB();
      } else {
        return false;
      }
    });
    return true;
  }

  void fetchLocalCurrentSession() {
    currentSession = _localDBService.retrieveCurrentSession();
  }

  Future<void> fetchCloudCurrentSession() async {
    try {
      final PuttingSession? cloudCurrentSession =
          await _databaseService.getCurrentSession();

      // overwrite the current local session with the cloud session if and only if there is no local active session.
      if (currentSession == null && cloudCurrentSession != null) {
        currentSession = cloudCurrentSession;
        _storeCurrentSessionInLocalDB();
      }
    } catch (e) {
      return;
    }
  }

  Future<bool> _storeCurrentSessionInLocalDB() {
    return _localDBService.storeCurrentSession(currentSession);
  }

  void fetchLocalCompletedSessions() {
    final List<PuttingSession>? localDbSessions =
        _localDBService.retrieveCompletedSessions();

    if (localDbSessions != null) {
      completedSessions = localDbSessions;
    }
    _log(
        'completed sessions after loading local: ${_completedSessions.length}');
  }

  Future<void> syncAllLocalSessionsToCloud() {
    return Future.wait([
      syncLocalCompletedSessionsToCloud(),
      syncCurrentLocalSessionToCloud()
    ]);
  }

  Future<void> syncLocalCompletedSessionsToCloud() async {
    // do not sync deleted sessions to cloud
    List<PuttingSession> newlySyncedSessions = _completedSessions
        .where(
            (session) => session.isSynced != true && session.isDeleted != true)
        .toList();
    newlySyncedSessions = SessionHelpers.setSyncedToTrue(newlySyncedSessions);

    if (newlySyncedSessions.isEmpty) {
      return;
    }

    // save unsynced sessions in firestore.
    final bool saveSuccess = await FBSessionsDataWriter.instance
        .setSessionsBatch(newlySyncedSessions);

    if (!saveSuccess) {
      // trigger error toast
      return;
    }

    completedSessions = SessionHelpers.mergeSyncedSessions(
      newlySyncedSessions,
      _completedSessions,
    );

    // store newly-synced sessions
    await _storeCompletedSessionsInLocalDB();
  }

  Future<void> syncCurrentLocalSessionToCloud() async {
    if (currentSession == null) return;

    // save current session in firestore.
    await FBSessionsDataWriter.instance.setCurrentSession(currentSession!);
  }

  Future<bool> fetchCloudCompletedSessions() async {
    final List<PuttingSession> unsyncedSessions = _completedSessions
        .where((session) => session.isSynced != true)
        .toList();

    List<PuttingSession>? cloudSessions = await _databaseService
        .getCompletedSessions(timeoutDuration: shortTimeout);

    if (cloudSessions != null) {
      cloudSessions = SessionHelpers.setSyncedToTrue(cloudSessions);

      List<PuttingSession> combinedSessions =
          SessionHelpers.mergeCloudSessions(unsyncedSessions, cloudSessions);

      // store new sessions if necessary.
      final List<PuttingSession> newCloudSessions =
          SessionHelpers.getNewCloudSessions(_completedSessions, cloudSessions);

      // sessions deleted locally that still exist in the cloud
      final List<PuttingSession> sessionsDeletedLocally =
          SessionHelpers.getSessionsDeletedLocally(
        _completedSessions,
        cloudSessions,
      );

      // sessions deleted in the cloud that still exist locally
      final List<PuttingSession> sessionsDeletedInCloud =
          SessionHelpers.getSessionsDeletedInCloud(
        _completedSessions,
        cloudSessions,
      );

      // remove sessions that were deleted in the cloud
      combinedSessions = SessionHelpers.removeSessions(
        sessionsDeletedInCloud,
        combinedSessions,
      );

      // update local sessions if there are new sessions or sessions have been removed
      if (newCloudSessions.isNotEmpty || sessionsDeletedInCloud.isNotEmpty) {
        final bool success = await locator
            .get<LocalDBService>()
            .storeCompletedSessions(combinedSessions);
        if (!success) {
          _log(
              '[SessionsRepository][fetchCloudCompletedSessions] Failed to save new cloud sessions in local DB');
        }
      }

      completedSessions = combinedSessions;

      if (sessionsDeletedLocally.isNotEmpty) {
        final bool deleteSuccess = await FBSessionsDataWriter.instance
            .deleteSessionsBatch(sessionsDeletedLocally);
        _log(
            '[SessionsRepository][fetchCloudCompletedSessions] delete sessions batch in cloud - success: $deleteSuccess');

        // remove sessions locally permanently if deleted in cloud
        if (deleteSuccess) {
          completedSessions = SessionHelpers.removeSessions(
            sessionsDeletedLocally,
            _completedSessions,
          );
          final bool localSaveSuccess =
              await _storeCompletedSessionsInLocalDB();
          _log(
              '[SessionsRepository][fetchCloudCompletedSessions] deleted completed sessions locally - success: $localSaveSuccess');
        }
      }
      if (sessionsDeletedInCloud.isNotEmpty) {
        _log(
            '[SessionsRepository][fetchCloudCompletedSessions] deleting local sessions that were deleted in cloud');
        completedSessions = SessionHelpers.removeSessions(
          sessionsDeletedInCloud,
          _completedSessions,
        );
      }

      final bool localSaveSuccess = await _storeCompletedSessionsInLocalDB();
      _log(
          '[SessionsRepository][fetchCloudCompletedSessions] saved current sessions locally - success: $localSaveSuccess');

      return true;
    } else {
      return false;
    }
  }

  Future<bool> _storeCompletedSessionsInLocalDB() {
    final int sessionsLengthBefore =
        _localDBService.retrieveCompletedSessions()?.length ?? 0;
    return locator
        .get<LocalDBService>()
        .storeCompletedSessions(_completedSessions)
        .then((success) {
      final int sessionsLengthAfter =
          _localDBService.retrieveCompletedSessions()?.length ?? 0;
      _log(
          '[SessionsRepository][_storeCompletedSessionsInLocalDB] local before: $sessionsLengthBefore, local sessions after: $sessionsLengthAfter');
      return success;
    });
  }

  Future<bool> _setCompletedSessionToSynced(PuttingSession session) async {
    int? sessionIndex;
    for (int i = 0; i < _completedSessions.length; i++) {
      final PuttingSession completedSession = _completedSessions[i];
      if (completedSession.id == session.id) {
        sessionIndex = i;
      }
    }
    if (sessionIndex != null) {
      final Map<String, dynamic> sessionJson = session.toJson();
      sessionJson['isSynced'] = true;
      final PuttingSession syncedSession = PuttingSession.fromJson(sessionJson);
      _completedSessions[sessionIndex] = syncedSession;
      return _storeCompletedSessionsInLocalDB();
    } else {
      return false;
    }
  }

  void clearData() {
    currentSession = null;
    completedSessions = [];
    _localDBService.deleteSessionsData();
  }

  void _log(String message) {
    if (Flags.kSessionRepositoryLogs) {
      log(message);
    }
  }
}
