import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:myputt/locator.dart';
import 'package:myputt/models/data/users/myputt_user.dart';
import 'package:myputt/services/firebase/utils/fb_constants.dart';
import 'package:myputt/services/myputt_auth_service.dart';
import 'package:myputt/utils/constants.dart';

final FirebaseFirestore firestore = FirebaseFirestore.instance;

class UserService {
  Future<bool> deleteUser(MyPuttUser user) async {
    final MyPuttAuthService myPuttAuthService =
        locator.get<MyPuttAuthService>();
    final String uid = user.uid;
    final String username = user.username;
    WriteBatch batch = FirebaseFirestore.instance.batch();

    final DocumentReference sessionsRef =
        firestore.collection(sessionsCollection).doc(uid);
    final DocumentReference challengesRef =
        firestore.collection(challengesCollection).doc(uid);
    final DocumentReference usernameRef =
        firestore.collection(usernamesCollection).doc(username);
    final DocumentReference userDocRef =
        firestore.collection(usersCollection).doc(uid);

    batch.delete(sessionsRef);
    batch.delete(challengesRef);
    batch.delete(usernameRef);
    batch.delete(userDocRef);

    bool commitSuccess;
    try {
      commitSuccess = await batch
          .commit()
          .then((_) => true)
          .timeout(shortTimeout)
          .catchError(
        (e, trace) {
          FirebaseCrashlytics.instance.recordError(e, trace);
          return false;
        },
      );
    } catch (e, trace) {
      commitSuccess = false;
      FirebaseCrashlytics.instance.recordError(e, trace);
    }

    if (commitSuccess) {
      return myPuttAuthService.deleteCurrentUser();
    } else {
      return false;
    }
  }
}
