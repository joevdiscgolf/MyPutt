import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:myputt/cubits/home/data/enums.dart';
import 'package:myputt/cubits/home/data/home_screen_cubit_data.dart';
import 'package:myputt/protocols/myputt_cubit.dart';
import 'package:myputt/locator.dart';
import 'package:myputt/models/data/chart/chart_point.dart';
import 'package:myputt/models/data/conditions/conditions.dart';
import 'package:myputt/models/data/sessions/putting_set.dart';
import 'package:myputt/models/data/stats/sets_interval.dart';
import 'package:myputt/protocols/singleton_consumer.dart';
import 'package:myputt/repositories/challenges_repository.dart';
import 'package:myputt/repositories/session_repository.dart';
import 'package:myputt/services/stats_service.dart';
import 'package:myputt/utils/chart_helpers.dart';
import 'package:myputt/utils/constants.dart';
import 'package:myputt/utils/constants/distance_constants.dart';
import 'package:myputt/utils/distance_helpers.dart';
import 'package:myputt/utils/enums.dart';
import 'package:myputt/utils/layout_helpers.dart';
import 'package:myputt/utils/set_helpers.dart';

part 'home_screen_v2_state.dart';

class HomeScreenV2Cubit extends Cubit<HomeScreenV2State>
    implements MyPuttCubit, SingletonConsumer {
  HomeScreenV2Cubit() : super(const HomeScreenV2Initial());

  @override
  void initSingletons() {
    _sessionsRepository = locator.get<SessionsRepository>();
    _challengesRepository = locator.get<ChallengesRepository>();
    _statsService = locator.get<StatsService>();
  }

  @override
  void initCubit() {
    _sessionsRepository.addListener(() {
      onRepositoryUpdated();
    });
    _challengesRepository.addListener(() {
      onRepositoryUpdated();
    });
  }

  late final SessionsRepository _sessionsRepository;
  late final ChallengesRepository _challengesRepository;
  late final StatsService _statsService;

  void onRepositoryUpdated() {
    late final int timeRange;
    if (state is HomeScreenV2Loaded) {
      timeRange = (state as HomeScreenV2Loaded).timeRange;
    } else {
      timeRange = TimeRange.allTime;
    }

    final List<dynamic> puttingActivities =
        _statsService.getPuttingActivitiesByTimeRange(
      _sessionsRepository.validCompletedSessions,
      _challengesRepository.completedChallenges,
      [PuttingActivityType.session, PuttingActivityType.challenge],
      timeRange,
    );

    final List<PuttingSet> setsInActivities =
        SetHelpers.puttingSetsFromPuttingActivities(puttingActivities);

    final Map<PuttingCircle, Map<DistanceInterval, PuttingSetInterval>>
        circleToIntervalPercentages =
        _statsService.getSetIntervals(setsInActivities);

    if (state is HomeScreenV2Loaded) {
      emit(
        (state as HomeScreenV2Loaded).copyWith(
          {
            'circleToIntervalPercentages': circleToIntervalPercentages,
            'sets': setsInActivities
          },
        ),
      );
    } else {
      // update later
      final DistanceInterval homeScreenDistanceInterval =
          DistanceHelpers.getHomeScreenDistanceInterval(
        circleToIntervalPercentages[PuttingCircle.c1] ?? {},
      );

      emit(
        HomeScreenV2Loaded(
          sets: setsInActivities,
          circleToIntervalPercentages: circleToIntervalPercentages,
          homeScreenDistanceInterval: homeScreenDistanceInterval,
          circleToSelectedDistanceInterval:
              kDefaultCircleToSelectedDistanceInterval,
          timeRange: TimeRange.allTime,
          chartDistance: null,
          homeChartFilters: HomeChartFilters(
            puttingActivityTypes: PuttingActivityType.values,
            puttingConditions: const PuttingConditions(),
          ),
          chartDragData: null,
        ),
      );
    }
  }

  void updateTimeRange(int updatedTimeRange) {
    final List<dynamic> puttingActivities =
        _statsService.getPuttingActivitiesByTimeRange(
      _sessionsRepository.validCompletedSessions,
      _challengesRepository.completedChallenges,
      [PuttingActivityType.session, PuttingActivityType.challenge],
      updatedTimeRange,
    );

    final List<PuttingSet> setsInActivities =
        SetHelpers.puttingSetsFromPuttingActivities(puttingActivities);

    final Map<PuttingCircle, Map<DistanceInterval, PuttingSetInterval>>
        circleToIntervalPercentages =
        _statsService.getSetIntervals(setsInActivities);

    if (state is HomeScreenV2Loaded) {
      emit(
        (state as HomeScreenV2Loaded).copyWith(
          {
            'sets': setsInActivities,
            'circleToIntervalPercentages': circleToIntervalPercentages,
            'timeRange': updatedTimeRange,
          },
        ),
      );
    } else {
      final DistanceInterval homeScreenDistanceInterval =
          DistanceHelpers.getHomeScreenDistanceInterval(
        circleToIntervalPercentages[PuttingCircle.c1] ?? {},
      );

      emit(
        HomeScreenV2Loaded(
          sets: setsInActivities,
          circleToIntervalPercentages: circleToIntervalPercentages,
          homeScreenDistanceInterval: homeScreenDistanceInterval,
          circleToSelectedDistanceInterval:
              kDefaultCircleToSelectedDistanceInterval,
          timeRange: updatedTimeRange,
          chartDistance: null,
          homeChartFilters: HomeChartFilters(
            puttingActivityTypes: PuttingActivityType.values,
            puttingConditions: const PuttingConditions(),
          ),
          chartDragData: null,
        ),
      );
    }
  }

  void updateDistanceInterval(DistanceInterval interval) {
    if (state is HomeScreenV2Loaded) {
      emit(
        (state as HomeScreenV2Loaded).copyWith(
          {'circleToDistanceInterval': interval},
        ),
      );
    }
  }

  void handleDrag(
    context, {
    required Offset dragOffset,
    required List<ChartPoint> points,
    required double screenWidth,
    required double chartHeight,
    bool? tappedDown,
    bool horizontalDragStart = false,
  }) {
    if (state is! HomeScreenV2Loaded) {
      if (tappedDown == true) {
        // state is HomeScreenV2Initial if not HomeScreenV2Loaded
        emit(HomeScreenV2Initial(tappedDownAt: DateTime.now()));
      }
      return;
    } else if (points.isEmpty) {
      if (tappedDown == true) {
        emit(
          (state as HomeScreenV2Loaded).copyWith({
            'tappedDownAt': DateTime.now(),
          }),
        );
      }
      return;
    }

    HomeScreenV2Loaded loadedState = state as HomeScreenV2Loaded;

    final ChartDragData? chartDragData = loadedState.chartDragData;

    if (horizontalDragStart && chartDragData?.tappedDown != true) {
      HapticFeedback.heavyImpact();
    }

    late double draggedValue;
    late int draggedIndex;

    if (points.length == 1) {
      draggedValue = points[0].decimal;
    }

    final double pointIndexDecimal = ChartHelpers.getPointIndexDecimal(
      dragOffset.dx,
      points.length,
      screenWidth,
    );

    final double remainder = pointIndexDecimal % 1;

    final int index = pointIndexDecimal.floor();
    if (remainder == 0) {
      draggedValue = points[index].decimal;
    }

    final int lowIndex = pointIndexDecimal.floor();
    final int highIndex = lowIndex + 1;
    draggedIndex = lowIndex;

    draggedValue =
        ChartHelpers.valueBetweenPoints(remainder, lowIndex, highIndex, points);

    final TextStyle scrubberLabelStyle = Theme.of(context).textTheme.bodyLarge!;
    final double scrubberWidth = max(
      getTextWidth(
        DateFormat.yMMMd('en_US').format(DateTime.fromMillisecondsSinceEpoch(
            points[draggedIndex].timeStamp)),
        scrubberLabelStyle,
      ),
      getTextWidth('${double.parse((draggedValue * 100).toStringAsFixed(4))}%',
          scrubberLabelStyle),
    );

    final double dateScrubberOffset =
        ChartHelpers.getDateScrubberHorizontalOffset(
      dragOffset,
      screenWidth,
      8,
      scrubberWidth: scrubberWidth,
    );

    emit(
      loadedState.copyWith(
        {
          'tappedDownAt':
              tappedDown == true ? DateTime.now() : loadedState.tappedDownAt,
          'chartDragData': ChartDragData(
            draggedValue: draggedValue,
            draggedDate: DateTime.fromMillisecondsSinceEpoch(
                points[draggedIndex].timeStamp),
            crossHairOffset: dragOffset,
            labelHorizontalOffset: dateScrubberOffset,
            tappedDown: tappedDown ?? chartDragData?.tappedDown,
            dragging: true,
            draggedIndex: draggedIndex,
          )
        },
      ),
    );
  }

  void handleDragEnd(BuildContext context) {
    if (state is HomeScreenV2Loaded) {
      emit((state as HomeScreenV2Loaded).copyWith({'chartDragData': null}));
    }
  }
}
