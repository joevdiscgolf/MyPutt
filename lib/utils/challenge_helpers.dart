import 'package:myputt/data/types/challenges/putting_challenge.dart';
import 'package:myputt/data/types/sessions/putting_session.dart';
import 'package:collection/collection.dart';

bool currentUserSetsComplete(PuttingChallenge challenge) {
  return challenge.currentUserSets.length ==
      challenge.challengeStructure.length;
}

bool isDuplicateChallenge(
    List<PuttingSession> sessions, PuttingChallenge challenge) {
  final PuttingSession? match = sessions.firstWhereOrNull(
    (session) => session.id == challenge.id,
  );
  return match != null;
}

List<PuttingChallenge> filterDuplicateChallenges(
    List<PuttingSession> sessions, List<PuttingChallenge> challenges) {
  return challenges
      .where((challenge) => !isDuplicateChallenge(sessions, challenge))
      .toList();
}
