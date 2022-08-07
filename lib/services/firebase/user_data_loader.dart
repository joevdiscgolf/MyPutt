import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:myputt/models/data/users/myputt_user.dart';
import 'package:myputt/locator.dart';
import 'package:myputt/services/firebase_auth_service.dart';
import 'package:myputt/services/firebase/utils/fb_constants.dart';

FirebaseFirestore firestore = FirebaseFirestore.instance;

class FBUserDataLoader {
  Future<MyPuttUser?> getUser(String uid) async {
    final currentSessionReference = firestore.doc('$usersCollection/$uid');
    final snapshot = await currentSessionReference.get();
    if (snapshot.exists &&
        isValidUser(snapshot.data() as Map<String, dynamic>)) {
      final Map<String, dynamic> data = snapshot.data()!;
      return MyPuttUser.fromJson(data);
    } else {
      return null;
    }
  }

  Future<List<MyPuttUser>> getUsersByUsername(String username) async {
    final FirebaseAuthService authService = locator.get<FirebaseAuthService>();
    final String? currentUid = authService.getCurrentUserId();
    if (currentUid == null) {
      return [];
    }
    QuerySnapshot querySnapshot = await firestore
        .collection(usersCollection)
        .where('keywords', arrayContains: username)
        .get()
        .catchError((e) {
      log(e);
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
      if (user != null && user.uid != currentUid) {
        existingUsers.add(user);
      }
    }

    return existingUsers;
  }

  bool isValidUser(Map<String, dynamic>? data) {
    return data?['username'] != null &&
        data?['displayName'] != null &&
        data?['uid'] != null;
  }
}
