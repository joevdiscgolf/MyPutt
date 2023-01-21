import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:myputt/locator.dart';
import 'package:myputt/models/data/sessions/putting_session.dart';
import 'package:myputt/services/firebase/utils/fb_constants.dart';
import 'package:myputt/services/firebase_auth_service.dart';

final FirebaseFirestore firestore = FirebaseFirestore.instance;

class FBSessionsDataWriter {
  static final FBSessionsDataWriter instance = FBSessionsDataWriter._internal();

  factory FBSessionsDataWriter() {
    return instance;
  }

  FBSessionsDataWriter._internal();

  Future<bool> setCurrentSession(
    PuttingSession currentSession, {
    bool merge = false,
  }) async {
    final String? uid = locator.get<FirebaseAuthService>().getCurrentUserId();

    if (uid == null) {
      return false;
    }

    final currentSessionReference = firestore.doc('$sessionsCollection/$uid');

    return currentSessionReference
        .set(
          {'currentSession': currentSession.toJson()},
          SetOptions(merge: merge),
        )
        .then((value) => true)
        .catchError((e, trace) {
          FirebaseCrashlytics.instance.recordError(
            e,
            trace,
            reason:
                '[FBSessionsDataWriter][setCurrentSession] firestore write exception',
          );
          return false;
        });
  }

  Future<bool> deleteCurrentSession() async {
    final String? uid = locator.get<FirebaseAuthService>().getCurrentUserId();
    if (uid == null) {
      return false;
    }

    final currentSessionReference = firestore.doc('$sessionsCollection/$uid');

    return currentSessionReference
        .update({'currentSession': null})
        .then((value) => true)
        .catchError(
          (e, trace) {
            FirebaseCrashlytics.instance.recordError(
              e,
              trace,
              reason:
                  '[FBSessionsDataWriter][deleteCurrentSession] firestore delete exception',
            );
            return false;
          },
        );
  }

  Future<bool> addCompletedSession(PuttingSession completedSession) async {
    final String? uid = locator.get<FirebaseAuthService>().getCurrentUserId();
    if (uid == null) {
      return false;
    }

    final previousSessionReference = firestore.doc(
        '$sessionsCollection/$uid/$completedSessionsCollection/${completedSession.id}');

    return previousSessionReference
        .set(completedSession.toJson())
        .then((value) => true)
        .catchError(
      (e, trace) {
        FirebaseCrashlytics.instance.recordError(
          e,
          trace,
          reason:
              '[FBSessionsDataWriter][addCompletedSession] firestore delete exception',
        );
        return false;
      },
    );
  }

  Future<bool> deleteCompletedSession(String sessionId) async {
    final String? uid = locator.get<FirebaseAuthService>().getCurrentUserId();
    if (uid == null) {
      return false;
    }

    return firestore
        .doc('$sessionsCollection/$uid/$completedSessionsCollection/$sessionId')
        .delete()
        .then((value) => true)
        .catchError(
      (e, trace) {
        FirebaseCrashlytics.instance.recordError(
          e,
          trace,
          reason:
              '[FBSessionsDataWriter][deleteCompletedSession] firestore delete exception',
        );
        return false;
      },
    );
  }

  Future<bool> deleteSessionsBatch(
    List<PuttingSession> sessionsToDelete,
  ) async {
    final String? uid = locator.get<FirebaseAuthService>().getCurrentUserId();

    if (uid == null) {
      return false;
    }

    final WriteBatch batch = firestore.batch();

    for (PuttingSession session in sessionsToDelete) {
      batch.delete(firestore.doc('$sessionsCollection/$uid/${session.id}'));
    }

    return batch.commit().then((_) => true).catchError(
      (e, trace) {
        FirebaseCrashlytics.instance.recordError(
          e,
          trace,
          reason:
              '[FBSessionsDataWriter][deleteSessionsBatch] firestore delete exception',
        );
        return false;
      },
    );
  }

  Future<bool> setSessionsBatch(List<PuttingSession> sessions) async {
    final String? uid = locator.get<FirebaseAuthService>().getCurrentUserId();

    if (uid == null) {
      return false;
    }

    final WriteBatch batch = firestore.batch();

    for (PuttingSession session in sessions) {
      batch.set(
        firestore.doc('$sessionsCollection/$uid/${session.id}'),
        session.toJson(),
      );
    }

    return batch.commit().then((_) => true).catchError(
      (e, trace) {
        FirebaseCrashlytics.instance.recordError(
          e,
          trace,
          reason:
              '[FBSessionsDataWriter][setSessionsBatch] firestore delete exception',
        );
        return false;
      },
    );
  }
}
