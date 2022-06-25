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
