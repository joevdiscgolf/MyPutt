import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:myputt/repositories/sessions_repository.dart';
import 'package:myputt/locator.dart';
import 'package:myputt/bloc/cubits/home_screen_cubit.dart';
import 'package:myputt/bloc/cubits/sessions_cubit.dart';

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

  Future<bool?> signInWithEmail(String inputEmail, String inputPassword) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(
              email: inputEmail, password: inputPassword);
      final uid = getCurrentUserId();
      print('user signed in correctly, uid: ${uid}');
      return true;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
        exception = 'No user found for that email.';
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
        exception = 'Wrong password provided for that user.';
      }
    } catch (e) {
      print(e);
      return false;
    }

    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: inputEmail, password: inputPassword);

      return true;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
        exception = 'The password provided is too weak.';
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
        exception = 'The account already exists for that email.';
      }
    } catch (e) {
      print(e);
      return false;
    }
/*
      final bool userExists = await FirebaseFirestore.instance
          .collection('Users')
          .doc(user.uid)
          .get()
          .then((document) => document.exists);
      if (!userExists) {
        return await FirebaseFirestore.instance
            .collection('Users')
            .doc(user.uid)
            .set(<String, dynamic>{
          'uid': user.uid,
          'createdAt': DateTime.now().toUtc().toIso8601String()
        }).then((_) => user);
      }
      return user;
    } catch (e) {
      print(e);
      return null;
    }*/
    exception = 'Error signing in';
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

  /*Future<bool> setupNewUser(String username) async {
    final User? user = await getUser();
    if (user == null) {
      return false;
    }

    return FirebaseFirestore.instance
        .collection('Users')
        .doc(user.uid)
        // ignore: always_specify_types
        .update({
          'username': username,
          'avatar': _getRandomAvatar().toJson(),
          'keywords': getPrefixes(username),
          'preferences': UserPreferences(
            notificationPreferences: NotificationPreferences(
              followNotifications: true,
              tradeNotifications: true,
            ),
          ).toJson(),
          'name': 'OnlyTrades Member',
          'bio': 'Joined OnlyTrades on ${_formatter.format(DateTime.now())}.',
        })
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
  }*/

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

  Future<void> logOut() async {
    try {
      return await _auth.signOut();
    } catch (error) {
      print(error.toString());
    }
  }
}
