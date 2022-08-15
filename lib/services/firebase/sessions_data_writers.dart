import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:myputt/models/data/sessions/putting_session.dart';
import 'package:myputt/services/firebase/utils/fb_constants.dart';

final FirebaseFirestore firestore = FirebaseFirestore.instance;

class FBSessionsDataWriter {
  Future<bool> setCurrentSession(PuttingSession currentSession, uid) async {
    final currentSessionReference = firestore.doc('$sessionsCollection/$uid');

    return currentSessionReference
        .set(
          {'currentSession': currentSession.toJson()},
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

  Future<bool> updateCurrentSession(PuttingSession currentSession, uid) async {
    final currentSessionReference = firestore.doc('$sessionsCollection/$uid');

    return currentSessionReference
        .set(
          {'currentSession': currentSession.toJson()},
          SetOptions(merge: true),
        )
        .then((value) => true)
        .catchError(
          (e, trace) {
            FirebaseCrashlytics.instance.recordError(
              e,
              trace,
              reason:
                  '[FBSessionsDataWriter][updateCurrentSession] firestore write exception',
            );
            return false;
          },
        );
  }

  Future<bool> deleteCurrentSession(uid) async {
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

  Future<bool> addCompletedSession(PuttingSession completedSession, uid) async {
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

  Future<bool> deleteCompletedSession(
      PuttingSession currentSession, uid) async {
    final previousSessionReference = firestore.doc(
        '$sessionsCollection/$uid/$completedSessionsCollection/${currentSession.id}');

    return previousSessionReference.delete().then((value) => true).catchError(
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
}
