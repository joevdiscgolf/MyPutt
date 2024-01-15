import 'package:flutter/material.dart';
import 'package:myputt/models/data/stats/sets_interval.dart';
import 'package:myputt/screens/home_v2/screens/circle_stats_screen/components/circle_percentages_screen_bar_chart.dart';
import 'package:myputt/screens/home_v2/screens/circle_stats_screen/components/circle_stats_screen_app_bar.dart';
import 'package:myputt/utils/enums.dart';

class CircleStatsScreen extends StatelessWidget {
  const CircleStatsScreen(
      {Key? key, required this.circle, required this.intervalToPuttingSetsData})
      : super(key: key);

  final PuttingCircle circle;
  final Map<DistanceInterval, PuttingSetInterval> intervalToPuttingSetsData;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CircleStatsScreenAppBar(circle: circle),
<<<<<<< Updated upstream
      body: CirclePercentagesScreenBarChart(
=======
      body: // body: CircleDiagram(circle: circle),
          CirclePercentagesScreenBarChart(
>>>>>>> Stashed changes
        circle: circle,
        setIntervalsMap: intervalToPuttingSetsData,
      ),
    );
  }
}
