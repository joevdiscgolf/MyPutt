import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:myputt/data/types/putting_challenge.dart';
import 'package:myputt/utils/constants.dart';

final FirebaseFirestore firestore = FirebaseFirestore.instance;

class FBChallengesDataWriter {
  Future<bool> setPuttingChallenge(
      String uid, PuttingChallenge puttingChallenge) {
    final currentSessionReference = firestore.doc(
        '$challengesCollection/$uid/$challengesCollection/$puttingChallenge.id');

    return currentSessionReference
        .set(puttingChallenge.toJson(), SetOptions(merge: true))
        .then((value) => true)
        .catchError((error) => false);
  }
}
