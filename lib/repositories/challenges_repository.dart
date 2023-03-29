import 'dart:developer';

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
import 'package:myputt/services/firebase/challenges_data_writer.dart';
import 'package:myputt/services/firebase_auth_service.dart';
import 'package:myputt/services/localDB/local_db_service.dart';
import 'package:myputt/utils/challenge_helpers.dart';
import 'package:myputt/utils/constants.dart';
import 'package:myputt/utils/constants/flags.dart';
import 'package:myputt/utils/enums.dart';

class ChallengesRepository extends ChangeNotifier {
  final DatabaseService databaseService = locator.get<DatabaseService>();
  final UserRepository userRepository = locator.get<UserRepository>();
  final PresetsRepository presetsRepository = locator.get<PresetsRepository>();

  PuttingChallenge? currentChallenge;
  PuttingChallenge? finishedChallenge;
  List<PuttingChallenge> _completedChallenges = [];
  List<PuttingChallenge> _activeChallenges = [];
  List<PuttingChallenge> _incomingPendingChallenges = [];
  List<PuttingChallenge> _outgoingPendingChallenges = [];

  List<StoragePuttingChallenge> deepLinkChallenges = [];

  List<PuttingChallenge> get completedChallenges => _completedChallenges;
  List<PuttingChallenge> get activeChallenges => _activeChallenges;
  List<PuttingChallenge> get incomingPendingChallenges =>
      _incomingPendingChallenges;
  List<PuttingChallenge> get outgoingPendingChallenges =>
      _outgoingPendingChallenges;
  List<PuttingChallenge> get allChallenges => [
        ..._completedChallenges,
        ..._activeChallenges,
        ..._incomingPendingChallenges,
        ..._outgoingPendingChallenges,
      ];

  set completedChallenges(List<PuttingChallenge> completedChallenges) {
    _completedChallenges = completedChallenges;
    notifyListeners();
  }

  set activeChallenges(List<PuttingChallenge> activeChallenges) {
    _activeChallenges = activeChallenges;
    notifyListeners();
  }

  set incomingPendingChallenges(
    List<PuttingChallenge> incomingPendingChallenges,
  ) {
    _incomingPendingChallenges = incomingPendingChallenges;
    notifyListeners();
  }

  set outgoingPendingChallenges(
    List<PuttingChallenge> outgoingPendingChallenges,
  ) {
    _outgoingPendingChallenges = outgoingPendingChallenges;
    notifyListeners();
  }

  set allChallenges(List<PuttingChallenge> allChallenges) {
    final String? currentUid =
        locator.get<FirebaseAuthService>().getCurrentUserId();

    activeChallenges = allChallenges
        .where((challenge) => challenge.status == ChallengeStatus.active)
        .toList();
    completedChallenges = allChallenges
        .where((challenge) => challenge.status == ChallengeStatus.complete)
        .toList();
    incomingPendingChallenges = allChallenges
        .where((challenge) =>
            challenge.status == ChallengeStatus.pending &&
            currentUid != challenge.challengerUser.uid)
        .toList();
    outgoingPendingChallenges = allChallenges
        .where((challenge) =>
            challenge.status == ChallengeStatus.pending &&
            currentUid == challenge.challengerUser.uid)
        .toList();
  }

  void fetchLocalChallenges() {
    final List<PuttingChallenge>? localDbChallenges =
        locator.get<LocalDBService>().retrievePuttingChallenges();
    if (localDbChallenges != null) {
      allChallenges = localDbChallenges;
    }
    _log(
      '[ChallengesRepository][fetchLocalChallenges] Local challenges: ${localDbChallenges?.length}',
    );
  }

