import 'package:flutter/material.dart';
import 'package:myputt/components/bars/bar_chart.dart';
import 'package:myputt/models/data/stats/sets_interval.dart';
import 'package:myputt/utils/colors.dart';
import 'package:myputt/utils/enums.dart';

class CirclePercentagesScreenBarChart extends StatelessWidget {
  const CirclePercentagesScreenBarChart(
      {Key? key, required this.circle, required this.setIntervals})
      : super(key: key);

  final Circles circle;
  final List<PuttingSetsInterval> setIntervals;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Percentages',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: MyPuttColors.gray[400],
                ),
          ),
          const SizedBox(height: 12),
          ...setIntervals.map(
            (interval) => _barChartRow(
              context,
              '${interval.lowerBound}-${interval.upperBound} ft',
              interval.setsPercentage,
            ),
          )
        ],
      ),
    );
  }

  Widget _barChartRow(BuildContext context, String label, double percentage) {
    return Row(
      children: [
        Container(
          margin: const EdgeInsets.only(right: 8),
          alignment: Alignment.centerLeft,
          width: 64,
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
      ],
    );
  }
}
