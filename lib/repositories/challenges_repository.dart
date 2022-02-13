import 'package:myputt/data/types/putting_challenge.dart';
import 'package:myputt/services/auth_service.dart';
import 'package:myputt/services/database_service.dart';
import 'package:myputt/data/types/putting_set.dart';
import 'package:myputt/locator.dart';

import '../utils/constants.dart';

class ChallengesRepository {
  final DatabaseService _databaseService = locator.get<DatabaseService>();
  final AuthService _authService = locator.get<AuthService>();

  Future<void> getTestChallenge() async {
    print(await _databaseService
        .getChallengesWithFilters([ChallengeStatus.active]));
  }

  PuttingChallenge? currentChallenge;
  List<PuttingChallenge> pendingChallenges = [
    PuttingChallenge(
        opponentSets: [
          PuttingSet(distance: 25, puttsAttempted: 10, puttsMade: 5),
          PuttingSet(distance: 25, puttsAttempted: 10, puttsMade: 6),
          PuttingSet(distance: 25, puttsAttempted: 10, puttsMade: 7),
          PuttingSet(distance: 25, puttsAttempted: 10, puttsMade: 7),
          PuttingSet(distance: 25, puttsAttempted: 10, puttsMade: 7)
        ],
        opponentUid: 'opponentuid',
        challengeStructureDistances: [20, 20, 15, 15, 15],
        creationTimeStamp: DateTime.now().millisecondsSinceEpoch,
        id: '${DateTime.now().millisecondsSinceEpoch}opponentuid',
        currentUserSets: [],
        currentUid: 'currentUid',
        status: ChallengeStatus.pending)
  ];
  List<PuttingChallenge> activeChallenges = [];
  List<PuttingChallenge> completedChallenges = [];

  Future<bool> addSet(PuttingSet set) async {
    final String? uid = _authService.getCurrentUserId();
    if (currentChallenge != null && uid != null) {
      /*if (uid == currentChallenge?.currentUid) {
      }*/
      currentChallenge!.currentUserSets.add(set);
      /*else if (uid == currentChallenge?.opponentUid) {
        currentChallenge!.opponentSets.add(set);
      } else {
        return false;
      }*/
      return true;
    } else {
      return false;
    }
  }

  Future<void> deleteSet(PuttingSet set) async {
    final String? uid = _authService.getCurrentUserId();
    if (currentChallenge != null && uid != null) {
      /*if (uid == currentChallenge?.currentUid) {
      }*/
      currentChallenge!.currentUserSets.remove(set);
      /*else if (uid == currentChallenge?.opponentUid) {
        currentChallenge!.opponentSets.add(set);
      } else {
        return false;
      }*/
    }
  }

  Future<void> fetchAllChallenges() async {
    final List<dynamic> result = await Future.wait([
      _databaseService.getChallengesWithFilters([ChallengeStatus.pending]),
      _databaseService.getChallengesWithFilters([ChallengeStatus.active]),
      _databaseService.getChallengesWithFilters([ChallengeStatus.complete]),
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
      if (pendingChallenges.contains(currentChallenge)) {
        completedChallenges.add(currentChallenge!);
        pendingChallenges.remove(currentChallenge);
        // database event here
      } else if (activeChallenges.contains(currentChallenge)) {
        completedChallenges.add(currentChallenge!);
        activeChallenges.remove(currentChallenge);
        // database event here
      }
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
      return _databaseService.updatePuttingChallenge(currentChallenge!);
    }
    return false;
  }

  void declineChallenge(PuttingChallenge challenge) {
    pendingChallenges.remove(challenge);
    // async database call
  }
}
/*
    /*PuttingChallenge(
        status: ChallengeStatus.pending,
        createdAt: 12345,
        id: 'id',
        opponentUid: 'opponentUid',
        currentUid: 'currentUid',
        challengeStructureDistances: [1, 2, 3],
        opponentSets: [],
        currentUserSets: [])*/*/
