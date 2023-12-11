import 'package:flutter/material.dart';
import 'package:myputt/components/charts/distance_interval.dart';
import 'package:myputt/models/data/stats/sets_interval.dart';
import 'package:myputt/utils/constants.dart';
import 'package:myputt/utils/enums.dart';

class CircleChartSection extends StatelessWidget {
  const CircleChartSection({
    super.key,
    required this.circle,
    required this.distanceInterval,
  });

  final PuttingCircle circle;
  final DistanceInterval distanceInterval;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          child: Text(
            '${kCircleToNameMap[circle]}',
            style: Theme.of(context)
                .textTheme
                .headlineSmall
                ?.copyWith(fontWeight: FontWeight.bold),
          ),
        ),
        DistanceIntervalPerformanceChart(
          height: 120,
          distanceInterval: distanceInterval,
          chartDragData: null,
        ),
      ],
    );
  }
}
