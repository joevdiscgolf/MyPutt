part of 'home_screen_v2_cubit.dart';

@immutable
abstract class HomeScreenV2State {
  const HomeScreenV2State({this.tappedDownAt});
  final DateTime? tappedDownAt;
}

class HomeScreenV2Initial extends HomeScreenV2State {
  const HomeScreenV2Initial({DateTime? tappedDownAt})
      : super(tappedDownAt: tappedDownAt);
}

class HomeScreenV2Loaded extends HomeScreenV2State {
  const HomeScreenV2Loaded({
    required this.sets,
    required this.circleToIntervalPercentages,
    required this.timeRange,
    required this.homeScreenDistanceInterval,
    required this.circleToSelectedDistanceInterval,
    required this.chartDistance,
    required this.homeChartFilters,
    required this.chartDragData,
    DateTime? tappedDownAt,
  }) : super(tappedDownAt: tappedDownAt);

  final List<PuttingSet> sets;
  final Map<PuttingCircle, Map<DistanceInterval, PuttingSetInterval>>
      circleToIntervalPercentages;
  final int timeRange;
  final DistanceInterval homeScreenDistanceInterval;
  final Map<PuttingCircle, DistanceInterval> circleToSelectedDistanceInterval;
  final int? chartDistance;
  final HomeChartFilters homeChartFilters;
  final ChartDragData? chartDragData;

  HomeScreenV2Loaded copyWith(Map<String, dynamic> valuesToUpdate) {
    List<PuttingSet> sets = this.sets;
    Map<PuttingCircle, Map<DistanceInterval, PuttingSetInterval>>
        circleToIntervalPercentages = this.circleToIntervalPercentages;
    int timeRange = this.timeRange;
    DistanceInterval homeScreenDistanceInterval =
        this.homeScreenDistanceInterval;
    Map<PuttingCircle, DistanceInterval> circleToSelectedDistanceInterval =
        this.circleToSelectedDistanceInterval;
    int? chartDistance = this.chartDistance;
    HomeChartFilters homeChartFilters = this.homeChartFilters;
    ChartDragData? chartDragData = this.chartDragData;
    DateTime? tappedDownAt = this.tappedDownAt;

    if (valuesToUpdate.containsKey('sets')) {
      sets = valuesToUpdate['sets'];
    }
    if (valuesToUpdate.containsKey('circleToIntervalPercentages')) {
      circleToIntervalPercentages =
          valuesToUpdate['circleToIntervalPercentages'];
    }
    if (valuesToUpdate.containsKey('timeRange')) {
      timeRange = valuesToUpdate['timeRange'];
    }
    if (valuesToUpdate.containsKey('homeScreenDistanceInterval')) {
      homeScreenDistanceInterval = valuesToUpdate['homeScreenDistanceInterval'];
    }
    if (valuesToUpdate.containsKey('circleToSelectedDistanceInterval')) {
      circleToSelectedDistanceInterval =
          valuesToUpdate['circleToSelectedDistanceInterval'];
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
    if (valuesToUpdate.containsKey('tappedDownAt')) {
      tappedDownAt = valuesToUpdate['tappedDownAt'];
    }

    return HomeScreenV2Loaded(
      sets: sets,
      circleToIntervalPercentages: circleToIntervalPercentages,
      timeRange: timeRange,
      homeScreenDistanceInterval: homeScreenDistanceInterval,
      circleToSelectedDistanceInterval: circleToSelectedDistanceInterval,
      chartDistance: chartDistance,
      homeChartFilters: homeChartFilters,
      chartDragData: chartDragData,
      tappedDownAt: tappedDownAt,
    );
  }
}

class ChartDragData {
  const ChartDragData({
    this.dragging = false,
    this.draggedDate,
    this.draggedValue = 0,
    this.crossHairOffset,
    this.labelHorizontalOffset = 0,
    this.tappedDown = false,
    this.draggedIndex,
  });
  final bool dragging;
  final DateTime? draggedDate;
  final double? draggedValue;
  final Offset? crossHairOffset;
  final double? labelHorizontalOffset;
  final bool? tappedDown;
  final int? draggedIndex;

  ChartDragData copyWith({
    bool? dragging,
    DateTime? draggedDate,
    double? draggedValue,
    double? changePercentage,
    Offset? crossHairOffset,
    double? labelHorizontalOffset,
    bool? tappedDown,
    DateTime? tappedDownAt,
    int? draggedIndex,
  }) {
    return ChartDragData(
      dragging: dragging ?? this.dragging,
      draggedDate: draggedDate ?? this.draggedDate,
      draggedValue: draggedValue ?? this.draggedValue,
      crossHairOffset: crossHairOffset ?? this.crossHairOffset,
      labelHorizontalOffset:
          labelHorizontalOffset ?? this.labelHorizontalOffset,
      tappedDown: tappedDown ?? this.tappedDown,
      draggedIndex: draggedIndex ?? this.draggedIndex,
    );
  }
}
