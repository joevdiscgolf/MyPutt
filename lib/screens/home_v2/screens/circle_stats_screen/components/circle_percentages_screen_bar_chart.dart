import 'package:flutter/material.dart';
import 'package:myputt/components/bars/bar_chart.dart';
import 'package:myputt/models/data/stats/sets_interval.dart';
import 'package:myputt/utils/enums.dart';

class CirclePercentagesScreenBarChart extends StatelessWidget {
  const CirclePercentagesScreenBarChart(
      {Key? key, required this.circle, required this.setIntervalsMap})
      : super(key: key);

  final PuttingCircle circle;
  final Map<DistanceInterval, PuttingSetInterval> setIntervalsMap;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ...setIntervalsMap.entries.map(
          (MapEntry<DistanceInterval, PuttingSetInterval> entry) {
            final DistanceInterval interval = entry.key;
            return _barChartRow(
              context,
              '${interval.lowerBound}-${interval.upperBound} ft',
              entry.value.setsPercentage,
              entry.value.sets.length,
            );
          },
        )
      ],
    );
  }

  Widget _barChartRow(
    BuildContext context,
    String label,
    double percentage,
    int numSets,
  ) {
    return Row(
      children: [
        Container(
          margin: const EdgeInsets.only(right: 8),
          alignment: Alignment.centerLeft,
          width: 72,
          height: 48,
          child: Text(
            label,
            style: Theme.of(context)
                .textTheme
                .titleSmall
                ?.copyWith(fontWeight: FontWeight.w600),
          ),
        ),
        Expanded(child: HorizontalBarChartBar(percentage: percentage)),
        Container(
          alignment: Alignment.centerRight,
          width: 48,
          child: Text(
            '${numSets == 0 ? '--' : (percentage * 100).toInt()}%',
            style: Theme.of(context)
                .textTheme
                .bodyLarge
                ?.copyWith(fontWeight: FontWeight.w500),
          ),
        )
      ],
    );
  }
}
