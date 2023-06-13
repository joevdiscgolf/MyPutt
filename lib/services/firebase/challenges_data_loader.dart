import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:myputt/models/data/users/myputt_user.dart';
import 'package:myputt/models/data/challenges/putting_challenge.dart';
import 'package:myputt/models/data/challenges/storage_putting_challenge.dart';
import 'package:myputt/services/firebase/utils/fb_constants.dart';
import 'package:myputt/services/firebase/utils/firebase_utils.dart';
import 'package:myputt/utils/constants.dart';

FirebaseFirestore firestore = FirebaseFirestore.instance;

class FBChallengesDataLoader {
  static final FBChallengesDataLoader instance =
      FBChallengesDataLoader._internal();

  factory FBChallengesDataLoader() {
    return instance;
  }

  FBChallengesDataLoader._internal();

  Future<List<PuttingChallenge>> getPuttingChallengesByStatus(
      MyPuttUser currentUser, String status) async {
    return firestore
        .collection(
            '$challengesCollection/${currentUser.uid}/$challengesCollection')
        .where('status', isEqualTo: status)
        .get()
        .then(
      (QuerySnapshot querySnapshot) {
        return querySnapshot.docs.map(
          (doc) {
            return PuttingChallenge.fromStorageChallenge(
              StoragePuttingChallenge.fromJson(
                  doc.data() as Map<String, dynamic>),
              currentUser,
            );
          },
        ).toList();
      },
    ).catchError((e, trace) async {
      log('[getPuttingChallenges] $e, status: $status');
      FirebaseCrashlytics.instance.recordError(
        e,
        trace,
        reason:
            '[FBChallengesDataLoader][getPuttingChallengesByStatus] firestore read exception',
      );
      return <PuttingChallenge>[];
    });
  }

  Future<List<PuttingChallenge>> getAllChallenges(
    MyPuttUser currentUser,
  ) async {
    return firestore
        .collection(
            '$challengesCollection/${currentUser.uid}/$challengesCollection')
        .get()
        .then(
      (final QuerySnapshot querySnapshot) {
        return querySnapshot.docs.map(
          (doc) {
            return PuttingChallenge.fromStorageChallenge(
              StoragePuttingChallenge.fromJson(
                doc.data() as Map<String, dynamic>,
              ),
              currentUser,
            );
          },
        ).toList();
      },
    ).catchError(
      (e, trace) {
        FirebaseCrashlytics.instance.recordError(
          e,
          trace,
          reason:
              '[FBChallengesDataLoader][getAllChallenges] Firestore read exception',
        );
        return <PuttingChallenge>[];
      },
    ).timeout(tinyTimeout, onTimeout: () async {
      log('[FBChallengesDataLoader][getAllChallenges] Firestore timeout');
      return <PuttingChallenge>[];
    });
  }

  Future<PuttingChallenge?> getPuttingChallengeById(
    MyPuttUser currentUser,
    String challengeId,
  ) async {
    return firestoreFetch(
      '$challengesCollection/${currentUser.uid}/$challengesCollection/$challengeId',
      timeoutDuration: shortTimeout,
    ).then((snapshot) {
      if (snapshot == null) {
        return null;
      } else if (snapshot.exists &&
          isValidStorageChallenge(snapshot.data() as Map<String, dynamic>)) {
        return PuttingChallenge.fromStorageChallenge(
          StoragePuttingChallenge.fromJson(
              snapshot.data() as Map<String, dynamic>),
          currentUser,
        );
      } else {
        return null;
      }
    });
  }

  bool isValidStorageChallenge(Map<String, dynamic> data) {
    return data['id'] != null;
  }

  Future<StoragePuttingChallenge?> retrieveUnclaimedChallenge(
      String challengeId) async {
    final DocumentSnapshot<dynamic> snapshot = await firestore
        .doc('$unclaimedChallengesCollection/$challengeId')
        .get();

    if (snapshot.exists &&
        isValidStorageChallenge(snapshot.data() as Map<String, dynamic>)) {
      return StoragePuttingChallenge.fromJson(
          snapshot.data() as Map<String, dynamic>);
    } else {
      return null;
    }
  }

  Future<StoragePuttingChallenge?> getChallengeByUid(
      String uid, String challengeId) async {
    final DocumentSnapshot<dynamic> snapshot = await firestore
        .doc('$challengesCollection/$uid/$challengesCollection/$challengeId')
        .get();
    if (snapshot.exists &&
        isValidStorageChallenge(snapshot.data() as Map<String, dynamic>)) {
      return StoragePuttingChallenge.fromJson(
          snapshot.data() as Map<String, dynamic>);
    } else {
      return null;
    }
  }
}
