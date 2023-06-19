import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:myputt/locator.dart';
import 'package:myputt/models/data/users/myputt_user.dart';
import 'package:myputt/models/data/challenges/putting_challenge.dart';
import 'package:myputt/services/firebase/utils/fb_constants.dart';
import 'package:myputt/models/data/challenges/storage_putting_challenge.dart';
import 'package:myputt/services/firebase_auth_service.dart';
import 'package:myputt/utils/constants.dart';

final FirebaseFirestore firestore = FirebaseFirestore.instance;

class FBChallengesDataWriter {
  static final FBChallengesDataWriter instance =
      FBChallengesDataWriter._internal();

  factory FBChallengesDataWriter() {
    return instance;
  }

  FBChallengesDataWriter._internal();

  Future<bool> setStorageChallenge(
    String currentUid,
    String recipientUid,
    String challengerUid,
    Map<String, dynamic> storageChallengeJson,
    String challengeId, {
    final Duration timeout = shortTimeout,
    final bool merge = false,
  }) async {
    WriteBatch batch = FirebaseFirestore.instance.batch();
    final recipientRef = firestore.doc(
        '$challengesCollection/$recipientUid/$challengesCollection/$challengeId');
    final challengerRef = firestore.doc(
        '$challengesCollection/$challengerUid/$challengesCollection/$challengeId');

    batch.set(
      recipientRef,
      storageChallengeJson,
      SetOptions(merge: merge),
    );
    batch.set(
      challengerRef,
      storageChallengeJson,
      SetOptions(merge: merge),
    );

    return batch.commit().then((_) => true).timeout(timeout, onTimeout: () {
      return false;
    }).catchError(
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
    final WriteBatch batch = firestore.batch();

    if (challengeToDelete.recipientUser != null) {
      batch.delete(
        firestore.doc(
            '$challengesCollection/${challengeToDelete.recipientUser!.uid}/$challengesCollection/${challengeToDelete.id}'),
      );
    }

    batch.delete(
      firestore.doc(
          '$challengesCollection/${challengeToDelete.challengerUser.uid}/$challengesCollection/${challengeToDelete.id}'),
    );

    return batch.commit().then((value) => true).catchError(
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

  Future<bool> setChallengesBatch(
    List<PuttingChallenge> challenges,
  ) async {
    final String? currentUid =
        locator.get<FirebaseAuthService>().getCurrentUserId();

    if (currentUid == null) {
      return false;
    }

    WriteBatch batch = FirebaseFirestore.instance.batch();

    for (PuttingChallenge challenge in challenges) {
      batch.set(
        firestore.doc(
            '$challengesCollection/${challenge.currentUser.uid}/$challengesCollection/${challenge.id}'),
        StoragePuttingChallenge.fromPuttingChallenge(challenge, currentUid)
            .toJson(),
      );

      if (challenge.recipientUser != null) {
        batch.set(
          firestore.doc(
              '$challengesCollection/${challenge.recipientUser!.uid}/$challengesCollection/${challenge.id}'),
          StoragePuttingChallenge.fromPuttingChallenge(challenge, currentUid)
              .toJson(),
        );
      }
    }

    return batch.commit().then((_) => true).catchError(
      (e, trace) {
        FirebaseCrashlytics.instance.recordError(
          e,
          trace,
          reason:
              '[FBChallengesDataWriter][setChallengesBatch] firestore write exception',
        );
        return false;
      },
    );
  }

  Future<bool> deleteChallengesBatch(
    List<PuttingChallenge> challengesToDelete,
  ) async {
    final String? uid = locator.get<FirebaseAuthService>().getCurrentUserId();

    if (uid == null) return false;

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
