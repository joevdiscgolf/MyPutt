import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:myputt/models/data/sessions/putting_session.dart';
import 'package:myputt/services/firebase/utils/fb_constants.dart';
import 'package:myputt/models/data/sessions/sessions_document.dart';
import 'package:myputt/utils/constants.dart';

FirebaseFirestore firestore = FirebaseFirestore.instance;

class FBSessionsDataLoader {
  Future<SessionsDocument?> getUserSessionsDocument(String uid) async {
    try {
      final currentSessionReference = firestore.doc('$sessionsCollection/$uid');
      return currentSessionReference.get().then(
        (DocumentSnapshot<Map<String, dynamic>> snapshot) {
          if (snapshot.exists) {
            final Map<String, dynamic>? data = snapshot.data();
            return SessionsDocument.fromJson(data!);
          } else {
            return null;
          }
        },
      ).timeout(tinyTimeout);
    } catch (e, trace) {
      FirebaseCrashlytics.instance.recordError(
        e,
        trace,
        reason:
            '[FBSessionsDataLoader][getUserSessionsDocument] firestore timeout',
      );
      return null;
    }
  }

  Future<List<PuttingSession>?> getCompletedSessions(String uid) async {
    try {
      return firestore
          .collection('$sessionsCollection/$uid/$completedSessionsCollection')
          .orderBy('timeStamp')
          .get()
          .then(
        (QuerySnapshot snapshot) {
          return snapshot.docs
              .map(
                (doc) =>
                    PuttingSession.fromJson(doc.data() as Map<String, dynamic>),
              )
              .toList();
        },
      ).timeout(tinyTimeout);
    } catch (e, trace) {
      FirebaseCrashlytics.instance.recordError(
        e,
        trace,
        reason:
            '[FBSessionsDataLoader][getCompletedSessions] firestore timeout',
      );
      return null;
    }
  }
}
