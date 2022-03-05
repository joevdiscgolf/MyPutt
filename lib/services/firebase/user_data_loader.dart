import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:myputt/data/types/users/myputt_user.dart';
import 'package:myputt/services/firebase/fb_constants.dart';

FirebaseFirestore firestore = FirebaseFirestore.instance;

class FBUserDataLoader {
  Future<MyPuttUser?> getUser(String uid) async {
    final currentSessionReference = firestore.doc('$usersCollection/$uid');
    final snapshot = await currentSessionReference.get();
    if (snapshot.exists &&
        isValidUser(snapshot.data() as Map<String, dynamic>)) {
      final Map<String, dynamic>? data = snapshot.data();
      return MyPuttUser.fromJson(data!);
    } else {
      return null;
    }
  }

  Future<List<MyPuttUser>> getUsersByUsername(String username) async {
    QuerySnapshot querySnapshot = await firestore
        .collection(usersCollection)
        .where('keywords', arrayContains: username)
        .get()
        .catchError((error) {
      print(error);
    });

    final List<MyPuttUser?> users = querySnapshot.docs.map((doc) {
      if (doc.exists) {
        return MyPuttUser.fromJson(doc.data() as Map<String, dynamic>);
      } else {
        return null;
      }
    }).toList();

    List<MyPuttUser> existingUsers = [];

    for (var user in users) {
      if (user != null) {
        existingUsers.add(user);
      }
    }

    return existingUsers;
  }

  bool isValidUser(Map<String, dynamic> data) {
    return data['username'] != null &&
        data['displayName'] != null &&
        data['uid'] != null;
  }
}
