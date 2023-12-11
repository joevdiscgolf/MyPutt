import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myputt/components/charts/generic_performance_chart.dart';
import 'package:myputt/cubits/home/home_screen_v2_cubit.dart';
import 'package:myputt/locator.dart';
import 'package:myputt/models/data/chart/chart_point.dart';
import 'package:myputt/models/data/stats/sets_interval.dart';
import 'package:myputt/services/chart_service.dart';
import 'package:myputt/utils/calculators.dart';
import 'package:myputt/utils/helpers.dart';

class DistanceIntervalPerformanceChart extends StatelessWidget {
  const DistanceIntervalPerformanceChart({
    super.key,
    required this.distanceInterval,
    required this.chartDragData,
    this.height = 120,
  });

  final DistanceInterval distanceInterval;
  final ChartDragData? chartDragData;
  final double height;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeScreenV2Cubit, HomeScreenV2State>(
      buildWhen: (previous, current) {
        final HomeScreenV2Loaded? previousLoadedState =
            tryCast<HomeScreenV2Loaded>(previous);
        final HomeScreenV2Loaded? currentLoadedState =
            tryCast<HomeScreenV2Loaded>(current);
        if (previousLoadedState == null || currentLoadedState == null) {
          return true;
        }
        return previousLoadedState.chartDistanceInterval !=
                currentLoadedState.chartDistanceInterval ||
            previousLoadedState.circleToIntervalsMap !=
                currentLoadedState.circleToIntervalsMap ||
            previousLoadedState.timeRange != currentLoadedState.timeRange ||
            previousLoadedState.sets != currentLoadedState.sets;
      },
      builder: (context, homeScreenV2State) {
        bool noData = false;
        List<ChartPoint> points = [];

        if (homeScreenV2State is HomeScreenV2Loaded) {
          noData = homeScreenV2State.sets.isEmpty;

          points = locator.get<ChartService>().generateChartPointsForInterval(
                homeScreenV2State.sets,
                distanceInterval,
              );

          final int smoothPower = max(1, points.length ~/ 50);

          points = smoothChart(points, smoothPower);
        }

        return GenericPerformanceChart(
          height: height,
          points: points,
          screenWidth: MediaQuery.of(context).size.width,
          noData: noData,
          chartDragData: chartDragData,
        );
      },
    );
  }
}
