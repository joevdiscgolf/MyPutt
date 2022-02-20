import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:myputt/data/types/username_doc.dart';
import 'package:myputt/utils/utils.dart';

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

  Future<bool> setupNewUser(
      String username, String displayName, int? pdgaNumber) async {
    final User? user = await getUser();
    if (user == null) {
      return false;
    }
    final userDoc =
        FirebaseFirestore.instance.collection('Users').doc(user.uid);
    WriteBatch batch = FirebaseFirestore.instance.batch();
    final usernameDoc =
        FirebaseFirestore.instance.collection('Usernames').doc(username);
    batch.set(
        userDoc,
        MyPuttUser(
                keywords: getPrefixes(username),
                username: username,
                displayName: displayName,
                uid: user.uid,
                pdgaNum: pdgaNumber)
            .toJson());
    batch.set(
        usernameDoc, UsernameDoc(username: username, uid: user.uid).toJson());
    await batch.commit().catchError((e) {
      print(e);
      return false;
    });
    return true;
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
    if (!userDocIsValid(userDoc.data() as Map<String, dynamic>)) {
      return false;
    } else {
      currentMyPuttUser =
          MyPuttUser.fromJson(userDoc.data() as Map<String, dynamic>);
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

  bool userDocIsValid(Map<String, dynamic> doc) {
    return doc['username'] != null && doc['displayName'] != null;
  }
}
