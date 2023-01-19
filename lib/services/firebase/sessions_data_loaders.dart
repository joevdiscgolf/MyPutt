import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:myputt/models/data/sessions/putting_session.dart';
import 'package:myputt/services/firebase/utils/fb_constants.dart';
import 'package:myputt/models/data/sessions/sessions_document.dart';

FirebaseFirestore firestore = FirebaseFirestore.instance;

class FBSessionsDataLoader {
  Future<SessionsDocument?> getUserSessionsDocument(String uid) async {
    final currentSessionReference = firestore.doc('$sessionsCollection/$uid');
    final snapshot = await currentSessionReference.get();
    if (snapshot.exists) {
      final Map<String, dynamic>? data = snapshot.data();
      return SessionsDocument.fromJson(data!);
    } else {
      return null;
    }
  }

  Future<List<PuttingSession>?> getCompletedSessions(String uid) async {
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
    ).catchError(
      (e, trace) async {
        log(e.toString());
        FirebaseCrashlytics.instance.recordError(
          e,
          trace,
          reason:
              '[FBSessionsDataLoader][getCompletedSessions] firestore read exception',
        );
      },
    );
  }
}
