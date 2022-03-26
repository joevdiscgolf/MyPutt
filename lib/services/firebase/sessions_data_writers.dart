import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:myputt/data/types/putting_session.dart';
import 'package:myputt/services/firebase/fb_constants.dart';

final FirebaseFirestore firestore = FirebaseFirestore.instance;

class FBSessionsDataWriter {
  Future<bool> setCurrentSession(PuttingSession currentSession, uid) async {
    final currentSessionReference = firestore.doc('$sessionsCollection/$uid');

    return currentSessionReference
        .set(
          {'currentSession': currentSession.toJson()},
        )
        .then((value) => true)
        .catchError((error) => false);
  }

  Future<bool> updateCurrentSession(PuttingSession currentSession, uid) async {
    final currentSessionReference = firestore.doc('$sessionsCollection/$uid');

    return currentSessionReference
        .set({'currentSession': currentSession.toJson()},
            SetOptions(merge: true))
        .then((value) => true)
        .catchError((error) => false);
  }

  Future<bool> deleteCurrentSession(uid) async {
    final currentSessionReference = firestore.doc('$sessionsCollection/$uid');

    return currentSessionReference
        .update({'currentSession': null})
        .then((value) => true)
        .catchError((error) => false);
  }

  Future<bool> addCompletedSession(PuttingSession completedSession, uid) async {
    final previousSessionReference = firestore.doc(
        '$sessionsCollection/$uid/$completedSessionsCollection/${completedSession.id}');

    return previousSessionReference
        .set(completedSession.toJson())
        .then((value) => true)
        .catchError((error) => false);
  }

  Future<bool> deleteCompletedSession(
      PuttingSession currentSession, uid) async {
    final previousSessionReference = firestore.doc(
        '$sessionsCollection/$uid/$completedSessionsCollection/${currentSession.id}');

    return previousSessionReference
        .delete()
        .then((value) => true)
        .catchError((error) => false);
  }
}
