import 'package:flutter/material.dart';

import 'package:myputt/locator.dart';
import 'package:myputt/models/data/challenges/challenge_structure_item.dart';
import 'package:myputt/models/data/challenges/putting_challenge.dart';
import 'package:myputt/models/data/challenges/storage_putting_challenge.dart';
import 'package:myputt/models/data/sessions/putting_set.dart';
import 'package:myputt/models/data/users/myputt_user.dart';
import 'package:myputt/repositories/presets_repository.dart';
import 'package:myputt/repositories/user_repository.dart';
import 'package:myputt/services/database_service.dart';
import 'package:myputt/utils/constants.dart';
import 'package:myputt/utils/enums.dart';

class ChallengesRepository extends ChangeNotifier {
  final DatabaseService databaseService = locator.get<DatabaseService>();
  final UserRepository userRepository = locator.get<UserRepository>();
  final PresetsRepository presetsRepository = locator.get<PresetsRepository>();

  PuttingChallenge? currentChallenge;
  PuttingChallenge? finishedChallenge;
  List<PuttingChallenge> pendingChallenges = [];
  List<PuttingChallenge> activeChallenges = [];
  List<PuttingChallenge> _completedChallenges = [];
  List<StoragePuttingChallenge> deepLinkChallenges = [];

  List<PuttingChallenge> get completedChallenges => _completedChallenges;

  set completedChallenges(List<PuttingChallenge> completedChallenges) {
    print('setting completed challenges');
    _completedChallenges = completedChallenges;
    notifyListeners();
  }

  Future<void> fetchAllChallenges() async {
    final List<PuttingChallenge>? allChallenges =
        await databaseService.getAllChallenges();

    if (allChallenges == null) {
      return;
    }

    final MyPuttUser? currentUser = userRepository.currentUser;
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

  Future<bool> sendChallengeWithPreset(
      ChallengePreset challengePreset, MyPuttUser recipientUser) async {
    final MyPuttUser? currentUser = userRepository.currentUser;
    if (currentUser == null) {
      return false;
    } else {
      final int timestamp = DateTime.now().millisecondsSinceEpoch;
      final List<ChallengeStructureItem> challengeStructure =
          presetsRepository.presetStructures[challengePreset]!;
      final storageChallenge = StoragePuttingChallenge(
          status: ChallengeStatus.active,
          creationTimeStamp: DateTime.now().millisecondsSinceEpoch,
          id: '${currentUser.uid}~$timestamp',
          challengerUser: currentUser,
          challengeStructure: challengeStructure,
          challengerSets: [],
          recipientSets: [],
          recipientUser: recipientUser);
      final PuttingChallenge newChallenge =
          PuttingChallenge.fromStorageChallenge(storageChallenge, currentUser);
      currentChallenge = newChallenge;
      activeChallenges.add(newChallenge);
      return databaseService.setStorageChallenge(storageChallenge);
    }
  }

  Future<void> addSet(PuttingSet set) async {
    final MyPuttUser? currentUser = userRepository.currentUser;
    if (currentChallenge != null && currentUser != null) {
      currentChallenge!.currentUserSets.add(set);
    }
  }

  Future<void> resyncCurrentChallenge() async {
    final MyPuttUser? currentUser = userRepository.currentUser;
    if (currentChallenge != null && currentUser != null) {
      final PuttingChallenge? updatedChallenge =
          await databaseService.getPuttingChallengeById(currentChallenge!.id);
      if (updatedChallenge != null) {
        currentChallenge!.opponentSets = updatedChallenge.opponentSets;
        if (currentChallenge?.recipientUser != null) {
          await databaseService.setStorageChallenge(
              StoragePuttingChallenge.fromPuttingChallenge(
                  currentChallenge!, currentUser));
        } else {
          await databaseService.setUnclaimedChallenge(
              StoragePuttingChallenge.fromPuttingChallenge(
                  currentChallenge!, currentUser));
        }
      }
    }
  }

  Future<void> deleteSet(PuttingSet set) async {
    final MyPuttUser? currentUser = userRepository.currentUser;
    if (currentChallenge != null && currentUser != null) {
      currentChallenge!.currentUserSets.remove(set);
      if (currentChallenge?.recipientUser != null) {
        databaseService.setStorageChallenge(
            StoragePuttingChallenge.fromPuttingChallenge(
                currentChallenge!, currentUser));
      } else {
        databaseService.setUnclaimedChallenge(
            StoragePuttingChallenge.fromPuttingChallenge(
                currentChallenge!, currentUser));
      }
    }
  }

  void openChallenge(PuttingChallenge challenge) {
    final MyPuttUser? currentUser = userRepository.currentUser;
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
      databaseService.setStorageChallenge(
        StoragePuttingChallenge.fromPuttingChallenge(
          currentChallenge!,
          currentUser,
        ),
      );
    }
  }

  void exitChallenge() {
    currentChallenge = null;
  }

  Future<bool> finishChallengeAndSync() async {
    final MyPuttUser? currentUser = userRepository.currentUser;
    if (currentChallenge == null || currentUser == null) {
      return false;
    } else {
      currentChallenge?.status = ChallengeStatus.complete;
      currentChallenge?.completionTimeStamp =
          DateTime.now().millisecondsSinceEpoch;
      completedChallenges.add(currentChallenge!);
      activeChallenges =
          removeChallengeFromList(currentChallenge!, activeChallenges);
      await databaseService.setStorageChallenge(
          StoragePuttingChallenge.fromPuttingChallenge(
              currentChallenge!, currentUser));
      currentChallenge = null;
      return true;
    }
  }

  Future<void> addFinishedChallenge(PuttingChallenge challenge) async {
    activeChallenges =
        removeChallengeFromList(currentChallenge!, activeChallenges);
    completedChallenges.add(challenge);
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
    databaseService.deleteChallenge(challenge);
  }

  void deleteFinishedChallenge() {
    finishedChallenge = null;
  }

  Future<void> addDeepLinkChallenges() async {
    final MyPuttUser? currentUser = userRepository.currentUser;
    if (currentUser != null) {
      for (var storageChallenge in deepLinkChallenges) {
        if (storageChallenge.challengerUser.uid != currentUser.uid) {
          final StoragePuttingChallenge? existingChallenge =
              await databaseService.getChallengeByUid(
                  currentUser.uid, storageChallenge.id);
          if (existingChallenge == null) {
            final PuttingChallenge challenge =
                PuttingChallenge.fromStorageChallenge(
                    storageChallenge, currentUser);
            challenge.status = ChallengeStatus.active;
            activeChallenges.add(challenge);
            await databaseService.setStorageChallenge(
                StoragePuttingChallenge.fromPuttingChallenge(
                    challenge, currentUser));
            await databaseService.removeUnclaimedChallenge(challenge.id);
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
