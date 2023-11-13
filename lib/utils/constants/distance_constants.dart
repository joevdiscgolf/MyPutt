import 'package:myputt/models/data/stats/sets_interval.dart';
import 'package:myputt/utils/enums.dart';

const Map<PuttingCircle, List<int>> kCircleToDistanceIntervals = {
  PuttingCircle.c1: [0, 10, 15, 20, 25, 30, 33],
  PuttingCircle.c2: [34, 35, 40, 45, 50, 55, 60, 66],
  PuttingCircle.c3: [67, 70, 75, 80, 85, 90, 95, 100],
};

const DistanceInterval kPreferredDistanceInterval =
    DistanceInterval(lowerBound: 21, upperBound: 25);
