part of 'home_screen_v2_cubit.dart';

@immutable
abstract class HomeScreenV2State {
  const HomeScreenV2State();
}

class HomeScreenV2Initial extends HomeScreenV2State {
  const HomeScreenV2Initial();
}

class HomeScreenV2Loaded extends HomeScreenV2State {
  const HomeScreenV2Loaded({
    required this.distanceIntervalToSetData,
    required this.timeRange,
    required this.chartDistInterval,
    required this.chartDistance,
    required this.homeChartFilters,
  });
  final Map<DistanceInterval, PuttingSetInterval> distanceIntervalToSetData;
  final TimeRange timeRange;
  final DistanceInterval? chartDistInterval;
  final int? chartDistance;
  final HomeChartFilters homeChartFilters;
}
