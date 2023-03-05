import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:myputt/locator.dart';
import 'package:myputt/models/data/chart/chart_point.dart';
import 'package:myputt/repositories/challenges_repository.dart';
import 'package:myputt/repositories/session_repository.dart';
import 'package:myputt/screens/home/components/stats_view/charts/performance_chart.dart';
import 'package:myputt/services/stats_service.dart';
import 'package:myputt/utils/colors.dart';
import 'package:myputt/utils/constants.dart';

class HomeScreenChartV2 extends StatelessWidget {
  const HomeScreenChartV2({Key? key, this.height = 200}) : super(key: key);

  final double height;

  @override
  Widget build(BuildContext context) {
    final List<ChartPoint> _points =
        locator.get<StatsService>().getPointsWithDistanceAndLimit(
              locator.get<SessionRepository>().validCompletedSessions,
              locator.get<ChallengesRepository>().completedChallenges,
              20,
              indexToTimeRange[0]!,
            );
    return SizedBox(
      height: height,
      child: LineChart(
        mainData(
          context,
          PerformanceChartData(points: _points),
        ),
      ),
    );
  }

  LineChartData mainData(BuildContext context, PerformanceChartData chartData) {
    // multiply by 100 because of percentage conversion

    final List<double> yValues =
        chartData.points.map((point) => point.decimal).toList();
    final double minY = yValues.reduce(min) * 100;
    final double maxY = yValues.reduce(max) * 100;

    return LineChartData(
      lineTouchData: LineTouchData(enabled: false),
      clipData: FlClipData(bottom: true, left: true, top: true, right: true),
      axisTitleData: FlAxisTitleData(
        leftTitle: AxisTitle(
          margin: 0,
          textAlign: TextAlign.center,
          showTitle: false,
          titleText: '%',
        ),
      ),
      gridData: FlGridData(show: false),
      titlesData: LineTitles.getTitleData(),
      borderData: FlBorderData(show: false),
      minX: 0,
      maxX: chartData.points.length.toDouble() - 1,
      minY: minY,
      maxY: maxY + 5,
      lineBarsData: [
        LineChartBarData(
          spots: chartData.points
              .asMap()
              .entries
              .map((entry) => FlSpot(entry.key.toDouble(),
                  double.parse((entry.value.decimal * 100).toStringAsFixed(4))))
              .toList(),
          isCurved: true,
          curveSmoothness: 0.5,
          colors: [MyPuttColors.darkBlue],
          barWidth: 4,
          isStrokeCapRound: true,
          dotData: FlDotData(show: false),
        ),
      ],
    );
  }
}
