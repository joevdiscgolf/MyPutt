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
          PuttingSet(distance: 25, puttsAttempted: 10, puttsMade: 3),
          PuttingSet(distance: 25, puttsAttempted: 10, puttsMade: 4)
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

    if (result[0] is List<PuttingChallenge>) {
      pendingChallenges = result[0] as List<PuttingChallenge>;
    }
    if (result[1] is List<PuttingChallenge>) {
      activeChallenges = result[1] as List<PuttingChallenge>;
    }
    if (result[2] is List<PuttingChallenge>) {
      completedChallenges = result[2] as List<PuttingChallenge>;
    }
    if (result[3] is PuttingChallenge) {
      currentChallenge = result[3];
    }
  }

  void openChallenge(PuttingChallenge challenge) {
    currentChallenge = challenge;
    if (challenge.status == ChallengeStatus.pending) {
      challenge.status = ChallengeStatus.active;
      pendingChallenges.remove(challenge);
      activeChallenges.add(challenge);
    }
    challenge.status = ChallengeStatus.active;
    _databaseService.updatePuttingChallenge(challenge);
  }

  Future<bool> addSet(PuttingSet set) async {
    final String? uid = _authService.getCurrentUserId();
    if (currentChallenge != null && uid != null) {
      if (uid == currentChallenge!.recipientUid) {
        currentChallenge!.recipientSets.add(set);
      } else {
        currentChallenge!.challengerSets.add(set);
      }
      return _databaseService.updatePuttingChallenge(currentChallenge!);
    } else {
      return false;
    }
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
