import 'package:myputt/models/data/stats/sets_interval.dart';
import 'package:myputt/utils/constants/distance_constants.dart';

class DistanceHelpers {
  static DistanceInterval? getPrimaryDistanceInterval(
    Map<DistanceInterval, PuttingSetInterval> intervalToPuttingSetsMap,
  ) {
    // if the user has sets in the preferred distance interval (21-25 feet)
    if (intervalToPuttingSetsMap[kPreferredDistanceInterval]?.sets.isNotEmpty ==
        true) {
      return kPreferredDistanceInterval;
    }
    // else, find the interval that the user has the most putts in
    else {
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
      return mostUsedDistanceInterval;
    }
  }
}
