import 'package:myputt/models/data/challenges/challenge_structure_item.dart';
import 'package:myputt/models/data/sessions/putting_set.dart';

ChallengeStructureItem getCurrentChallengeStructureItem(
    List<ChallengeStructureItem> challengeStructure,
    List<PuttingSet> playerSets) {
  final int index = playerSets.length >= challengeStructure.length
      ? playerSets.length - 1
      : playerSets.length;
  return challengeStructure[index];
}

double percentageFromSet(PuttingSet set) {
  if (set.puttsAttempted == 0) {
    return 0;
  } else {
    return set.puttsMade / set.puttsAttempted;
  }
}
