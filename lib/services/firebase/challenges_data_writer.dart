import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:myputt/locator.dart';
import 'package:myputt/models/data/users/myputt_user.dart';
import 'package:myputt/models/data/challenges/putting_challenge.dart';
import 'package:myputt/services/firebase/utils/fb_constants.dart';
import 'package:myputt/models/data/challenges/storage_putting_challenge.dart';
import 'package:myputt/services/firebase_auth_service.dart';

final FirebaseFirestore firestore = FirebaseFirestore.instance;

class FBChallengesDataWriter {
  static final FBChallengesDataWriter instance =
      FBChallengesDataWriter._internal();

  factory FBChallengesDataWriter() {
    return instance;
  }

  FBChallengesDataWriter._internal();

  Future<bool> setPuttingChallenge(
    String currentUid,
    String recipientUid,
    String challengerUid,
    StoragePuttingChallenge storageChallenge, {
    final bool merge = false,
  }) async {
    final String? currentUid =
        locator.get<FirebaseAuthService>().getCurrentUserId();

    final bool currentUserIsChallenger = challengerUid == currentUid;

    final Map<String, dynamic> storageChallengeJson = storageChallenge.toJson();

    if (currentUserIsChallenger) {
      storageChallengeJson.remove('recipientSets');
    } else {
      storageChallengeJson.remove('challengerSets');
    }

    WriteBatch batch = FirebaseFirestore.instance.batch();
    final recipientRef = firestore.doc(
        '$challengesCollection/$recipientUid/$challengesCollection/${storageChallenge.id}');
    final challengerRef = firestore.doc(
        '$challengesCollection/$challengerUid/$challengesCollection/${storageChallenge.id}');

    batch.set(
      recipientRef,
      storageChallengeJson,
      SetOptions(merge: true),
    );
    batch.set(
      challengerRef,
      storageChallengeJson,
      SetOptions(merge: true),
    );

    return batch.commit().then((_) => true).catchError(
      (e, trace) {
        FirebaseCrashlytics.instance.recordError(
          e,
          trace,
          reason:
              '[FBChallengesDataWriter][setPuttingChallenge] firestore write exception',
        );
        return false;
      },
    );
  }

  Future<bool> sendChallengeToUser(String recipientUid, MyPuttUser currentUser,
      StoragePuttingChallenge storageChallenge) {
    final challengeRef = firestore.doc(
        '$challengesCollection/$recipientUid/$challengesCollection/${storageChallenge.id}');
    return challengeRef
        .set(storageChallenge.toJson())
        .then((value) => true)
        .catchError((e, trace) {
      FirebaseCrashlytics.instance.recordError(
        e,
        trace,
        reason:
            '[FBChallengesDataWriter][sendChallengeToUser] firestore write exception',
      );
      return false;
    });
  }

  Future<bool> uploadUnclaimedChallenge(
      StoragePuttingChallenge storageChallenge) {
    return firestore
        .collection(unclaimedChallengesCollection)
        .doc(storageChallenge.id)
        .set(storageChallenge.toJson())
        .then((value) => true)
        .catchError((e, trace) {
      FirebaseCrashlytics.instance.recordError(
        e,
        trace,
        reason:
            '[FBChallengesDataWriter][uploadUnclaimedChallenge] firestore write exception',
      );
      return false;
    });
  }

  Future<bool> deleteUnclaimedChallenge(String challengeId) async {
    return firestore
        .doc('$unclaimedChallengesCollection/$challengeId')
        .delete()
        .then((value) => true)
        .catchError(
      (e, trace) {
        FirebaseCrashlytics.instance.recordError(
          e,
          trace,
          reason:
              '[FBChallengesDataWriter][deleteUnclaimedChallenge] firestore delete exception',
        );
        return false;
      },
    );
  }

  Future<bool> deleteChallenge(
    String currentUid,
    PuttingChallenge challengeToDelete,
  ) {
    return firestore
        .doc(
            '$challengesCollection/$currentUid/$challengesCollection/${challengeToDelete.id}')
        .delete()
        .then((value) => true)
        .catchError(
      (e, trace) {
        FirebaseCrashlytics.instance.recordError(
          e,
          trace,
          reason:
              '[FBChallengesDataWriter][deleteChallenge] firestore delete exception',
        );
        return false;
      },
    );
  }

  Future<bool> deleteChallengesBatch(
    List<PuttingChallenge> challengesToDelete,
  ) async {
    return true;
    final String? uid = locator.get<FirebaseAuthService>().getCurrentUserId();

    if (uid == null) {
      return false;
    }

    final WriteBatch batch = firestore.batch();

    for (PuttingChallenge challenge in challengesToDelete) {
      batch.delete(
        firestore.doc(
          '$sessionsCollection/$uid/$completedSessionsCollection/${challenge.id}',
        ),
      );
    }

    return batch.commit().then((_) => true).catchError(
      (e, trace) {
        FirebaseCrashlytics.instance.recordError(
          e,
          trace,
          reason:
              '[FBChallengesDataWriter][deleteChallengesBatch] firestore delete exception',
        );
        return false;
      },
    );
  }
}
