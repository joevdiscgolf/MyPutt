import 'package:flutter/material.dart';
import 'package:myputt/models/data/stats/sets_interval.dart';
import 'package:myputt/screens/home_v2/screens/circle_stats_screen/components/circle_percentages_screen_bar_chart.dart';
import 'package:myputt/screens/home_v2/screens/circle_stats_screen/components/circle_stats_screen_app_bar.dart';
import 'package:myputt/utils/colors.dart';
import 'package:myputt/utils/enums.dart';

class CircleStatsScreen extends StatelessWidget {
  const CircleStatsScreen({
    Key? key,
    required this.circle,
    required this.intervalToPuttingSetsData,
    required this.percentageForCircle,
    required this.numSetsInCircle,
  }) : super(key: key);

  final PuttingCircle circle;
  final Map<DistanceInterval, PuttingSetInterval> intervalToPuttingSetsData;
  final double percentageForCircle;
  final int numSetsInCircle;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CircleStatsScreenAppBar(circle: circle),
      body:
          // const CircleDiagram(circle: PuttingCircle.c3),
          _barChartBody(context),
    );
  }

  Widget _barChartBody(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Text(
          //   'Average %',
          //   style: Theme.of(context).textTheme.headlineSmall?.copyWith(
          //         fontWeight: FontWeight.w800,
          //         color: MyPuttColors.gray[800],
          //       ),
          // ),
          // const SizedBox(height: 8),
          Text(
            numSetsInCircle == 0
                ? '--%'
                : '${(percentageForCircle * 100).toInt()}%',
            style: Theme.of(context).textTheme.displayMedium?.copyWith(
                  fontWeight: FontWeight.w900,
                  color: MyPuttColors.green,
                  // color: MyPuttColors.gray[800],
                  letterSpacing: -0.5,
                ),
          ),
          const SizedBox(height: 24),
          Text(
            'Ranges',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: MyPuttColors.gray[400],
                ),
          ),
          const SizedBox(height: 12),
          CirclePercentagesScreenBarChart(
            circle: circle,
            setIntervalsMap: intervalToPuttingSetsData,
          ),
        ],
      ),
    );
  }
}
