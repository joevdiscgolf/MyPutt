import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:myputt/data/types/myputt_user.dart';
import 'package:myputt/utils/constants.dart';

FirebaseFirestore firestore = FirebaseFirestore.instance;

class FBUserDataLoader {
  Future<MyPuttUser?> getUser(String uid) async {
    final currentSessionReference = firestore.doc('$usersCollection/$uid');
    final snapshot = await currentSessionReference.get();
    if (snapshot.exists) {
      final Map<String, dynamic>? data = snapshot.data();
      return MyPuttUser.fromJson(data!);
    } else {
      return null;
    }
  }
}
