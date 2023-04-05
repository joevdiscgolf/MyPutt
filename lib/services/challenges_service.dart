import 'package:myputt/locator.dart';
import 'package:myputt/models/data/challenges/storage_putting_challenge.dart';
import 'package:myputt/models/data/users/myputt_user.dart';
import 'package:myputt/services/firebase/challenges_data_writer.dart';
import 'package:myputt/services/firebase_auth_service.dart';

class ChallengesService {
  Future<bool> setStorageChallenge(
    StoragePuttingChallenge storageChallenge,
  ) async {
    final String? currentUid =
        locator.get<FirebaseAuthService>().getCurrentUserId();
    if (currentUid == null) return false;
    final MyPuttUser? recipientUser = storageChallenge.recipientUser;
    final MyPuttUser? challengerUser = storageChallenge.challengerUser;
    if (recipientUser == null || challengerUser == null) {
      return false;
    }

    return FBChallengesDataWriter.instance.setPuttingChallenge(
      currentUid,
      recipientUser.uid,
      challengerUser.uid,
      storageChallenge,
    );
  }

  Future<bool> setUnclaimedChallenge(StoragePuttingChallenge storageChallenge) {
    return FBChallengesDataWriter.instance
        .uploadUnclaimedChallenge(storageChallenge);
  }
}
