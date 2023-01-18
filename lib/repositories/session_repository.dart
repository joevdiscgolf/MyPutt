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
  List<PuttingSession> allSessions = [];
  final DatabaseService _databaseService = DatabaseService();

  Future<void> addCompletedSession(PuttingSession sessionToAdd) async {
    allSessions.add(sessionToAdd);
    await _databaseService.addCompletedSession(sessionToAdd);
  }

  void deleteSession(PuttingSession sessionToDelete) {
    allSessions.remove(sessionToDelete);
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

  List<PuttingSession> get sessions {
    return allSessions;
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

  Future<void> fetchLocalCompletedSessions() async {
    final List<PuttingSession>? localDbSessions =
        await locator.get<LocalDBService>().retrieveCompletedSessions();

    if (localDbSessions != null) {
      allSessions = localDbSessions;
    }
  }

  Future<void> syncCloudWithLocalSessions() async {
    List<PuttingSession> unsyncedSessions =
        allSessions.where((session) => session.isSynced != true).toList();
    unsyncedSessions = SessionHelpers.setSyncedToTrue(unsyncedSessions);

    if (unsyncedSessions.isEmpty) {
      return;
    }

    // save unsynced sessions in firestore.
    final bool success =
        await FBSessionsDataWriter.instance.setSessionsBatch(sessions);

    if (!success) {
      // trigger error toast
      return;
    }

    allSessions = SessionHelpers.mergeSessions(unsyncedSessions, allSessions);
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
      final List<PuttingSession> unsyncedSessions =
          List.from(allSessions.where((session) => session.isSynced != true));
      final List<PuttingSession> combinedSessions =
          SessionHelpers.mergeSessions(unsyncedSessions, cloudSessions);

      // store new sessions if necessary.
      final List<PuttingSession> newSessions =
          SessionHelpers.getNewSessions(allSessions, cloudSessions);

      if (newSessions.isNotEmpty) {
        final bool success = await locator
            .get<LocalDBService>()
            .storeCompletedSessions(combinedSessions);
        if (!success) {
          log('Failed to save new cloud sessions in local DB');
        }
      }

      allSessions = combinedSessions;
      await locator.get<LocalDBService>().storeCompletedSessions(allSessions);
    }
  }

  List<PuttingSession> getSessionsWithRange(int range) {
    allSessions.sort((s1, s2) => s1.timeStamp.compareTo(s2.timeStamp));
    final List<PuttingSession> selectedSessions =
        allSessions.take(range).toList();
    return range == 0 ? allSessions : selectedSessions;
  }

  void clearData() {
    currentSession = null;
    allSessions = [];
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
