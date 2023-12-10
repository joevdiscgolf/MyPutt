import 'package:myputt/models/data/chart/chart_enums.dart';

abstract class ChartConstants {
  static Map<ChartRange, int?> kChartRangeToNumPoints = {
    ChartRange.lastFive: 25,
    ChartRange.lastTwenty: 50,
    ChartRange.lastFifty: 100,
    ChartRange.all: 100,
  };
}
