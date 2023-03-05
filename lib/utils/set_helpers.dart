import 'package:myputt/models/data/challenges/challenge_structure_item.dart';
import 'package:myputt/models/data/sessions/putting_set.dart';
import 'package:myputt/models/data/stats/sets_interval.dart';
import 'package:myputt/utils/calculators.dart';

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

double percentageFromSets(List<PuttingSet> sets) {
  final int totalAttempts = totalAttemptsFromSets(sets);
  final int totalMade = totalMadeFromSets(sets);

  if (totalAttempts == 0) {
    return 0;
  } else {
    return totalMade / totalAttempts;
  }
}

Map<int, List<PuttingSet>> sortSetsByDistance(
  List<PuttingSet> sets,
  Map<int, List<PuttingSet>> setsByDistance,
) {
  for (PuttingSet set in sets) {
    if (setsByDistance.containsKey(set.distance)) {
      setsByDistance[set.distance]!.add(set);
    } else {
      setsByDistance[set.distance] = [set];
    }
  }

  return setsByDistance;
}

List<PuttingSet> getPuttingSetsFromIntervals(
  Map<DistanceInterval, PuttingSetInterval> intervalToSetsDataMap,
) {
  final List<PuttingSet> setsInInterval = [];

  for (PuttingSetInterval interval in intervalToSetsDataMap.values) {
    setsInInterval.addAll(interval.sets);
  }

  return setsInInterval;
}
