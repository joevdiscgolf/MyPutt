import 'dart:async';

import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:myputt/models/data/sessions/putting_session.dart';
import 'package:myputt/services/firebase/utils/fb_constants.dart';
import 'package:myputt/models/data/sessions/sessions_document.dart';
import 'package:myputt/services/firebase/utils/firebase_utils.dart';
import 'package:myputt/utils/constants.dart';

class FBSessionsDataLoader {
  Future<SessionsDocument?> getUserSessionsDocument(String uid) async {
    try {
      return firestoreFetch('$sessionsCollection/$uid').then(
        (snapshot) {
          if (snapshot != null && snapshot.data() != null) {
            return SessionsDocument.fromJson(snapshot.data()!);
          } else {
            return null;
          }
        },
      );
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

  Future<List<PuttingSession>?> getCompletedSessions(
    String uid, {
    Duration timeoutDuration = shortTimeout,
  }) async {
    try {
      return firestoreQuery(
        path: '$sessionsCollection/$uid/$completedSessionsCollection',
        orderBy: 'timeStamp',
      ).then((querySnapshot) {
        if (querySnapshot == null) {
          return null;
        }
        return querySnapshot.docs
            .map(
              (doc) => PuttingSession.fromJson(doc.data()),
            )
            .toList();
      });
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
