import 'package:myputt/locator.dart';
import 'package:myputt/models/data/challenges/putting_challenge.dart';
import 'package:myputt/models/data/challenges/storage_putting_challenge.dart';
import 'package:myputt/models/data/users/myputt_user.dart';
import 'package:myputt/protocols/singleton_consumer.dart';
import 'package:myputt/repositories/user_repository.dart';
import 'package:myputt/services/firebase/challenges_data_loader.dart';
import 'package:myputt/services/firebase/challenges_data_writer.dart';
import 'package:myputt/services/firebase_auth_service.dart';
import 'package:myputt/utils/constants.dart';

class ChallengesService implements SingletonConsumer {
  @override
  void initSingletons() {
    _userRepository = locator.get<UserRepository>();
  }

  late final UserRepository _userRepository;

  Future<bool> setInitialStorageChallenge(
    StoragePuttingChallenge storageChallenge,
  ) async {
    final String? currentUid =
        locator.get<FirebaseAuthService>().getCurrentUserId();
    if (currentUid == null) return false;

    final MyPuttUser? recipientUser = storageChallenge.recipientUser;
    final MyPuttUser challengerUser = storageChallenge.challengerUser;
    if (recipientUser == null) {
      return false;
    }

    return FBChallengesDataWriter.instance.setStorageChallenge(
      currentUid,
      recipientUser.uid,
      challengerUser.uid,
      storageChallenge.toJson(),
      storageChallenge.id,
      timeout: tinyTimeout,
      merge: false,
    );
  }

  Future<bool> updateStorageChallenge(
    StoragePuttingChallenge storageChallenge,
  ) async {
    final String? currentUid =
        locator.get<FirebaseAuthService>().getCurrentUserId();
    if (currentUid == null) return false;

    final MyPuttUser? recipientUser = storageChallenge.recipientUser;
    final MyPuttUser challengerUser = storageChallenge.challengerUser;
    if (recipientUser == null) {
      return false;
    }

    final bool currentUserIsChallenger = currentUid == challengerUser.uid;

    final Map<String, dynamic> storageChallengeJson = storageChallenge.toJson();

    // if current user is challenger, do not mutate recipient sets.
    if (currentUserIsChallenger) {
      storageChallengeJson.remove('recipientSets');
    }
    // if current user is recipient, do not mutate challenger sets
    else {
      storageChallengeJson.remove('challengerSets');
    }

    return FBChallengesDataWriter.instance.setStorageChallenge(
      currentUid,
      recipientUser.uid,
      challengerUser.uid,
      storageChallengeJson,
      storageChallenge.id,
      merge: true,
    );
  }

  Future<PuttingChallenge?> getChallengeById(
    String challengeId,
    String currentUid,
  ) async {
    MyPuttUser? currentUser = _userRepository.currentUser;

    if (currentUser == null) {
      await _userRepository.fetchCloudCurrentUser(timeoutDuration: tinyTimeout);
      currentUser = _userRepository.currentUser;
    }

    if (currentUser == null) {
      // logger error
      return null;
    }

    return FBChallengesDataLoader.instance.getPuttingChallengeById(
      currentUser,
      challengeId,
    );
  }

  Future<bool> setUnclaimedChallenge(StoragePuttingChallenge storageChallenge) {
    return FBChallengesDataWriter.instance
        .uploadUnclaimedChallenge(storageChallenge);
  }

  Future<bool> deleteChallenge(PuttingChallenge challengeToDelete) async {
    final String? currentUid =
        locator.get<FirebaseAuthService>().getCurrentUserId();

    if (currentUid == null) return false;
    return FBChallengesDataWriter.instance.deleteChallenge(
      currentUid,
      challengeToDelete,
    );
  }
}
