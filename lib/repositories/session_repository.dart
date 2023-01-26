import 'dart:async';
import 'dart:developer';

import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:myputt/models/data/sessions/putting_session.dart';
import 'package:myputt/models/data/sessions/putting_set.dart';
import 'package:myputt/locator.dart';
import 'package:myputt/services/database_service.dart';
import 'package:myputt/services/device_service.dart';
import 'package:myputt/services/firebase/sessions_data_writers.dart';
import 'package:myputt/services/firebase_auth_service.dart';
import 'package:myputt/services/localDB/local_db_service.dart';
import 'package:myputt/utils/constants.dart';
import 'package:myputt/utils/session_helpers.dart';

class SessionRepository {
  PuttingSession? currentSession;
  List<PuttingSession> completedSessions = [];
  final DatabaseService _databaseService = DatabaseService();

  Future<bool> startNewSession(PuttingSession session) async {
    final String? currentUid =
        locator.get<FirebaseAuthService>().getCurrentUserId();
    final String? deviceId = locator.get<DeviceService>().getDeviceId;

    if (currentUid == null || deviceId == null) {
      // toast error
      return false;
    }

    final int now = DateTime.now().millisecondsSinceEpoch;
    currentSession = PuttingSession(timeStamp: now, id: '$currentUid~$now');

    final bool localSaveSuccess = await _storeCurrentSessionInLocalDB();
    if (!localSaveSuccess) {
      return false;
    }

    FBSessionsDataWriter.instance.setCurrentSession(session);
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
    completedSessions.add(sessionToAdd);
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
    completedSessions = SessionHelpers.removeSession(
      sessionToDelete.id,
      completedSessions,
    );
    final bool localSaveSuccess = await _storeCompletedSessionsInLocalDB();
    if (!localSaveSuccess) {
      return false;
    }
    FBSessionsDataWriter.instance.deleteCompletedSession(sessionToDelete.id);
    return true;
  }

  void fetchLocalCurrentSession() {
    currentSession = locator.get<LocalDBService>().retrieveCurrentSession();
  }

  Future<void> fetchCloudCurrentSession() async {
    try {
      final PuttingSession? cloudCurrentSession =
          await _databaseService.getCurrentSession();

      if (currentSession != null) {
        if (currentSession?.deviceId != cloudCurrentSession?.deviceId) {
          currentSession = cloudCurrentSession;
        }
      } else {
        currentSession = cloudCurrentSession;
      }
    } catch (e) {
      return;
    }
  }

  Future<bool> _storeCurrentSessionInLocalDB() {
    return locator
        .get<LocalDBService>()
        .storeCurrentSession(currentSession)
        .then((success) {
      final PuttingSession? currentLocalSession =
          locator.get<LocalDBService>().retrieveCurrentSession();
      print('local current session: ${currentLocalSession?.toJson()}');
      return success;
    });
  }

  void fetchLocalCompletedSessions() {
    final List<PuttingSession>? localDbSessions =
        locator.get<LocalDBService>().retrieveCompletedSessions();

    print('fetched ${localDbSessions?.length} local DB sessions');
    if (localDbSessions != null) {
      completedSessions = localDbSessions;
    }
  }

  Future<void> syncLocalSessionsToCloud() async {
    List<PuttingSession> newlySyncedSessions =
        completedSessions.where((session) => session.isSynced != true).toList();
    newlySyncedSessions = SessionHelpers.setSyncedToTrue(newlySyncedSessions);

    if (newlySyncedSessions.isEmpty) {
      return;
    }

    // save unsynced sessions in firestore.
    final bool success = await FBSessionsDataWriter.instance
        .setSessionsBatch(newlySyncedSessions);

    if (!success) {
      // trigger error toast
      return;
    }

    completedSessions = SessionHelpers.mergeSyncedSessions(
      newlySyncedSessions,
      completedSessions,
    );

    // store newly-synced sessions
    await _storeCompletedSessionsInLocalDB();
  }

  Future<void> fetchCloudCompletedSessions() async {
    List<PuttingSession>? cloudSessions;
    try {
      cloudSessions = await _databaseService
          .getCompletedSessions()
          .timeout(standardTimeout);
    } catch (e, trace) {
      await FirebaseCrashlytics.instance.recordError(e, trace);
    }

    if (cloudSessions != null) {
      cloudSessions = SessionHelpers.setSyncedToTrue(cloudSessions);

      final List<PuttingSession> unsyncedSessions = completedSessions
          .where((session) => session.isSynced != true)
          .toList();
      final List<PuttingSession> combinedSessions =
          SessionHelpers.mergeCloudSessions(unsyncedSessions, cloudSessions);

      // store new sessions if necessary.
      final List<PuttingSession> newSessions =
          SessionHelpers.getNewSessions(completedSessions, cloudSessions);

      // delete sessions that failed to delete if necessary.
      final List<PuttingSession> deletedSessions =
          SessionHelpers.getDeletedSessions(completedSessions, cloudSessions);

      if (newSessions.isNotEmpty) {
        final bool success = await locator
            .get<LocalDBService>()
            .storeCompletedSessions(combinedSessions);
        if (!success) {
          log('Failed to save new cloud sessions in local DB');
        }
      }

      completedSessions = combinedSessions;

      if (deletedSessions.isNotEmpty) {
        await FBSessionsDataWriter.instance
            .deleteSessionsBatch(deletedSessions);
      }
    }
  }

  Future<bool> _storeCompletedSessionsInLocalDB() {
    final int sessionsLengthBefore =
        locator.get<LocalDBService>().retrieveCompletedSessions()?.length ?? 0;
    return locator
        .get<LocalDBService>()
        .storeCompletedSessions(completedSessions)
        .then((success) {
      final int sessionsLengthAfter =
          locator.get<LocalDBService>().retrieveCompletedSessions()?.length ??
              0;
      print(
          'sessions before: $sessionsLengthBefore, sessions after: $sessionsLengthAfter');
      return success;
    });
  }

  Future<bool> _setCompletedSessionToSynced(PuttingSession session) async {
    int? sessionIndex;
    for (int i = 0; i < completedSessions.length; i++) {
      final PuttingSession completedSession = completedSessions[i];
      if (completedSession.id == session.id) {
        sessionIndex = i;
      }
    }
    if (sessionIndex != null) {
      final Map<String, dynamic> sessionJson = session.toJson();
      sessionJson['isSynced'] = true;
      final PuttingSession syncedSession = PuttingSession.fromJson(sessionJson);
      completedSessions[sessionIndex] = syncedSession;
      return _storeCompletedSessionsInLocalDB();
    } else {
      return false;
    }
  }

  void clearData() {
    currentSession = null;
    completedSessions = [];
  }
}
