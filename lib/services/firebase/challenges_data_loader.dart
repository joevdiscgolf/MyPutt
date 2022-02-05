import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:myputt/data/types/putting_challenge.dart';
import 'package:myputt/utils/constants.dart';

FirebaseFirestore firestore = FirebaseFirestore.instance;

class FBChallengesDataLoader {
  Future<List<PuttingChallenge>> getPuttingChallenges(
      String uid, List<ChallengeStatus> filters) async {
    QuerySnapshot querySnapshot = await firestore
        .collection('$challengesCollection/$uid/$challengesCollection')
        //.where('status', arrayContains: filters)
        .get()
        .catchError((error) =>
            print('[getPuttingChallenges] $error, filters: $filters'));

    return querySnapshot.docs
        .map((doc) =>
            PuttingChallenge.fromJson(doc.data() as Map<String, dynamic>))
        .toList();
  }
}
