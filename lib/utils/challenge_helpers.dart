import 'package:myputt/data/types/challenges/putting_challenge.dart';
import 'package:myputt/locator.dart';
import 'package:myputt/services/auth_service.dart';

final AuthService _authService = locator.get<AuthService>();

bool currentUserSetsComplete(PuttingChallenge challenge) {
  return challenge.currentUserSets.length ==
      challenge.challengeStructure.length;
}

List<PuttingChallenge> removeDuplicateChallenges(
    List<PuttingChallenge> challenges) {
  final String? currentUid = _authService.getCurrentUserId();
  return challenges
      .where((challenge) => !(challenge.createdFromSession != null &&
          challenge.createdFromSession! &&
          challenge.challengerUser.uid == currentUid))
      .toList();
}
