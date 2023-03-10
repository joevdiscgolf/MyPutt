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
    required this.sets,
    required this.circleToIntervalsMap,
    required this.timeRange,
    required this.chartDistanceInterval,
    required this.chartDistance,
    required this.homeChartFilters,
    required this.chartDragData,
  });

  final List<PuttingSet> sets;
  final Map<Circles, Map<DistanceInterval, PuttingSetInterval>>
      circleToIntervalsMap;
  final int timeRange;
  final DistanceInterval? chartDistanceInterval;
  final int? chartDistance;
  final HomeChartFilters homeChartFilters;
  final ChartDragData? chartDragData;

  HomeScreenV2Loaded copyWith(Map<String, dynamic> valuesToUpdate) {
    List<PuttingSet> sets = this.sets;
    Map<Circles, Map<DistanceInterval, PuttingSetInterval>>
        circleToIntervalsMap = this.circleToIntervalsMap;
    int timeRange = this.timeRange;
    DistanceInterval? chartDistanceInterval = this.chartDistanceInterval;
    int? chartDistance = this.chartDistance;
    HomeChartFilters homeChartFilters = this.homeChartFilters;
    ChartDragData? chartDragData = this.chartDragData;

    if (valuesToUpdate.containsKey('sets')) {
      sets = valuesToUpdate['sets'];
    }
    if (valuesToUpdate.containsKey('circleToIntervalsMap')) {
      circleToIntervalsMap = valuesToUpdate['circleToIntervalsMap'];
    }
    if (valuesToUpdate.containsKey('timeRange')) {
      timeRange = valuesToUpdate['timeRange'];
    }
    if (valuesToUpdate.containsKey('chartDistanceInterval')) {
      chartDistanceInterval = valuesToUpdate['chartDistanceInterval'];
    }
    if (valuesToUpdate.containsKey('chartDistance')) {
      chartDistance = valuesToUpdate['chartDistance'];
    }
    if (valuesToUpdate.containsKey('homeChartFilters')) {
      homeChartFilters = valuesToUpdate['homeChartFilters'];
    }
    if (valuesToUpdate.containsKey('chartDragData')) {
      chartDragData = valuesToUpdate['chartDragData'];
    }

    return HomeScreenV2Loaded(
      sets: sets,
      circleToIntervalsMap: circleToIntervalsMap,
      timeRange: timeRange,
      chartDistanceInterval: chartDistanceInterval,
      chartDistance: chartDistance,
      homeChartFilters: homeChartFilters,
      chartDragData: chartDragData,
    );
  }
}

class ChartDragData {}
