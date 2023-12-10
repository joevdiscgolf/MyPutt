import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myputt/cubits/home/home_screen_v2_cubit.dart';
import 'package:myputt/locator.dart';
import 'package:myputt/models/data/chart/chart_point.dart';
import 'package:myputt/screens/home_v2/components/home_screen_chart_V2/home_screen_chart_v2.dart';
import 'package:myputt/services/chart_service.dart';
import 'package:myputt/utils/calculators.dart';
import 'package:myputt/utils/constants/distance_constants.dart';
import 'package:myputt/utils/helpers.dart';

class HomeScreenChartV2Builder extends StatelessWidget {
  const HomeScreenChartV2Builder({Key? key, this.height = 120})
      : super(key: key);

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
      builder: (context, state) {
        bool noData = false;
        List<ChartPoint> points = [];
        if (state is HomeScreenV2Loaded) {
          noData = state.sets.isEmpty;

          points = locator.get<ChartService>().generateChartPointsForInterval(
                state.sets,
                state.chartDistanceInterval ?? kPreferredDistanceInterval,
              );

          final int smoothPower = max(1, points.length ~/ 50);

          points = smoothChart(points, smoothPower);
        }

        return HomeScreenChartV2(
          height: height,
          points: points,
          screenWidth: MediaQuery.of(context).size.width,
          noData: noData,
        );
      },
    );
  }
}
