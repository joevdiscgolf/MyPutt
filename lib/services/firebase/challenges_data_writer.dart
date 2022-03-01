import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:myputt/data/types/users/myputt_user.dart';
import 'package:myputt/data/types/challenges/putting_challenge.dart';
import 'package:myputt/services/firebase/fb_constants.dart';
import 'package:myputt/data/types/challenges/storage_putting_challenge.dart';

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

  Future<bool> sendChallengeToUser(String recipientUid, MyPuttUser currentUser,
      StoragePuttingChallenge storageChallenge) {
    final challengeRef = firestore.doc(
        '$challengesCollection/$recipientUid/$challengesCollection/${storageChallenge.id}');
    return challengeRef
        .set(storageChallenge.toJson())
        .then((value) => true)
        .catchError((error) => false);
  }

  Future<bool> uploadUnclaimedChallenge(
      StoragePuttingChallenge storageChallenge) {
    return firestore
        .collection('Unclaimed_Challenges')
        .doc(storageChallenge.id)
        .set(storageChallenge.toJson())
        .then((value) => true)
        .catchError((e) => false);
  }

  Future<bool> deleteUnclaimedChallenge(String challengeId) async {
    return firestore
        .doc('$unclaimedChallengesCollection/$challengeId')
        .delete()
        .then((value) => true)
        .catchError((error) => false);
  }

  Future<bool> deleteChallenge(
      String currentUid, PuttingChallenge challengeToDelete) {
    return firestore
        .doc(
            '$challengesCollection/$currentUid/$challengesCollection/${challengeToDelete.id}')
        .delete()
        .then((value) => true)
        .catchError((error) => false);
  }
}
