import 'package:myputt/data/types/putting_challenge.dart';
import 'package:myputt/services/database_service.dart';

import '../utils/constants.dart';

class ChallengesRepository {
  final DatabaseService _databaseService = DatabaseService();

  List<PuttingChallenge> pendingChallenges = [];
  List<PuttingChallenge> activeChallenges = [];
  List<PuttingChallenge> completedChallenges = [];

  Future<void> fetchAllChallenges() async {
    final challengeLists = await Future.wait([
      _databaseService.getChallengesWithFilters([ChallengeStatus.pending]),
      _databaseService.getChallengesWithFilters([ChallengeStatus.active]),
      _databaseService.getChallengesWithFilters([ChallengeStatus.complete]),
    ]);

    if (challengeLists[0] is PuttingChallenge) {
      pendingChallenges = challengeLists[0];
    }
    if (challengeLists[1] is PuttingChallenge) {
      activeChallenges = challengeLists[1];
    }
    if (challengeLists[2] is PuttingChallenge) {
      completedChallenges = challengeLists[2];
    }
  }

  void activateChallenge(PuttingChallenge challenge) {
    pendingChallenges.remove(challenge);
    activeChallenges.add(challenge);
    _databaseService.updatePuttingChallenge(challenge);
  }
}
