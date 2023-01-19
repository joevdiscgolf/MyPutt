import 'dart:async';
import 'dart:developer';

import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:myputt/models/data/sessions/putting_session.dart';
import 'package:myputt/models/data/sessions/putting_set.dart';
import 'package:myputt/locator.dart';
import 'package:myputt/services/database_service.dart';
import 'package:myputt/services/firebase/sessions_data_writers.dart';
import 'package:myputt/services/firebase_auth_service.dart';
import 'package:myputt/services/localDB/local_db_service.dart';
import 'package:myputt/utils/constants.dart';
import 'package:myputt/utils/session_helpers.dart';

class SessionRepository {
  PuttingSession? currentSession;
  List<PuttingSession> completedSessions = [];
  final DatabaseService _databaseService = DatabaseService();

  Future<void> addCompletedSession(PuttingSession sessionToAdd) async {
    completedSessions.add(sessionToAdd);
    _updateSessionsInLocalDB();

    await _databaseService
        .addCompletedSession(sessionToAdd)
        .then((bool success) {
      if (success) {
        _setSessionToSynced(sessionToAdd);
      }
    });
  }

  void deleteSession(PuttingSession sessionToDelete) {
    completedSessions.remove(sessionToDelete);
    _updateSessionsInLocalDB();
    _databaseService.deleteCompletedSession(sessionToDelete);
  }

  Future<bool> startNewSession(PuttingSession session) async {
    final String? currentUid =
        locator.get<FirebaseAuthService>().getCurrentUserId();
    if (currentUid != null) {
      final int now = DateTime.now().millisecondsSinceEpoch;
      currentSession = PuttingSession(
        timeStamp: now,
        id: '$currentUid~$now',
      );
      return _databaseService.startCurrentSession(currentSession!);
    }
    return false;
  }

  void deleteCurrentSession() {
    currentSession = null;
    _databaseService.deleteCurrentSession();
  }

  void addSet(PuttingSet set) {
    if (currentSession != null) {
      currentSession!.addSet(set);
      _databaseService.updateCurrentSession(currentSession!);
    }
  }

  void deleteSet(PuttingSet set) {
    if (currentSession != null && currentSession?.sets != null) {
      currentSession?.sets.remove(set);
    }
  }

  Future<void> fetchCurrentSession() async {
    try {
      final PuttingSession? newCurrentSession =
          await _databaseService.getCurrentSession();
      currentSession = newCurrentSession;
    } catch (e) {
      return;
    }
  }

  void fetchLocalCompletedSessions() {
    final List<PuttingSession>? localDbSessions =
        locator.get<LocalDBService>().retrieveCompletedSessions();

    if (localDbSessions != null) {
      completedSessions = localDbSessions;
    }
  }

  Future<void> syncLocalSessionsToCloud() async {
    List<PuttingSession> unsyncedSessions =
        completedSessions.where((session) => session.isSynced != true).toList();
    unsyncedSessions = SessionHelpers.setSyncedToTrue(unsyncedSessions);

    if (unsyncedSessions.isEmpty) {
      return;
    }

    // save unsynced sessions in firestore.
    final bool success =
        await FBSessionsDataWriter.instance.setSessionsBatch(unsyncedSessions);

    if (!success) {
      // trigger error toast
      return;
    }

    completedSessions =
        SessionHelpers.mergeSessions(unsyncedSessions, completedSessions);
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
          SessionHelpers.mergeSessions(unsyncedSessions, cloudSessions);

      // store new sessions if necessary.
      final List<PuttingSession> newSessions =
          SessionHelpers.getNewSessions(completedSessions, cloudSessions);

      if (newSessions.isNotEmpty) {
        final bool success = await locator
            .get<LocalDBService>()
            .storeCompletedSessions(combinedSessions);
        if (!success) {
          log('Failed to save new cloud sessions in local DB');
        }
      }

      completedSessions = combinedSessions;
    }
  }

  List<PuttingSession> getSessionsWithRange(int range) {
    completedSessions.sort((s1, s2) => s1.timeStamp.compareTo(s2.timeStamp));
    final List<PuttingSession> selectedSessions =
        completedSessions.take(range).toList();
    return range == 0 ? completedSessions : selectedSessions;
  }

  void _updateSessionsInLocalDB() {
    locator.get<LocalDBService>().storeCompletedSessions(completedSessions);
  }

  void _setSessionToSynced(PuttingSession session) {
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
      _updateSessionsInLocalDB();
    }
  }

  void clearData() {
    currentSession = null;
    completedSessions = [];
  }
}

/*
if (successfully fetched from server) {
  merge cloud and local sessions.
  if (cloud sessions not stored locally) {
    store cloud sessions locally
  }
  set repository sessions to merged sessions.

}
 */
