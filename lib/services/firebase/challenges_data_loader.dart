import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:myputt/data/types/myputt_user.dart';
import 'package:myputt/data/types/putting_challenge.dart';
import 'package:myputt/data/types/storage_putting_challenge.dart';
import 'package:myputt/utils/constants.dart';

FirebaseFirestore firestore = FirebaseFirestore.instance;

class FBChallengesDataLoader {
  Future<List<PuttingChallenge>> getPuttingChallengesWithStatus(
      MyPuttUser currentUser, String status) async {
    QuerySnapshot querySnapshot = await firestore
        .collection(
            '$challengesCollection/${currentUser.uid}/$challengesCollection')
        .where('status', isEqualTo: status)
        .get()
        .catchError((error) {
      if (kDebugMode) {
        print('[getPuttingChallenges] $error, status: $status');
      }
    });

    return querySnapshot.docs.map((doc) {
      return PuttingChallenge.fromStorageChallenge(
          StoragePuttingChallenge.fromJson(doc.data() as Map<String, dynamic>),
          currentUser);
    }).toList();
  }

  Future<PuttingChallenge?> getCurrentPuttingChallenge(
      MyPuttUser currentUser) async {
    final DocumentSnapshot<dynamic> snapshot =
        await firestore.doc('$challengesCollection/${currentUser.uid}').get();

    if (snapshot.exists &&
        isValidStorageChallenge(snapshot.data() as Map<String, dynamic>)) {
      return PuttingChallenge.fromStorageChallenge(
          StoragePuttingChallenge.fromJson(
              snapshot.data() as Map<String, dynamic>),
          currentUser);
    } else {
      return null;
    }
  }

  bool isValidStorageChallenge(Map<String, dynamic> data) {
    return data['id'] != null;
  }
}
