import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:myputt/data/types/my_putt_user.dart';

class AuthService {
  final DateFormat _formatter = DateFormat.yMMMMd('en_US');
  final FirebaseAuth _auth = FirebaseAuth.instance;

  AuthService() {}

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
    //return _auth.currentUser?.uid;
    return 'BnisFzLsy0PnJuXv26BQ86HTVJk2'; // Test user uid
  }

  Future<String?> getAuthToken() async {
    try {
      return _auth.currentUser?.getIdToken();
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future<User?> signInWithPhoneNumber(
      String verificationId, String smsCode) async {
    try {
      final PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: smsCode,
      );
      final User? user = await _auth
          .signInWithCredential(credential)
          .then((UserCredential result) => result.user);
      if (user == null) {
        return null;
      }

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
