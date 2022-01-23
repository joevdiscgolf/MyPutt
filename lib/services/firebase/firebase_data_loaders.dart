import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:myputt/data/types/putting_session.dart';
import 'package:myputt/utils/constants.dart';
import 'dart:convert';

FirebaseFirestore firestore = FirebaseFirestore.instance;

class FBDataLoader {
  Future<PuttingSession?> getCurrentSession(String uid) async {
    final currentSessionReference = firestore.doc('$sessionsCollection/$uid');
    final userDocument = await currentSessionReference
        .get()
        .then<PuttingSession>((snapshot) => snapshot.data as PuttingSession)
        .catchError((error) {
      print(error.message);
    });

    return userDocument;
  }

  Future<List<PuttingSession?>> getCompletedSessions(String uid) async {
    final completedSessionsReference = firestore
        .collection('$sessionsCollection/$uid/$completedSessionsCollection');

    QuerySnapshot querySnapshot = await completedSessionsReference
        .get()
        .catchError((error) => print(error));

    return querySnapshot.docs
        .map((doc) =>
            PuttingSession.fromJson(doc.data() as Map<String, dynamic>))
        .toList();
  }
}
