import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:myputt/data/types/putting_challenge.dart';
import 'package:myputt/data/types/storage_putting_challenge.dart';
import 'package:myputt/utils/constants.dart';

FirebaseFirestore firestore = FirebaseFirestore.instance;

class FBChallengesDataLoader {
  Future<List<PuttingChallenge>> getPuttingChallenges(
      String uid, List<ChallengeStatus> filters) async {
    QuerySnapshot querySnapshot = await firestore
        .collection('$challengesCollection/$uid/$challengesCollection')
        //.where('status', arrayContains: filters)
        .get()
        .catchError((error) {
      if (kDebugMode) {
        print('[getPuttingChallenges] $error, filters: $filters');
      }
    });

    return querySnapshot.docs
        .map((doc) => PuttingChallenge.fromStorageChallenge(
            StoragePuttingChallenge.fromJson(
                doc.data() as Map<String, dynamic>),
            uid))
        .toList();
  }

  Future<PuttingChallenge?> getCurrentPuttingChallenge(String uid) async {
    final DocumentSnapshot<dynamic> snapshot =
        await firestore.doc('$challengesCollection/$uid').get();

    if (snapshot.exists &&
        isValidStorageChallenge(snapshot.data() as Map<String, dynamic>)) {
      return PuttingChallenge.fromStorageChallenge(
          StoragePuttingChallenge.fromJson(
              snapshot.data() as Map<String, dynamic>),
          uid);
    } else {
      return null;
    }
  }

  bool isValidStorageChallenge(Map<String, dynamic> data) {
    return data['id'] != null;
  }
}
