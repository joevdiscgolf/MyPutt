import 'package:myputt/data/types/challenges/challenge_structure_item.dart';
import 'package:myputt/data/types/challenges/generated_challenge_item.dart';
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

List<ChallengeStructureItem> challengeStructureFromSession(
    PuttingSession session) {
  return session.sets
      .map((set) => ChallengeStructureItem(
          distance: set.distance.toInt(),
          setLength: set.puttsAttempted.toInt()))
      .toList();
}

List<ChallengeStructureItem> challengeStructureFromInstructions(
    List<GeneratedChallengeInstruction> instructions) {
  List<ChallengeStructureItem> items = [];
  for (var instruction in instructions) {
    items = [
      for (var i = 0; i < instruction.setCount; i++)
        ChallengeStructureItem(
            distance: instruction.distance, setLength: instruction.setLength)
    ];
  }
  return items;
}
