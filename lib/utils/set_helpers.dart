import 'package:myputt/models/data/challenges/challenge_structure_item.dart';
import 'package:myputt/models/data/challenges/putting_challenge.dart';
import 'package:myputt/models/data/sessions/putting_session.dart';
import 'package:myputt/models/data/sessions/putting_set.dart';
import 'package:myputt/models/data/stats/sets_interval.dart';
import 'package:myputt/utils/calculators.dart';

abstract class SetHelpers {
  static ChallengeStructureItem getCurrentChallengeStructureItem(
      List<ChallengeStructureItem> challengeStructure,
      List<PuttingSet> playerSets) {
    final int index = playerSets.length >= challengeStructure.length
        ? playerSets.length - 1
        : playerSets.length;
    return challengeStructure[index];
  }

  static double percentageFromSet(PuttingSet set) {
    if (set.puttsAttempted == 0) {
      return 0;
    } else {
      return set.puttsMade / set.puttsAttempted;
    }
  }

  static double percentageFromSets(List<PuttingSet> sets) {
    final int totalAttempts = totalAttemptsFromSets(sets);
    final int totalMade = totalMadeFromSets(sets);

    if (totalAttempts == 0) {
      return 0;
    } else {
      return totalMade / totalAttempts;
    }
  }

  static Map<int, List<PuttingSet>> sortSetsByDistance(List<PuttingSet> sets) {
    final Map<int, List<PuttingSet>> setsByDistance = {};
    for (PuttingSet set in sets) {
      if (setsByDistance.containsKey(set.distance)) {
        setsByDistance[set.distance]!.add(set);
      } else {
        setsByDistance[set.distance] = [set];
      }
    }

    return setsByDistance;
  }

  static List<PuttingSet> getPuttingSetsFromIntervals(
    Map<DistanceInterval, PuttingSetInterval> intervalToSetsDataMap,
  ) {
    final List<PuttingSet> setsInInterval = [];

    for (PuttingSetInterval interval in intervalToSetsDataMap.values) {
      setsInInterval.addAll(interval.sets);
    }

    return setsInInterval;
  }

  static List<PuttingSet> puttingSetsFromPuttingActivities(
    List<dynamic> puttingActivities,
  ) {
    final List<PuttingSet> sets = [];

    for (var activity in puttingActivities) {
      if (activity is PuttingSession) {
        sets.addAll(activity.sets);
      } else if (activity is PuttingChallenge) {
        sets.addAll(activity.currentUserSets);
      }
    }

    return sets;
  }

  static List<PuttingSet> addSet(PuttingSet newSet, List<PuttingSet> allSets) {
    return [...allSets, newSet];
  }

  static List<PuttingSet> removeSet(
    PuttingSet setToRemove,
    List<PuttingSet> allSets,
  ) {
    return allSets
        .where((set) => set.timeStamp != setToRemove.timeStamp)
        .toList();
  }
}
