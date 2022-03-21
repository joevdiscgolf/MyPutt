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
  PuttingChallenge? finishedChallenge;
  List<PuttingChallenge> pendingChallenges = [];
  List<PuttingChallenge> activeChallenges = [];
  List<PuttingChallenge> completedChallenges = [];
  List<StoragePuttingChallenge> deepLinkChallenges = [];

  Future<void> fetchAllChallenges() async {
    final List<PuttingChallenge> allChallenges =
        await _databaseService.getAllChallenges();
    final MyPuttUser? currentUser = _userRepository.currentUser;
    pendingChallenges = allChallenges
        .where((challenge) =>
            challenge.status == ChallengeStatus.pending &&
            currentUser?.uid != challenge.challengerUser.uid)
        .toList();
    activeChallenges = allChallenges
        .where((challenge) => challenge.status == ChallengeStatus.active)
        .toList();
    completedChallenges = allChallenges
        .where((challenge) => challenge.status == ChallengeStatus.complete)
        .toList();
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

  void exitChallenge() {
    currentChallenge = null;
  }

  Future<bool> finishChallengeAndSync() async {
    final MyPuttUser? currentUser = _userRepository.currentUser;
    if (currentChallenge == null || currentUser == null) {
      return false;
    } else {
      currentChallenge?.status = ChallengeStatus.complete;
      currentChallenge?.completionTimeStamp =
          DateTime.now().millisecondsSinceEpoch;
      completedChallenges.add(currentChallenge!);
      activeChallenges =
          removeChallengeFromList(currentChallenge!, activeChallenges);
      await _databaseService.setStorageChallenge(
          StoragePuttingChallenge.fromPuttingChallenge(
              currentChallenge!, currentUser));
      currentChallenge = null;
      return true;
    }
  }

  Future<void> addFinishedChallenge(PuttingChallenge challenge) async {
    activeChallenges =
        removeChallengeFromList(currentChallenge!, activeChallenges);
    print(completedChallenges.length);
    completedChallenges.add(challenge);
    print(completedChallenges.length);
    finishedChallenge = challenge;
    currentChallenge = null;
  }

  void deleteChallenge(PuttingChallenge challenge) {
    if (pendingChallenges.contains(challenge)) {
      pendingChallenges.remove(challenge);
      // database event here
    } else if (activeChallenges.contains(challenge)) {
      activeChallenges =
          removeChallengeFromList(currentChallenge!, activeChallenges);
      // database event here
    }
  }

  void declineChallenge(PuttingChallenge challenge) {
    pendingChallenges.remove(challenge);
    _databaseService.deleteChallenge(challenge);
  }

  void deleteFinishedChallenge() {
    finishedChallenge = null;
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

  List<PuttingChallenge> removeChallengeFromList(
      PuttingChallenge challengeToRemove, List<PuttingChallenge> listToFilter) {
    return listToFilter
        .where((challenge) => challengeToRemove.id != challenge.id)
        .toList();
  }
}
