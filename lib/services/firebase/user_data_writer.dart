import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:myputt/models/data/users/myputt_user.dart';
import 'package:myputt/services/firebase/utils/fb_constants.dart';

FirebaseFirestore firestore = FirebaseFirestore.instance;

class FBUserDataWriter {
  Future<bool> setUserWithPayload(MyPuttUser user) {
    return firestore
        .doc('$usersCollection/${user.uid}')
        .set((user.toJson()), SetOptions(merge: true))
        .then((result) => true)
        .catchError((e, trace) {
      FirebaseCrashlytics.instance.recordError(
        e,
        trace,
        reason:
            '[FBUserDataWriter][setUserWithPayload] firestore write exception',
      );
      return false;
    });
  }

  bool isValidUser(Map<String, dynamic> data) {
    return data['username'] != null &&
        data['displayName'] != null &&
        data['uid'] != null;
  }
}
