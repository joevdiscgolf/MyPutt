import 'package:flutter/material.dart';
import 'package:myputt/components/charts/distance_interval_performance_chart.dart';
import 'package:myputt/models/data/stats/sets_interval.dart';
import 'package:myputt/screens/home_v2/screens/circle_stats_screen/components/circle_percentages_screen_bar_chart.dart';
import 'package:myputt/screens/home_v2/screens/circle_stats_screen/components/circle_stats_screen_app_bar.dart';
import 'package:myputt/screens/home_v2/screens/circle_stats_screen/components/distance_picker_double_slider.dart';
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
      appBar: const CircleStatsScreenAppBar(),
      body:
          // const CircleDiagram(circle: PuttingCircle.c3),
          _barChartBody(context),
    );
  }

  Widget _barChartBody(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          color: MyPuttColors.gray[800],
          child: const DistanceIntervalPerformanceChart(
            height: 200,
            distanceInterval: DistanceInterval(lowerBound: 0, upperBound: 25),
            chartDragData: null,
            hasAxisLabels: false,
            hasGridlines: false,
          ),
        ),
        const SizedBox(height: 16),
        const DistancePickerDoubleSlider(),
        const SizedBox(height: 24),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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
        )
      ],
    );
  }
}

/*
 // Text(
        //   'Average %',
        //   style: Theme.of(context).textTheme.headlineSmall?.copyWith(
        //         fontWeight: FontWeight.w800,
        //         color: MyPuttColors.gray[800],
        //       ),
        // ),
        // const SizedBox(height: 8),
        // Text(
        //   numSetsInCircle == 0
        //       ? '--%'
        //       : '${(percentageForCircle * 100).toInt()}%',
        //   style: Theme.of(context).textTheme.displayMedium?.copyWith(
        //         fontWeight: FontWeight.w900,
        //         color: MyPuttColors.green,
        //         // color: MyPuttColors.gray[800],
        //         letterSpacing: -0.5,
        //       ),
        // ),
*/