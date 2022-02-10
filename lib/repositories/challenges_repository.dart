import 'package:myputt/data/types/putting_challenge.dart';
import 'package:myputt/services/auth_service.dart';
import 'package:myputt/services/database_service.dart';
import 'package:myputt/data/types/putting_set.dart';
import 'package:myputt/locator.dart';

import '../utils/constants.dart';

class ChallengesRepository {
  final DatabaseService _databaseService = locator.get<DatabaseService>();
  final AuthService _authService = locator.get<AuthService>();

  PuttingChallenge? currentChallenge;
  List<PuttingChallenge> pendingChallenges = [
    PuttingChallenge(
        challengerSets: [
          PuttingSet(distance: 25, puttsAttempted: 10, puttsMade: 5),
          PuttingSet(distance: 25, puttsAttempted: 10, puttsMade: 6),
          PuttingSet(distance: 25, puttsAttempted: 10, puttsMade: 7)
        ],
        challengerUid: 'challengeruid',
        challengeStructureDistances: [20, 20, 15],
        createdAt: 1643453201,
        id: 'thischallengeId',
        recipientSets: [
          /*PuttingSet(distance: 25, puttsAttempted: 10, puttsMade: 3),
          PuttingSet(distance: 25, puttsAttempted: 10, puttsMade: 4)*/
        ],
        recipientUid: 'recipientuid',
        status: ChallengeStatus.active)
  ];
  List<PuttingChallenge> activeChallenges = [];
  List<PuttingChallenge> completedChallenges = [];

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

  void openChallenge(/*PuttingChallenge challenge*/) {
    currentChallenge = PuttingChallenge(
        challengerSets: [
          PuttingSet(distance: 25, puttsAttempted: 10, puttsMade: 5),
          PuttingSet(distance: 25, puttsAttempted: 10, puttsMade: 6),
          PuttingSet(distance: 25, puttsAttempted: 10, puttsMade: 7),
          PuttingSet(distance: 25, puttsAttempted: 10, puttsMade: 7),
          PuttingSet(distance: 25, puttsAttempted: 10, puttsMade: 7)
        ],
        challengerUid: 'challengeruid',
        challengeStructureDistances: [20, 20, 15, 15, 15],
        createdAt: 1643453201,
        id: 'thischallengeId',
        recipientSets: [
          /*PuttingSet(distance: 25, puttsAttempted: 10, puttsMade: 3),
          PuttingSet(distance: 25, puttsAttempted: 10, puttsMade: 4)*/
        ],
        recipientUid: 'recipientuid',
        status: ChallengeStatus.active);
    if (currentChallenge?.status == ChallengeStatus.pending) {
      currentChallenge?.status = ChallengeStatus.active;
      pendingChallenges.remove(currentChallenge);
      activeChallenges.add(currentChallenge!);
    }
    //_databaseService.updatePuttingChallenge(currentChallenge!);
  }

  Future<bool> addSet(PuttingSet set) async {
    final String? uid = _authService.getCurrentUserId();
    if (currentChallenge != null && uid != null) {
      /*if (uid == currentChallenge?.recipientUid) {
      }*/
      currentChallenge!.recipientSets.add(set);
      /*else if (uid == currentChallenge?.challengerUid) {
        currentChallenge!.challengerSets.add(set);
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
      /*if (uid == currentChallenge?.recipientUid) {
      }*/
      currentChallenge!.recipientSets.remove(set);
      /*else if (uid == currentChallenge?.challengerUid) {
        currentChallenge!.challengerSets.add(set);
      } else {
        return false;
      }*/
    }
  }

  Future<bool> storeCurrentChallenge() async {
    if (currentChallenge != null) {
      return _databaseService.updatePuttingChallenge(currentChallenge!);
    }
    return false;
  }
}
/*
    /*PuttingChallenge(
        status: ChallengeStatus.pending,
        createdAt: 12345,
        id: 'id',
        challengerUid: 'challengerUid',
        recipientUid: 'recipientUid',
        challengeStructureDistances: [1, 2, 3],
        challengerSets: [],
        recipientSets: [])*/*/
