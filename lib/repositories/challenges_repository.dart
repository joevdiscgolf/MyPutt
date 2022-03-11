import 'package:myputt/data/types/challenges/storage_putting_challenge.dart';
import 'package:myputt/data/types/users/myputt_user.dart';
import 'package:myputt/data/types/challenges/putting_challenge.dart';
import 'package:myputt/repositories/user_repository.dart';
import 'package:myputt/services/database_service.dart';
import 'package:myputt/data/types/putting_set.dart';
import 'package:myputt/locator.dart';
import 'package:myputt/utils/constants.dart';

class ChallengesRepository {
  final DatabaseService _databaseService = locator.get<DatabaseService>();
  final UserRepository _userRepository = locator.get<UserRepository>();

  PuttingChallenge? currentChallenge;
  List<PuttingChallenge> pendingChallenges = [];
  List<PuttingChallenge> activeChallenges = [];
  List<PuttingChallenge> completedChallenges = [];
  List<StoragePuttingChallenge> deepLinkChallenges = [];

  Future<void> fetchAllChallenges() async {
    final List<dynamic> result = await Future.wait([
      _databaseService.getChallengesWithStatus(ChallengeStatus.pending),
      _databaseService.getChallengesWithStatus(ChallengeStatus.active),
      _databaseService.getChallengesWithStatus(ChallengeStatus.complete),
    ]);

    if (result[0] != null && result[0] is List<PuttingChallenge>) {
      pendingChallenges = result[0] as List<PuttingChallenge>;
    }
    if (result[1] != null && result[1] is List<PuttingChallenge>) {
      activeChallenges = result[1] as List<PuttingChallenge>;
    }
    if (result[2] != null && result[2] is List<PuttingChallenge>) {
      completedChallenges = result[2] as List<PuttingChallenge>;
    }
  }

  void clearData() {
    currentChallenge = null;
    pendingChallenges = [];
    activeChallenges = [];
    completedChallenges = [];
  }

  Future<void> addSet(PuttingSet set) async {
    final MyPuttUser? currentUser = _userRepository.currentUser;
    if (currentChallenge != null && currentUser != null) {
      currentChallenge!.currentUserSets.add(set);
    }
  }

  Future<void> resyncCurrentChallenge() async {
    final MyPuttUser? currentUser = _userRepository.currentUser;
    if (currentChallenge != null && currentUser != null) {
      final PuttingChallenge? updatedChallenge =
          await _databaseService.getPuttingChallengeById(currentChallenge!.id);
      if (updatedChallenge != null) {
        currentChallenge!.opponentSets = updatedChallenge.opponentSets;
        if (currentChallenge?.recipientUser != null) {
          await _databaseService.setStorageChallenge(
              StoragePuttingChallenge.fromPuttingChallenge(
                  currentChallenge!, currentUser));
        } else {
          await _databaseService.setUnclaimedChallenge(
              StoragePuttingChallenge.fromPuttingChallenge(
                  currentChallenge!, currentUser));
        }
      }
    }
  }

  Future<void> deleteSet(PuttingSet set) async {
    final MyPuttUser? currentUser = _userRepository.currentUser;
    if (currentChallenge != null && currentUser != null) {
      currentChallenge!.currentUserSets.remove(set);
      if (currentChallenge?.recipientUser != null) {
        _databaseService.setStorageChallenge(
            StoragePuttingChallenge.fromPuttingChallenge(
                currentChallenge!, currentUser));
      } else {
        _databaseService.setUnclaimedChallenge(
            StoragePuttingChallenge.fromPuttingChallenge(
                currentChallenge!, currentUser));
      }
    }
  }

  void openChallenge(PuttingChallenge challenge) {
    final MyPuttUser? currentUser = _userRepository.currentUser;
    if (currentUser == null) {
      return;
    }
    currentChallenge = challenge;
    if (currentChallenge?.status == ChallengeStatus.pending) {
      currentChallenge?.status = ChallengeStatus.active;
    }
    if (pendingChallenges.contains(challenge)) {
      pendingChallenges.remove(challenge);
      activeChallenges.add(currentChallenge!);
      _databaseService.setStorageChallenge(
          StoragePuttingChallenge.fromPuttingChallenge(
              currentChallenge!, currentUser));
    }
  }

  Future<bool> completeChallenge() async {
    final MyPuttUser? currentUser = _userRepository.currentUser;
    if (currentChallenge == null || currentUser == null) {
      return false;
    } else {
      currentChallenge?.status = ChallengeStatus.complete;
      currentChallenge?.completionTimeStamp =
          DateTime.now().millisecondsSinceEpoch;
      if (activeChallenges.contains(currentChallenge)) {
        completedChallenges.add(currentChallenge!);
        activeChallenges.remove(currentChallenge);
      }

      await _databaseService.setStorageChallenge(
          StoragePuttingChallenge.fromPuttingChallenge(
              currentChallenge!, currentUser));
      currentChallenge = null;
      return true;
    }
  }

  void deleteChallenge(PuttingChallenge challenge) {
    if (pendingChallenges.contains(challenge)) {
      pendingChallenges.remove(challenge);
      // database event here
    } else if (activeChallenges.contains(challenge)) {
      activeChallenges.remove(challenge);
      // database event here
    }
  }

  void declineChallenge(PuttingChallenge challenge) {
    pendingChallenges.remove(challenge);
    _databaseService.deleteChallenge(challenge);
  }

  Future<void> addDeepLinkChallenges() async {
    final MyPuttUser? currentUser = _userRepository.currentUser;
    if (currentUser != null) {
      for (var storageChallenge in deepLinkChallenges) {
        if (storageChallenge.challengerUser.uid != currentUser.uid) {
          final StoragePuttingChallenge? existingChallenge =
              await _databaseService.getChallengeByUid(
                  currentUser.uid, storageChallenge.id);
          if (existingChallenge == null) {
            final PuttingChallenge challenge =
                PuttingChallenge.fromStorageChallenge(
                    storageChallenge, currentUser);
            challenge.status = ChallengeStatus.active;
            activeChallenges.add(challenge);
            await _databaseService.setStorageChallenge(
                StoragePuttingChallenge.fromPuttingChallenge(
                    challenge, currentUser));
            await _databaseService.removeUnclaimedChallenge(challenge.id);
          }
        }
      }
      deepLinkChallenges = [];
    }
  }
}