  Future<bool> fetchCloudChallenges() async {
    final List<PuttingChallenge> unsyncedChallenges =
        allChallenges.where((challenge) => challenge.isSynced != true).toList();

    List<PuttingChallenge>? cloudChallenges =
        await databaseService.getAllChallenges();

    _log(
      '[ChallengesRepository][fetchCloudChallenges] cloud challenges count: ${cloudChallenges?.length}',
    );

    if (cloudChallenges == null) {
      return false;
    }

    final String? currentUid =
        locator.get<FirebaseAuthService>().getCurrentUserId();

    // incomingPendingChallenges = cloudChallenges
    //     .where((challenge) =>
    //         challenge.status == ChallengeStatus.pending &&
    //         currentUid != challenge.challengerUser.uid)
    //     .toList();
    // activeChallenges = cloudChallenges
    //     .where((challenge) => challenge.status == ChallengeStatus.active)
    //     .toList();
    // completedChallenges = cloudChallenges
    //     .where((challenge) => challenge.status == ChallengeStatus.complete)
    //     .toList();

    cloudChallenges = ChallengeHelpers.setSyncedToTrue(cloudChallenges);

    List<PuttingChallenge> combinedChallenges =
        ChallengeHelpers.mergeCloudChallenges(
      unsyncedChallenges,
      cloudChallenges,
    );

    List<PuttingChallenge> updatedActiveChallenges =
        ChallengeHelpers.updatedActiveChallenges(
      allChallenges,
      cloudChallenges,
    );

    // store new challenges if necessary.
    final List<PuttingChallenge> newChallenges =
        ChallengeHelpers.getNewChallenges(allChallenges, cloudChallenges);

    // challenges deleted locally that still exist in the cloud
    final List<PuttingChallenge> challengesDeletedLocally =
        ChallengeHelpers.getChallengesDeletedLocally(
      allChallenges,
      cloudChallenges,
    );

    // challenges deleted in the cloud that still exist locally
    final List<PuttingChallenge> challengesDeletedInCloud =
        ChallengeHelpers.getChallengesDeletedInCloud(
      allChallenges,
      cloudChallenges,
    );

    // remove challenges that were deleted in the cloud
    combinedChallenges = ChallengeHelpers.removeChallenges(
      challengesDeletedInCloud,
      combinedChallenges,
    );

    // update local challenges if there are new challenges or challenges have been removed
    if (newChallenges.isNotEmpty || challengesDeletedInCloud.isNotEmpty) {
      final bool success = await locator
          .get<LocalDBService>()
          .storeChallenges(combinedChallenges);
      if (!success) {
        _log(
            '[ChallengesRepository][fetchCloudChallenges] Failed to save new cloud challenges in local DB');
      }
    }

    allChallenges = combinedChallenges;

    if (challengesDeletedLocally.isNotEmpty) {
      final bool deleteSuccess = await FBChallengesDataWriter.instance
          .deleteChallengesBatch(challengesDeletedLocally);
      _log(
          '[ChallengesRepository][fetchCloudChallenges] delete challenges batch - success: $deleteSuccess');

      // remove local deleted challenges permanently if successfully deleted in cloud
      if (deleteSuccess) {
        allChallenges = ChallengeHelpers.removeChallenges(
          challengesDeletedLocally,
          allChallenges,
        );
        final bool localSaveSuccess = await _storeChallengesInLocalDB();
        _log(
            '[ChallengesRepository][fetchCloudChallenges] saved current challenges locally - success: $localSaveSuccess');
      }
    }
    if (challengesDeletedInCloud.isNotEmpty) {
      _log(
        '[ChallengesRepository][fetchCloudChallenges] deleting challenges locally that were deleted in cloud',
      );
      allChallenges = ChallengeHelpers.removeChallenges(
        challengesDeletedInCloud,
        allChallenges,
      );
    }

    final bool localSaveSuccess = await _storeChallengesInLocalDB();
    _log(
      '[ChallengesRepository][fetchCloudChallenges] saved current challenges locally - success: $localSaveSuccess',
    );

    return true;
  }

  void clearData() {
    currentChallenge = null;
    allChallenges = [];
    locator.get<LocalDBService>().deleteChallengesData();
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
    if (incomingPendingChallenges.contains(challenge)) {
      incomingPendingChallenges.remove(challenge);
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
    if (incomingPendingChallenges.contains(challenge)) {
      incomingPendingChallenges.remove(challenge);
      // database event here
    } else if (activeChallenges.contains(challenge)) {
      activeChallenges =
          removeChallengeFromList(currentChallenge!, activeChallenges);
      // database event here
    }
  }

  void declineChallenge(PuttingChallenge challenge) {
    incomingPendingChallenges.remove(challenge);
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
            currentUser.uid,
            storageChallenge.id,
          );
          if (existingChallenge == null) {
            final PuttingChallenge challenge =
                PuttingChallenge.fromStorageChallenge(
              storageChallenge,
              currentUser,
            );
            challenge.status = ChallengeStatus.active;
            activeChallenges.add(challenge);
            await databaseService.setStorageChallenge(
              StoragePuttingChallenge.fromPuttingChallenge(
                challenge,
                currentUser,
              ),
            );
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

  Future<bool> _storeChallengesInLocalDB() {
    _log(
        '[ChallengesRepository][_storeChallengesInLocalDB] storing ${allChallenges.length} challenges in local db');
    return locator
        .get<LocalDBService>()
        .storeChallenges(allChallenges)
        .then((success) {
      _log(
          '[ChallengesRepository][_storeChallengesInLocalDB] success: $success');
      return success;
    });
  }

  void _log(String message) {
    if (Flags.kChallengesRepositoryLogs) {
      log(message);
    }
  }
}
