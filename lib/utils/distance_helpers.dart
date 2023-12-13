import 'package:myputt/models/data/stats/sets_interval.dart';
import 'package:myputt/utils/constants/distance_constants.dart';

class DistanceHelpers {
  static DistanceInterval getHomeScreenDistanceInterval(
    Map<DistanceInterval, PuttingSetInterval> intervalToPuttingSetsMap,
  ) {
    // find the interval that the user has the most putts in

    DistanceInterval? mostUsedDistanceInterval;
    int? mostSetsInInterval;

    for (MapEntry<DistanceInterval, PuttingSetInterval> entry
        in intervalToPuttingSetsMap.entries) {
      if (mostUsedDistanceInterval == null ||
          mostSetsInInterval == null ||
          entry.value.sets.length > mostSetsInInterval) {
        mostUsedDistanceInterval = entry.key;
        mostSetsInInterval = entry.value.sets.length;
      }
    }
    return mostUsedDistanceInterval ?? kDefaultDistanceInterval;
  }
}
