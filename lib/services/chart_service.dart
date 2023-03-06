import 'package:myputt/models/data/chart/chart_point.dart';
import 'package:myputt/models/data/sessions/putting_set.dart';
import 'package:myputt/models/data/stats/sets_interval.dart';
import 'package:collection/collection.dart';
import 'package:myputt/utils/set_helpers.dart';

class ChartService {
  List<ChartPoint> generateChartPointsForInterval(
    List<PuttingSet> sets,
    DistanceInterval distanceInterval,
  ) {
    sets.sort((s1, s2) => (s2.timeStamp ?? 0).compareTo(s1.timeStamp ?? 0));

    return [
      ...sets.mapIndexed(
        (index, set) => ChartPoint(
          distance: set.distance,
          decimal: percentageFromSet(set),
          timeStamp: set.timeStamp ?? 0,
          index: index,
        ),
      )
    ];
  }
}
