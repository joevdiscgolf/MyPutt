import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:myputt/services/firebase/utils/fb_constants.dart';

FirebaseFirestore firestore = FirebaseFirestore.instance;

class FBUserDataWriter {
  static final FBUserDataWriter instance = FBUserDataWriter._internal();

  factory FBUserDataWriter() {
    return instance;
  }

  FBUserDataWriter._internal();

  Future<bool> updateUserWithPayload(
    String uid,
    Map<String, dynamic> userPayload,
  ) {
    return firestore
        .doc('$usersCollection/$uid')
        .set(userPayload, SetOptions(merge: true))
        .then((result) => true)
        .catchError((e, trace) {
      FirebaseCrashlytics.instance.recordError(
        e,
        trace,
        reason:
            '[FBUserDataWriter][updateUserWithPayload] firestore write exception',
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
