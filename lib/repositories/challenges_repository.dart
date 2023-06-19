import 'dart:async';
import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:myputt/cubits/challenges/challenge_cubit_helper.dart';
import 'package:myputt/cubits/challenges/challenges_cubit.dart';
import 'package:myputt/locator.dart';
import 'package:myputt/models/data/challenges/putting_challenge.dart';
import 'package:myputt/models/data/challenges/storage_putting_challenge.dart';
import 'package:myputt/models/data/sessions/putting_set.dart';
import 'package:myputt/models/data/users/myputt_user.dart';
import 'package:myputt/protocols/myputt_repository.dart';
import 'package:myputt/repositories/user_repository.dart';
import 'package:myputt/services/challenges_service.dart';
import 'package:myputt/services/database_service.dart';
import 'package:myputt/services/firebase/challenges_data_writer.dart';
import 'package:myputt/services/firebase/utils/fb_constants.dart';
import 'package:myputt/services/firebase_auth_service.dart';
import 'package:myputt/services/localDB/local_db_service.dart';
import 'package:myputt/utils/challenge_helpers.dart';
import 'package:myputt/utils/constants.dart';
import 'package:myputt/utils/constants/flags.dart';
import 'package:myputt/utils/set_helpers.dart';

class ChallengesRepository extends ChangeNotifier implements MyPuttRepository {
  @override
  void initSingletons() {
    _databaseService = locator.get<DatabaseService>();
    _userRepository = locator.get<UserRepository>();
    _localDBService = locator.get<LocalDBService>();
    _challengesService = locator.get<ChallengesService>();
    _authService = locator.get<FirebaseAuthService>();
    _challengesCubitHelper = locator.get<ChallengesCubitHelper>();
  }

  @override
  void clearData() {
    currentChallenge = null;
    allChallenges = [];
    _localDBService.deleteChallengesData();
  }

  late final DatabaseService _databaseService;
  late final UserRepository _userRepository;
  late final LocalDBService _localDBService;
  late final ChallengesService _challengesService;
  late final FirebaseAuthService _authService;
  late final ChallengesCubitHelper _challengesCubitHelper;

  StreamSubscription<DocumentSnapshot<Map<String, dynamic>>>?
      _currentChallengeSubscription;

  PuttingChallenge? _currentChallenge;
  List<PuttingChallenge> _completedChallenges = [];
  List<PuttingChallenge> _activeChallenges = [];
  List<PuttingChallenge> _incomingPendingChallenges = [];
  List<PuttingChallenge> _outgoingPendingChallenges = [];

  List<StoragePuttingChallenge> deepLinkChallenges = [];

  PuttingChallenge? get currentChallenge => _currentChallenge;
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

  set currentChallenge(PuttingChallenge? currentChallenge) {
    _currentChallenge = currentChallenge;
    if (currentChallenge != null) {
      int? matchingIndex;
      for (int index = 0; index < activeChallenges.length; index++) {
        final PuttingChallenge activeChallenge = activeChallenges[index];
        if (activeChallenge.id == currentChallenge.id) {
          matchingIndex = index;
        }
      }
      if (matchingIndex != null) {
        _activeChallenges[matchingIndex] = currentChallenge;
      }
    }
    notifyListeners();
  }

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
    final String? currentUid = _authService.getCurrentUserId();

