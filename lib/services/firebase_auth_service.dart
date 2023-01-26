import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:myputt/locator.dart';
import 'package:myputt/models/data/users/username_doc.dart';
import 'package:myputt/models/data/users/myputt_user.dart';
import 'package:myputt/services/shared_preferences_service.dart';
import 'package:myputt/services/user_service.dart';
import 'package:myputt/utils/string_helpers.dart';

final FirebaseAuth auth = FirebaseAuth.instance;

class FirebaseAuthService {
  final FirebaseAuth _auth = auth;

  String exception = '';

  Future<User?> getUser() async {
    try {
      return _auth.currentUser;
    } catch (e, trace) {
      log(e.toString());
      log(trace.toString());
      FirebaseCrashlytics.instance.recordError(
        e,
        trace,
        reason: '[FirebaseAuthService][getUser] exception',
      );
      return null;
    }
  }

  Stream<User?> get user {
    return _auth.userChanges();
  }

  String? getCurrentUserId() {
    return _auth.currentUser?.uid;
  }

  Future<bool> deleteCurrentUser() async {
    if (_auth.currentUser == null) {
      return false;
    }
    return _auth.currentUser!.delete().then((_) => true).catchError((e, trace) {
      return false;
    });
  }

  Future<String?> getAuthToken() async {
    try {
      return _auth.currentUser?.getIdToken();
    } catch (e, trace) {
      log(e.toString());
      log(trace.toString());
      FirebaseCrashlytics.instance.recordError(
        e,
        trace,
        reason: '[FirebaseAuthService][getAuthToken] exception',
      );
      return null;
    }
  }

  Future<bool> signUpWithEmail(String inputEmail, String inputPassword) async {
    try {
      UserCredential userCredential = await auth.createUserWithEmailAndPassword(
          email: inputEmail, password: inputPassword);
      if (userCredential.user == null) {
        return false;
      }
      return await FirebaseFirestore.instance
          .collection('Users')
          .doc(userCredential.user?.uid)
          .set(<String, dynamic>{
        'uid': userCredential.user?.uid,
        'createdAt': DateTime.now().toUtc().toIso8601String()
      }).then((_) => true);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        exception = 'The password provided is too weak.';
      } else if (e.code == 'email-already-in-use') {
        exception = 'Email already in use';
      }
      return false;
    }
  }

  Future<bool> signInWithEmail(String inputEmail, String inputPassword) async {
    try {
      UserCredential userCredential = await auth.signInWithEmailAndPassword(
          email: inputEmail, password: inputPassword);
      if (userCredential.user == null) {
        return false;
      }
      return true;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        exception = 'No user found for that email.';
      } else if (e.code == 'wrong-password') {
        exception = 'Wrong password provided for that user.';
      }
      log(e.toString());
      return false;
    }
  }

  Future<bool> usernameIsAvailable(String username) async {
    try {
      final DocumentSnapshot<dynamic> usernameDoc = await FirebaseFirestore
          .instance
          .collection('Usernames')
          .doc(username)
          .get();
      return !usernameDoc.exists;
    } catch (e, trace) {
      log(e.toString());
      log(trace.toString());
      FirebaseCrashlytics.instance.recordError(
        e,
        trace,
        reason: '[FirebaseAuthSErvice][usernameIsAvailable] exception',
      );
      return false;
    }
  }

  Future<MyPuttUser?> setupNewUser(
    String username,
    String displayName, {
    int? pdgaNumber,
  }) async {
    final User? user = await getUser();
    if (user == null) {
      return null;
    }
    final userDoc =
        FirebaseFirestore.instance.collection('Users').doc(user.uid);
    WriteBatch batch = FirebaseFirestore.instance.batch();
    final usernameDoc =
        FirebaseFirestore.instance.collection('Usernames').doc(username);
    final MyPuttUser newUser = pdgaNumber != null
        ? MyPuttUser(
            keywords: getPrefixes(username),
            username: username,
            displayName: displayName,
            uid: user.uid,
            pdgaNum: pdgaNumber)
        : MyPuttUser(
            keywords: getPrefixes(username),
            username: username,
            displayName: displayName,
            uid: user.uid,
          );
    batch.set(userDoc, newUser.toJson());
    batch.set(
        usernameDoc, UsernameDoc(username: username, uid: user.uid).toJson());
    await batch.commit().catchError((e, trace) {
      log(e);
      FirebaseCrashlytics.instance.recordError(
        e,
        trace,
        reason:
            '[FirebaseAuthService][setUpNewUser] firestore batch commit exception',
      );
      return null;
    });

    locator.get<SharedPreferencesService>().markUserIsSetUp(true);

    return newUser;
  }

  Future<void> saveUserInfo(String name, String? bio) async {
    final User? user = await getUser();
    if (user == null) {
      return;
    }

    Map<String, String> userData = <String, String>{
      'name': name,
    };
    if (bio != null && bio.trim().isNotEmpty) {
      userData['bio'] = bio;
    }

    await FirebaseFirestore.instance
        .collection('Users')
        .doc(user.uid)
        .update(userData)
        .catchError((e, trace) {
      log(e);
      FirebaseCrashlytics.instance.recordError(
        e,
        trace,
        reason: '[FirebaseAuthService][saveUserInfo] firestore exception',
      );
    });
  }

  Future<bool?> userIsSetup() async {
    if (_auth.currentUser?.uid == null) {
      return null;
    }
    try {
      return locator
          .get<UserService>()
          .getUser()
          .then((MyPuttUser? user) => userIsValid(user));

      // final DocumentSnapshot<dynamic>? userDoc = await FirebaseFirestore
      //     .instance
      //     .collection('Users')
      //     .doc(_auth.currentUser!.uid)
      //     .get()
      //     .catchError((e, trace) {
      //   log(e.toString());
      //   FirebaseCrashlytics.instance.recordError(
      //     e,
      //     trace,
      //     reason: '[FirebaseAuthService][userIsSetUp] firestore read exception',
      //   );
      // }).timeout(shortTimeout);
      // if (userDoc?.data() == null) {
      //   return null;
      // } else if (!userDocIsValid(userDoc?.data() as Map<String, dynamic>)) {
      //   return false;
      // } else {
      //   return true;
      // }
    } catch (e, trace) {
      log(e.toString());
      log(trace.toString());
      FirebaseCrashlytics.instance.recordError(
        e,
        trace,
        reason: '[AuthService][userIsSetup] get User timeout',
      );
      return null;
    }
  }

  Future<bool> sendPasswordReset(String email) {
    return auth
        .sendPasswordResetEmail(email: email)
        .then((response) => true)
        .catchError((e, trace) {
      log(e.toString());
      FirebaseCrashlytics.instance.recordError(
        e,
        trace,
        reason:
            '[FirebaseAuthService][sendPasswordReset] sendPasswordResetEmail() exception',
      );
      return false;
    });
  }

  Future<void> logOut() async {
    try {
      return await _auth.signOut();
    } catch (e, trace) {
      log(e.toString());
      log(trace.toString());
      FirebaseCrashlytics.instance.recordError(
        e,
        trace,
        reason: '[FirebaseAuthSErvice][logOut] exception',
      );
    }
  }

  bool userDocIsValid(Map<String, dynamic> doc) {
    return doc['username'] != null && doc['displayName'] != null;
  }

  bool userIsValid(MyPuttUser? user) {
    return user?.username != null && user?.displayName != null;
  }
}
