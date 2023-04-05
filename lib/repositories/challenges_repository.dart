import 'dart:developer';

import 'package:flutter/material.dart';

import 'package:myputt/locator.dart';
import 'package:myputt/models/data/challenges/putting_challenge.dart';
import 'package:myputt/models/data/challenges/storage_putting_challenge.dart';
import 'package:myputt/models/data/sessions/putting_set.dart';
import 'package:myputt/models/data/users/myputt_user.dart';
import 'package:myputt/protocols/singleton_consumer.dart';
import 'package:myputt/repositories/presets_repository.dart';
import 'package:myputt/protocols/repository.dart';
import 'package:myputt/repositories/user_repository.dart';
import 'package:myputt/services/challenges_service.dart';
import 'package:myputt/services/database_service.dart';
import 'package:myputt/services/firebase/challenges_data_writer.dart';
import 'package:myputt/services/firebase_auth_service.dart';
import 'package:myputt/services/localDB/local_db_service.dart';
import 'package:myputt/utils/challenge_helpers.dart';
import 'package:myputt/utils/constants.dart';
import 'package:myputt/utils/constants/flags.dart';
import 'package:myputt/utils/enums.dart';

class ChallengesRepository extends ChangeNotifier
    implements SingletonConsumer, MyPuttRepository {
  late final ChallengesService _challengesService;
  late final FirebaseAuthService _authService;

  @override
  void initSingletons() {
    _challengesService = locator.get<ChallengesService>();
    _authService = locator.get<FirebaseAuthService>();
  }

  @override
  void clearData() {
    currentChallenge = null;
    allChallenges = [];
    locator.get<LocalDBService>().deleteChallengesData();
  }

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
    notifyListeners();
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
      _log(
        '[ChallengesRepository][fetchCloudChallenges] failed to fetch cloud challenges',
      );
      return false;
    }

    // set synced to true for all cloud challenges if they're not already.
    cloudChallenges = ChallengeHelpers.setSyncedToTrue(cloudChallenges);

    // new challenges in cloud but not local.
    final List<PuttingChallenge> newCloudChallenges =
        ChallengeHelpers.getNewCloudChallenges(allChallenges, cloudChallenges);

    // challenges deleted locally but not in cloud
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

    // use local challenge if synced != true else use cloud challenge
    List<PuttingChallenge> mergedChallenges =
        ChallengeHelpers.mergeCloudChallenges(
      unsyncedChallenges,
      cloudChallenges,
    );

    // remove challenges that were deleted in the cloud
    // "new cloud challenges" do not need to be explicitly added, because they are added by default in ChallengeHelpers.mergeCloudChallenges()
    mergedChallenges = ChallengeHelpers.removeChallenges(
      challengesDeletedInCloud,
      mergedChallenges,
    );

    // merge active challenges using timestamps to determine SOT
    List<PuttingChallenge> updatedActiveChallenges =
        ChallengeHelpers.updatedActiveChallenges(
      allChallenges,
      cloudChallenges,
    );

    // SOT == source of truth
    allChallenges = ChallengeHelpers.mergeSOTChallenges(
      sotChallenges: updatedActiveChallenges,
      allChallenges: mergedChallenges,
    );

    // update local challenges if there are new challenges or challenges have been removed
    if (newCloudChallenges.isNotEmpty || challengesDeletedInCloud.isNotEmpty) {
      final bool localSaveSuccess = await _storeChallengesInLocalDB();
      _log(
        '[ChallengesRepository][fetchCloudChallenges] saved current challenges locally - success: $localSaveSuccess',
      );
      if (!localSaveSuccess) {
        _log(
          '[ChallengesRepository][fetchCloudChallenges] Failed to save new cloud challenges in local DB',
        );
      }
    }

    // challenges deleted locally must be deleted in the cloud then removed from local storage.
    if (challengesDeletedLocally.isNotEmpty) {
      final bool cloudDeleteSuccess = await FBChallengesDataWriter.instance
          .deleteChallengesBatch(challengesDeletedLocally);
      _log(
        '[ChallengesRepository][fetchCloudChallenges] delete challenges batch in cloud - success: $cloudDeleteSuccess',
      );

      // remove local deleted challenges permanently if successfully deleted in cloud
      if (cloudDeleteSuccess) {
        allChallenges = ChallengeHelpers.removeChallenges(
          challengesDeletedLocally,
          allChallenges,
        );
        final bool localSaveSuccess = await _storeChallengesInLocalDB();
        _log(
          '[ChallengesRepository][fetchCloudChallenges] removed challenges locally - success: $localSaveSuccess',
        );
      }
    }

    return true;
  }

  Future<bool> sendChallengeWithPreset(
    ChallengePreset challengePreset,
    MyPuttUser recipientUser,
  ) async {
    final MyPuttUser? currentUser = locator.get<UserRepository>().currentUser;
    if (currentUser == null) return false;

    final PuttingChallenge? challengeFromPreset =
        ChallengeHelpers.getChallengeFromPreset(
      challengePreset,
      currentUser,
      recipientUser,
    );

    if (challengeFromPreset == null) {
      _log(
        '[ChallengesRepository][sendChallengeWithPreset] Failed to generate challenge from preset',
      );
      return false;
    }

    currentChallenge = challengeFromPreset;
    activeChallenges.add(challengeFromPreset);

    return _challengesService.setStorageChallenge(
      StoragePuttingChallenge.fromPuttingChallenge(
        challengeFromPreset,
        currentUser.uid,
      ),
    );
  }

  Future<void> addSet(PuttingSet set) async {
    currentChallenge?.currentUserSets.add(set);

    onSetsChanged();
  }

  Future<void> deleteSet(PuttingSet set) async {
    currentChallenge?.currentUserSets.remove(set);
    onSetsChanged();
  }

  Future<void> onSetsChanged() async {
    currentChallenge = currentChallenge?.copyWith(
      currentUserSetsUpdatedAt: DateTime.now().toIso8601String(),
    );

    final String? currentUid = _authService.getCurrentUserId();
    if (currentUid == null) {
      // toast error
      return;
    }

    // active challenge
    if (currentChallenge?.recipientUser != null) {
      _challengesService.setStorageChallenge(
        StoragePuttingChallenge.fromPuttingChallenge(
          currentChallenge!,
          currentUid,
        ),
      );
    }
    // outgoing pending challenge
    else {
      _challengesService.setUnclaimedChallenge(
        StoragePuttingChallenge.fromPuttingChallenge(
          currentChallenge!,
          currentUid,
        ),
      );
    }
    _storeChallengesInLocalDB();
    notifyListeners();
  }

  Future<void> resyncCurrentChallenge() async {
    if (currentChallenge == null) return;

    final String? currentUid = _authService.getCurrentUserId();
    if (currentUid == null) return;

    final PuttingChallenge? updatedChallenge =
        await databaseService.getPuttingChallengeById(currentChallenge!.id);
    if (updatedChallenge == null) return;

    currentChallenge =
        currentChallenge?.copyWith(opponentSets: updatedChallenge.opponentSets);

    if (currentChallenge?.recipientUser != null) {
      await _challengesService.setStorageChallenge(
        StoragePuttingChallenge.fromPuttingChallenge(
          currentChallenge!,
          currentUid,
        ),
      );
    } else {
      await databaseService.setUnclaimedChallenge(
        StoragePuttingChallenge.fromPuttingChallenge(
          currentChallenge!,
          currentUid,
        ),
      );
    }
  }

  void openChallenge(PuttingChallenge challenge) {
    final String? currentUid = _authService.getCurrentUserId();
    if (currentUid == null) {
      // toast error
      return;
    }

    if (challenge.status == ChallengeStatus.pending) {
      currentChallenge = challenge.copyWith(status: ChallengeStatus.active);
    } else {
      currentChallenge = challenge;
    }

    // move to from pending to active if necessary
    if (incomingPendingChallenges.contains(challenge)) {
      incomingPendingChallenges.remove(challenge);
      activeChallenges.add(challenge);
      _challengesService.setStorageChallenge(
        StoragePuttingChallenge.fromPuttingChallenge(
          currentChallenge!,
          currentUid,
        ),
      );
      _storeChallengesInLocalDB();
    }
  }

  void exitChallenge() {
    currentChallenge = null;
  }

  Future<bool> finishChallengeAndSync() async {
    final String? currentUid = _authService.getCurrentUserId();
    if (currentUid == null) {
      // toast error
      return false;
    } else if (currentChallenge == null) {
      return false;
    } else {
      currentChallenge = currentChallenge?.copyWith(
        status: ChallengeStatus.complete,
        completionTimeStamp: DateTime.now().millisecondsSinceEpoch,
      );

      completedChallenges.add(currentChallenge!);
      activeChallenges = ChallengeHelpers.removeChallenges(
        [currentChallenge!],
        activeChallenges,
      );
      await _challengesService.setStorageChallenge(
        StoragePuttingChallenge.fromPuttingChallenge(
          currentChallenge!,
          currentUid,
        ),
      );
      currentChallenge = null;
      return true;
    }
  }

  Future<void> addFinishedChallenge(PuttingChallenge challenge) async {
    activeChallenges = ChallengeHelpers.removeChallenges(
      [currentChallenge!],
      activeChallenges,
    );
    completedChallenges.add(challenge);
    finishedChallenge = challenge;
    currentChallenge = null;
  }

  void deleteChallenge(PuttingChallenge challenge) {
    if (incomingPendingChallenges.contains(challenge)) {
      incomingPendingChallenges.remove(challenge);
      // database event here
    } else if (activeChallenges.contains(challenge)) {
      activeChallenges = ChallengeHelpers.removeChallenges(
        [currentChallenge!],
        activeChallenges,
      );
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
            ).copyWith(status: ChallengeStatus.active);

            activeChallenges.add(challenge);
            await _challengesService.setStorageChallenge(
              StoragePuttingChallenge.fromPuttingChallenge(
                challenge,
                currentUser.uid,
              ),
            );
            await databaseService.removeUnclaimedChallenge(challenge.id);
          }
        }
      }
      deepLinkChallenges = [];
    }
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
