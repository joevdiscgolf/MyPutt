import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../data/types/myputt_user.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String exception = '';

  Future<User?> getUser() async {
    try {
      return _auth.currentUser;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Stream<User?> get user {
    return _auth.userChanges();
  }

  String? getCurrentUserId() {
    return _auth.currentUser?.uid;
  }

  Future<String?> getAuthToken() async {
    try {
      return _auth.currentUser?.getIdToken();
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future<bool> signUpWithEmail(String inputEmail, String inputPassword) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
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

  Future<bool?> signInWithEmail(String inputEmail, String inputPassword) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(
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
      print(e);
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
    } catch (e) {
      print(e.toString());
      return false;
    }
  }

  Future<bool> setupNewUser(String username) async {
    final User? user = await getUser();
    if (user == null) {
      return false;
    }

    return FirebaseFirestore.instance
        .collection('Users')
        .doc(user.uid)
        // ignore: always_specify_types
        .set({}, SetOptions(merge: true))
        .then((_) async {
          return FirebaseFirestore.instance
              .collection('Usernames')
              .doc(username)
              .set(<String, dynamic>{
            'username': username,
            'uid': user.uid,
          });
        })
        .then((_) async => user.updateDisplayName(username))
        .then((_) => true)
        .catchError((e) {
          print(e.toString());
          return false;
        });
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
        .catchError((e) {
      print(e.toString());
    });
  }

  Future<bool> userIsSetup() async {
    MyPuttUser currentMyPuttUser;
    if (_auth.currentUser?.uid == null) {
      return false;
    }
    final DocumentSnapshot<dynamic> userDoc = await FirebaseFirestore.instance
        .collection('Users')
        .doc(_auth.currentUser!.uid)
        .get();
    if (!userDoc.exists) {
      return false;
    } else {
      currentMyPuttUser = MyPuttUser.fromJson(userDoc as Map<String, dynamic>);
      if (currentMyPuttUser.username != null &&
          currentMyPuttUser.displayName != null) {
        return true;
      } else {
        return false;
      }
    }
  }

  Future<void> logOut() async {
    try {
      return await _auth.signOut();
    } catch (error) {
      print(error.toString());
    }
  }
}
