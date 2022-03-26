import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:myputt/services/firebase/fb_constants.dart';

FirebaseFirestore firestore = FirebaseFirestore.instance;

Future<void> renameSessionsForUser(String uid) async {
  final QuerySnapshot? snapshot = await firestore
      .collection('$sessionsCollection/$uid/$completedSessionsCollection')
      .get()
      .catchError((e) => print(e));

  snapshot?.docs.forEach((doc) async {
    final Map<String, dynamic>? data = doc.data() as Map<String, dynamic>?;
    data?['id'] = '$uid~${data['timeStamp']}';

    if (!doc.id.contains(uid)) {
      await firestore
          .doc(
              '$sessionsCollection/$uid/$completedSessionsCollection/${doc.id}')
          .delete();
    }

    // if (doc.id.contains(uid)) {
    //   print('${doc.id}');
    //   await firestore
    //       .doc(
    //           '$sessionsCollection/$uid/$completedSessionsCollection/${doc.id}')
    //       .delete();
    // }
    // if (data != null && data['id'] != null) {
    //   firestore
    //       .doc(
    //           '$sessionsCollection/$uid/$completedSessionsCollection/${data['id']}')
    //       .set((data));
    // }
  });
}
