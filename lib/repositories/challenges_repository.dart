import 'package:myputt/data/types/putting_challenge.dart';
import 'package:myputt/services/database_service.dart';

import '../utils/constants.dart';

class ChallengesRepository {
  final DatabaseService _databaseService = DatabaseService();

  PuttingChallenge? currentPuttingChallenge;
  List<PuttingChallenge> pendingChallenges = [];
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
    if (result[3] is PuttingChallenge) {}
  }

  void activateChallenge(PuttingChallenge challenge) {
    pendingChallenges.remove(challenge);
    activeChallenges.add(challenge);
    _databaseService.updatePuttingChallenge(challenge);
  }
}
