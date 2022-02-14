import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:myputt/data/types/putting_challenge.dart';
import 'package:myputt/utils/constants.dart';

import '../../data/types/storage_putting_challenge.dart';

final FirebaseFirestore firestore = FirebaseFirestore.instance;

class FBChallengesDataWriter {
  Future<bool> setPuttingChallenge(
      String uid, PuttingChallenge puttingChallenge) {
    final currentSessionReference = firestore.doc(
        '$challengesCollection/$uid/$challengesCollection/$puttingChallenge.id');

    return currentSessionReference
        .set(
            StoragePuttingChallenge.fromPuttingChallenge(puttingChallenge, uid)
                .toJson(),
            SetOptions(merge: true))
        .then((value) => true)
        .catchError((error) => false);
  }
}
