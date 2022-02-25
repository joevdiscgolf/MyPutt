import 'package:myputt/data/types/challenges/storage_putting_challenge.dart';
import 'package:myputt/data/types/myputt_user.dart';
import 'package:myputt/data/types/challenges/putting_challenge.dart';
import 'package:myputt/repositories/user_repository.dart';
import 'package:myputt/services/auth_service.dart';
import 'package:myputt/services/database_service.dart';
import 'package:myputt/data/types/putting_set.dart';
import 'package:myputt/locator.dart';
import 'package:myputt/utils/constants.dart';

class ChallengesRepository {
  final DatabaseService _databaseService = locator.get<DatabaseService>();
  final AuthService _authService = locator.get<AuthService>();
  final UserRepository _userRepository = locator.get<UserRepository>();

  PuttingChallenge? currentChallenge;
  List<PuttingChallenge> pendingChallenges = [];
  List<PuttingChallenge> activeChallenges = [];
  List<PuttingChallenge> completedChallenges = [];
  List<StoragePuttingChallenge> deepLinkChallenges = [];

  void clearData() {
    currentChallenge = null;
    pendingChallenges = [];
    activeChallenges = [];
    completedChallenges = [];
  }

  Future<bool> addSet(PuttingSet set) async {
    final String? uid = _authService.getCurrentUserId();
    if (currentChallenge != null && uid != null) {
      currentChallenge!.currentUserSets.add(set);
      return true;
    } else {
      return false;
    }
  }

  Future<void> deleteSet(PuttingSet set) async {
    final String? uid = _authService.getCurrentUserId();
    if (currentChallenge != null && uid != null) {
      currentChallenge!.currentUserSets.remove(set);
      await _databaseService.setPuttingChallenge(currentChallenge!);
    }
  }

  Future<void> fetchAllChallenges() async {
    final List<dynamic> result = await Future.wait([
      _databaseService.getChallengesWithStatus(ChallengeStatus.pending),
      _databaseService.getChallengesWithStatus(ChallengeStatus.active),
      _databaseService.getChallengesWithStatus(ChallengeStatus.complete),
      _databaseService.getCurrentPuttingChallenge(),
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
    if (result[3] != null && result[3] is PuttingChallenge) {
      currentChallenge = result[3];
    }
  }

  void openChallenge(PuttingChallenge challenge) {
    currentChallenge = challenge;
    if (currentChallenge?.status == ChallengeStatus.pending) {
      currentChallenge?.status = ChallengeStatus.active;
    }
    if (pendingChallenges.contains(challenge)) {
      pendingChallenges.remove(challenge);
      activeChallenges.add(currentChallenge!);
    }
    //_databaseService.updatePuttingChallenge(currentChallenge!);
  }

  Future<bool> completeCurrentChallenge() async {
    if (currentChallenge == null) {
      return false;
    } else {
      currentChallenge?.status = ChallengeStatus.complete;
      if (activeChallenges.contains(currentChallenge)) {
        completedChallenges.add(currentChallenge!);
        activeChallenges.remove(currentChallenge);
      }
      await _databaseService.setPuttingChallenge(currentChallenge!);
      await _databaseService.sendCompletedChallenge(currentChallenge!);
      currentChallenge = null;
      return true;
    }
  }

  void exitChallenge() {
    currentChallenge = null;
    //_databaseService.updatePuttingChallenge(currentChallenge!);
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

  Future<bool> storeCurrentChallenge() async {
    if (currentChallenge != null) {
      return _databaseService.setPuttingChallenge(currentChallenge!);
    }
    return false;
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
            await _databaseService.setPuttingChallenge(challenge);
            await _databaseService.removeUnclaimedChallenge(challenge.id);
          }
        }
      }
      deepLinkChallenges = [];
    }
  }
}
