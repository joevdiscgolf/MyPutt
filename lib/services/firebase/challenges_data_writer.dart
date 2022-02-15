import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:myputt/data/types/myputt_user.dart';
import 'package:myputt/data/types/challenges/putting_challenge.dart';
import 'package:myputt/utils/constants.dart';

import '../../data/types/storage_putting_challenge.dart';

final FirebaseFirestore firestore = FirebaseFirestore.instance;

class FBChallengesDataWriter {
  Future<bool> setPuttingChallenge(
      MyPuttUser currentUser, PuttingChallenge puttingChallenge) {
    final currentSessionReference = firestore.doc(
        '$challengesCollection/${currentUser.uid}/$challengesCollection/${puttingChallenge.id}');

    return currentSessionReference
        .set(
            StoragePuttingChallenge.fromPuttingChallenge(
                    puttingChallenge, currentUser)
                .toJson(),
            SetOptions(merge: true))
        .then((value) => true)
        .catchError((error) => false);
  }

  Future<bool> sendPuttingChallenge(String recipientUid, String currentUid,
      StoragePuttingChallenge storageChallenge) {
    print('sending test challenge');
    final challengeRef = firestore.doc(
        '$challengesCollection/$recipientUid/$challengesCollection/${storageChallenge.id}');

    return challengeRef
        .set(storageChallenge.toJson())
        .then((value) => true)
        .catchError((error) => false);
  }
}