    _activeChallenges = allChallenges
        .where((challenge) => challenge.status == ChallengeStatus.active)
        .toList();
    _completedChallenges = allChallenges
        .where((challenge) => challenge.status == ChallengeStatus.complete)
        .toList();
    _incomingPendingChallenges = allChallenges
        .where((challenge) =>
            challenge.status == ChallengeStatus.pending &&
            currentUid != challenge.challengerUser.uid)
        .toList();
    _outgoingPendingChallenges = allChallenges
        .where((challenge) =>
            challenge.status == ChallengeStatus.pending &&
            currentUid == challenge.challengerUser.uid)
        .toList();
    notifyListeners();
  }

  void _addToAllChallenges(PuttingChallenge challenge) {
    allChallenges = ChallengeHelpers.addChallenges([challenge], allChallenges);
  }

  void _listenToCurrentChallenge(PuttingChallenge challenge) {
    _currentChallengeSubscription = FirebaseFirestore.instance
        .doc(
          '$challengesCollection/${challenge.currentUser.uid}/$challengesCollection/${challenge.id}',
        )
        .snapshots()
        .listen((snapshot) {
      if (snapshot.data() == null || currentChallenge == null) {
        return;
      }

      try {
        final PuttingChallenge cloudUpdatedChallenge =
            PuttingChallenge.fromStorageChallenge(
          StoragePuttingChallenge.fromJson(
            snapshot.data() as Map<String, dynamic>,
          ),
          challenge.currentUser,
        );

        currentChallenge = ChallengeHelpers.mergeCurrentChallengeWithCloudCopy(
          currentChallenge!,
          cloudUpdatedChallenge,
        );
      } catch (e, trace) {
        _log(
            '[listenToCurrentChallenge] exception when parsing putting challenge: $e');
        _log(trace.toString());
      }
    });
  }

  void fetchLocalChallenges() {
    final List<PuttingChallenge>? localDbChallenges =
        _localDBService.retrievePuttingChallenges();
    if (localDbChallenges != null) {
      allChallenges = localDbChallenges;
    }
    _log(
      '[fetchLocalChallenges] Local challenges: ${localDbChallenges?.length}',
    );
  }

  Future<void> syncLocalChallengesToCloud() async {
    // do not sync deleted challenges to cloud
    List<PuttingChallenge> newlySyncedChallenges = allChallenges
        .where((challenge) =>
            challenge.isSynced != true && challenge.isDeleted != true)
        .toList();

    if (newlySyncedChallenges.isEmpty) {
      _log('[syncLocalChallengesToCloud] No newly synced challenges');
      return;
    }

    newlySyncedChallenges =
        ChallengeHelpers.setSyncedToTrue(newlySyncedChallenges);

    // save unsynced challenges in firestore.
    final bool saveSuccess = await FBChallengesDataWriter.instance
        .setChallengesBatch(newlySyncedChallenges);

    if (!saveSuccess) {
      // error
      return;
    }

    allChallenges = ChallengeHelpers.mergeSOTChallenges(
      sotChallenges: newlySyncedChallenges,
      allChallenges: allChallenges,
    );

    // store newly synced challenges
    await _storeChallengesInLocalDB();
  }

  Future<bool> fetchCloudChallenges() async {
    final List<PuttingChallenge> unsyncedChallenges =
        allChallenges.where((challenge) => challenge.isSynced != true).toList();

    List<PuttingChallenge>? cloudChallenges =
        await _databaseService.getAllChallenges();

    _log(
      '[fetchCloudChallenges] cloud challenges count: ${cloudChallenges?.length}',
    );

    if (cloudChallenges == null) {
      _log(
        '[fetchCloudChallenges] failed to fetch cloud challenges',
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
        '[fetchCloudChallenges] saved current challenges locally - success: $localSaveSuccess',
      );
    }

    // challenges deleted locally must be deleted in the cloud then removed from local storage.
    if (challengesDeletedLocally.isNotEmpty) {
      final bool cloudDeleteSuccess = await FBChallengesDataWriter.instance
          .deleteChallengesBatch(challengesDeletedLocally);
      _log(
        '[fetchCloudChallenges] delete challenges batch in cloud - success: $cloudDeleteSuccess',
      );

      // remove local deleted challenges permanently if successfully deleted in cloud
      if (cloudDeleteSuccess) {
        allChallenges = ChallengeHelpers.removeChallenges(
          challengesDeletedLocally,
          allChallenges,
        );
      }
    }

    final bool localSaveSuccess = await _storeChallengesInLocalDB();
    _log(
      '[fetchCloudChallenges] saved current challenges locally - success: $localSaveSuccess',
    );

    return true;
  }

  Future<void> addSet(PuttingSet set) async {
    if (currentChallenge == null) return;

    final List<PuttingSet> updatedSets =
        SetHelpers.addSet(set, currentChallenge!.currentUserSets);

    currentChallenge = currentChallenge?.copyWith(currentUserSets: updatedSets);
    onSetsChanged();
  }

  Future<void> deleteSet(PuttingSet set) async {
    currentChallenge?.currentUserSets.remove(set);
    onSetsChanged();
  }

  Future<void> onSetsChanged() async {
    final String? currentUid = _authService.getCurrentUserId();
    if (currentUid == null) return;
    currentChallenge = currentChallenge?.copyWith(
      currentUserSetsUpdatedAt: DateTime.now().toIso8601String(),
    );

    final StoragePuttingChallenge storageChallenge =
        StoragePuttingChallenge.fromPuttingChallenge(
      currentChallenge!,
      currentUid,
    );

    // active challenge
    if (currentChallenge?.recipientUser != null) {
      final bool updateChallengeSuccess =
          await _challengesService.updateStorageChallenge(storageChallenge);

      if (updateChallengeSuccess &&
          currentChallenge != null &&
          currentChallenge!.id == storageChallenge.id) {
        currentChallenge = currentChallenge?.copyWith(isSynced: true);
      }
    }
    // outgoing pending challenge
    else {
      final bool setChallengeSuccess =
          await _challengesService.setUnclaimedChallenge(storageChallenge);
      if (setChallengeSuccess &&
          currentChallenge != null &&
          currentChallenge!.id == storageChallenge.id) {
        currentChallenge = currentChallenge?.copyWith(isSynced: true);
      }
    }
    _storeChallengesInLocalDB();
    notifyListeners();
  }

  Future<void> resyncCurrentChallenge() async {
    final String? currentUid = _authService.getCurrentUserId();
    if (currentChallenge == null || currentUid == null) return;

    final PuttingChallenge? updatedChallenge =
        await _databaseService.getPuttingChallengeById(currentChallenge!.id);
    if (updatedChallenge == null) return;

    currentChallenge =
        currentChallenge?.copyWith(opponentSets: updatedChallenge.opponentSets);

    if (currentChallenge?.recipientUser != null) {
      await _challengesService.updateStorageChallenge(
        StoragePuttingChallenge.fromPuttingChallenge(
          currentChallenge!,
          currentUid,
        ),
      );
    } else {
      await _databaseService.setUnclaimedChallenge(
        StoragePuttingChallenge.fromPuttingChallenge(
          currentChallenge!,
          currentUid,
        ),
      );
    }
  }

  void openChallenge(PuttingChallenge challenge) {
    final String? currentUid = _authService.getCurrentUserId();
    if (currentUid == null) return;
    _listenToCurrentChallenge(challenge);

    if (challenge.status == ChallengeStatus.pending) {
      currentChallenge = challenge.copyWith(status: ChallengeStatus.active);
    } else {
      currentChallenge = challenge;
    }

    // move to from pending to active if necessary
    if (incomingPendingChallenges.contains(challenge)) {
      incomingPendingChallenges.remove(challenge);
      _addToAllChallenges(challenge);
      // activeChallenges.add(challenge);
      _challengesService.updateStorageChallenge(
        StoragePuttingChallenge.fromPuttingChallenge(
          currentChallenge!,
          currentUid,
        ),
      );
      _storeChallengesInLocalDB();
    }
  }

  void exitCurrentChallenge() {
    _currentChallengeSubscription?.cancel();
    _currentChallengeSubscription = null;
    currentChallenge = null;
  }

  Future<bool> finishChallenge() async {
    final String? currentUid = _authService.getCurrentUserId();
    if (currentChallenge == null || currentUid == null) {
      return false;
    }

    final PuttingChallenge? cloudCurrentChallenge = await _challengesService
        .getChallengeById(currentChallenge!.id, currentUid);

    // must check current challenge in cloud before finishing a session.
    if (cloudCurrentChallenge == null) {
      // logger error
      return false;
    }

    if (cloudCurrentChallenge.status != ChallengeStatus.active) {
      return false;
    }

    final ChallengeStage challengeStage =
        _challengesCubitHelper.getChallengeStage(currentChallenge!);

    // both users must be complete to finish the challenge.
    if (challengeStage != ChallengeStage.bothUsersComplete) {
      return false;
    }

    final PuttingChallenge completedCurrentChallenge =
        currentChallenge!.copyWith(
      status: ChallengeStatus.complete,
      completionTimeStamp: DateTime.now().millisecondsSinceEpoch,
    );

    final bool saveChallengeSuccess =
        await _challengesService.updateStorageChallenge(
      StoragePuttingChallenge.fromPuttingChallenge(
        completedCurrentChallenge,
        currentUid,
      ),
    );

    if (!saveChallengeSuccess) {
      return false;
    }

    if (activeChallenges.contains(currentChallenge!)) {
      activeChallenges = ChallengeHelpers.removeChallenges(
          [currentChallenge!], activeChallenges);
    }

    if (!completedChallenges.contains(currentChallenge!)) {
      _addToAllChallenges(currentChallenge!);
      // completedChallenges.add(currentChallenge!);
    }

    currentChallenge = completedCurrentChallenge;

    return _storeChallengesInLocalDB();
  }

  Future<void> moveCurrentChallengeToFinished() async {
    if (currentChallenge == null) return;
    if (activeChallenges.contains(currentChallenge!)) {
      activeChallenges = ChallengeHelpers.removeChallenges(
          [currentChallenge!], activeChallenges);
    }
    if (!completedChallenges.contains(currentChallenge!)) {
      _addToAllChallenges(currentChallenge!);
      // completedChallenges.add(currentChallenge!);
    }
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

  Future<bool> debugDeleteChallenge(PuttingChallenge challenge) async {
    final bool cloudDeleteSuccess =
        await _challengesService.deleteChallenge(challenge);

    if (!cloudDeleteSuccess) {
      _log('[debugDeleteChallenge] Failed to delete challenge in cloud');
      return false;
    }
    allChallenges = ChallengeHelpers.removeChallenges(
      [challenge],
      allChallenges,
    );

    final bool localSaveSuccess = await _storeChallengesInLocalDB();

    if (!localSaveSuccess) {
      _log('[sendChallenge] Failed to delete challenge in local DB');
    }

    return localSaveSuccess;
  }

  Future<bool> sendChallenge(
    PuttingChallenge challenge,
    String currentUid,
  ) async {
    final bool saveToCloudSuccess =
        await _challengesService.setInitialStorageChallenge(
      StoragePuttingChallenge.fromPuttingChallenge(challenge, currentUid),
    );

    if (!saveToCloudSuccess) {
      _log('[sendChallenge] Failed to save challenge to cloud');
      return false;
    }

    _log('num active challenges before: ${activeChallenges.length}');

    _addToAllChallenges(challenge);
    // activeChallenges.add(challenge);

    _log('num active challenges after: ${activeChallenges.length}');

    final bool localSaveSuccess = await _storeChallengesInLocalDB();

    if (!localSaveSuccess) {
      _log('[sendChallenge] Failed to save challenge to local DB');
    }

    return localSaveSuccess;
  }

  Future<bool> declineChallenge(PuttingChallenge challenge) async {
    incomingPendingChallenges = ChallengeHelpers.removeChallenges(
      [challenge],
      incomingPendingChallenges,
    );
    final bool deleteSuccess =
        await _challengesService.deleteChallenge(challenge);

    if (!deleteSuccess) {
      _log('[declineChallenge] Failed to delete challenge in cloud');
    }

    final bool localSaveSuccess = await _storeChallengesInLocalDB();

    if (!localSaveSuccess) {
      _log('[declineChallenge] Failed to save challenges to local DB');
    }

    return localSaveSuccess;
  }

  Future<void> addDeepLinkChallenges() async {
    final MyPuttUser? currentUser = _userRepository.currentUser;
    if (currentUser != null) {
      for (var storageChallenge in deepLinkChallenges) {
        if (storageChallenge.challengerUser.uid != currentUser.uid) {
          final StoragePuttingChallenge? existingChallenge =
              await _databaseService.getChallengeByUid(
            currentUser.uid,
            storageChallenge.id,
          );
          if (existingChallenge == null) {
            final PuttingChallenge challenge =
                PuttingChallenge.fromStorageChallenge(
              storageChallenge,
              currentUser,
            ).copyWith(status: ChallengeStatus.active);

            _addToAllChallenges(challenge);
            // activeChallenges.add(challenge);

            await _challengesService.updateStorageChallenge(
              StoragePuttingChallenge.fromPuttingChallenge(
                challenge,
                currentUser.uid,
              ),
            );
            await _databaseService.removeUnclaimedChallenge(challenge.id);
          }
        }
      }
      deepLinkChallenges = [];
    }
  }

  Future<bool> _storeChallengesInLocalDB() {
    _log(
        '[_storeChallengesInLocalDB] storing ${allChallenges.length} challenges in local db');
    return locator
        .get<LocalDBService>()
        .storeChallenges(allChallenges)
        .then((success) {
      _log('[_storeChallengesInLocalDB] success: $success');
      return success;
    });
  }

  void _log(String message) {
    if (Flags.kChallengesRepositoryLogs) {
      log('[ChallengesRepository] $message');
    }
  }
}
