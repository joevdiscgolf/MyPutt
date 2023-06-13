import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:myputt/models/data/users/myputt_user.dart';
import 'package:myputt/locator.dart';
import 'package:myputt/services/firebase/utils/firebase_utils.dart';
import 'package:myputt/services/firebase_auth_service.dart';
import 'package:myputt/services/firebase/utils/fb_constants.dart';
import 'package:myputt/utils/constants.dart';

FirebaseFirestore firestore = FirebaseFirestore.instance;

class FBUserDataLoader {
  static final FBUserDataLoader instance = FBUserDataLoader._internal();

  factory FBUserDataLoader() {
    return instance;
  }

  FBUserDataLoader._internal();

  Future<MyPuttUser?> getCurrentUser({
    Duration timeoutDuration = shortTimeout,
  }) async {
    final String? uid = locator.get<FirebaseAuthService>().getCurrentUserId();
    if (uid == null) {
      return null;
    }

    return firestoreFetch('$usersCollection/$uid',
            timeoutDuration: timeoutDuration)
        .then((snapshot) {
      if (snapshot == null ||
          !snapshot.exists ||
          !isValidUser(snapshot.data() as Map<String, dynamic>)) {
        return null;
      }
      final Map<String, dynamic> data = snapshot.data()!;
      return MyPuttUser.fromJson(data);
    });
  }

  Future<Map<String, dynamic>?> getUserJson() async {
    final String? uid = locator.get<FirebaseAuthService>().getCurrentUserId();
    if (uid == null) {
      return null;
    }

    return firestore.doc('$usersCollection/$uid').get().then((snapshot) {
      if (snapshot.exists) {
        return snapshot.data() as Map<String, dynamic>;
      } else {
        return null;
      }
    }).catchError((e, trace) {
      FirebaseCrashlytics.instance.recordError(
        e,
        trace,
        reason: '[FBUserDataLoader][getUserJson] Firestore Exception',
      );
      return null;
    });
  }

  Future<List<MyPuttUser>> getUsersByUsername(String username) async {
    final FirebaseAuthService authService = locator.get<FirebaseAuthService>();
    final String? currentUid = authService.getCurrentUserId();
    if (currentUid == null) {
      return [];
    }
    return firestore
        .collection(usersCollection)
        .where('keywords', arrayContains: username)
        .get()
        .then(
      (QuerySnapshot querySnapshot) {
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
      },
    ).catchError((e, trace) {
      log(e);
      FirebaseCrashlytics.instance.recordError(
        e,
        trace,
        reason:
            '[FBUserDataLoader][getUsersByUsername] firestore read exception',
      );
      return <MyPuttUser>[];
    });
  }

  bool isValidUser(Map<String, dynamic>? data) {
    return data?['username'] != null &&
        data?['displayName'] != null &&
        data?['uid'] != null;
  }
}
