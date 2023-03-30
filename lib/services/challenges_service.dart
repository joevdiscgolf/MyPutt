import 'package:myputt/models/data/challenges/storage_putting_challenge.dart';
import 'package:myputt/models/data/users/myputt_user.dart';
import 'package:myputt/services/firebase/challenges_data_writer.dart';

class ChallengesService {
  Future<bool> setStorageChallenge(
    StoragePuttingChallenge storageChallenge,
  ) async {
    final MyPuttUser? recipientUser = storageChallenge.recipientUser;
    final MyPuttUser? challengerUser = storageChallenge.challengerUser;
    if (recipientUser == null || challengerUser == null) {
      return false;
    }

    return FBChallengesDataWriter.instance.setPuttingChallenge(
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
