import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:myputt/data/types/putting_session.dart';
import 'package:myputt/utils/constants.dart';
import 'package:myputt/data/types/sessions_document.dart';

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
