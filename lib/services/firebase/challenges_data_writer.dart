import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:myputt/data/types/myputt_user.dart';
import 'package:myputt/data/types/challenges/putting_challenge.dart';
import 'package:myputt/utils/constants.dart';

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

  Future<bool> sendPuttingChallenge(String recipientUid, MyPuttUser currentUser,
      StoragePuttingChallenge storageChallenge) {
    final challengeRef = firestore.doc(
        '$challengesCollection/$recipientUid/$challengesCollection/${storageChallenge.id}');
    return challengeRef
        .set(storageChallenge.toJson())
        .then((value) => true)
        .catchError((error) => false);
  }

  Future<bool> sendTestChallenge(String recipientUid, MyPuttUser challengerUser,
      StoragePuttingChallenge storageChallenge) {
    print('sending test challenge');
    final challengeRef = firestore.doc(
        '$challengesCollection/$recipientUid/$challengesCollection/${storageChallenge.id}');

    return challengeRef
        .set(storageChallenge.toJson())
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
