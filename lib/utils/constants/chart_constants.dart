import 'package:myputt/utils/constants.dart';

abstract class ChartConstants {
  static Map<int, int?> kTimeRangeToNumPoints = {
    TimeRange.lastFive: 25,
    TimeRange.lastTwenty: 50,
    TimeRange.lastFifty: 100,
    TimeRange.allTime: 100,
  };
}
