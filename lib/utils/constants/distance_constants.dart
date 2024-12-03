import 'package:myputt/models/data/stats/sets_interval.dart';
import 'package:myputt/utils/enums.dart';

const Map<PuttingCircle, double> kCircleToMinDistance = {
  PuttingCircle.c1: 0,
  PuttingCircle.c2: 34,
  PuttingCircle.c3: 67,
};
const Map<PuttingCircle, double> kCircleToMaxDistance = {
  PuttingCircle.c1: 33,
  PuttingCircle.c2: 66,
  PuttingCircle.c3: 100,
};

const Map<PuttingCircle, List<int>> kCircleToDistanceIntervals = {
  PuttingCircle.c1: [0, 10, 15, 20, 25, 30, 33],
  PuttingCircle.c2: [34, 35, 40, 45, 50, 55, 60, 66],
  PuttingCircle.c3: [67, 70, 75, 80, 85, 90, 95, 100],
};

const Map<PuttingCircle, DistanceInterval>
    kDefaultCircleToSelectedDistanceInterval = {
  PuttingCircle.c1: DistanceInterval(lowerBound: 21, upperBound: 25),
  PuttingCircle.c2: DistanceInterval(lowerBound: 34, upperBound: 66),
  PuttingCircle.c3: DistanceInterval(lowerBound: 67, upperBound: 99),
};

const DistanceInterval kDefaultDistanceInterval =
    DistanceInterval(lowerBound: 21, upperBound: 25);
