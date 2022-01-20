import 'package:flutter/material.dart';
import './percentage_row.dart';

class PercentagesCard extends StatelessWidget {
  const PercentagesCard({Key? key, required this.percentages})
      : super(key: key);
  final Map<int, double> percentages;

  @override
  Widget build(BuildContext context) {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: percentages.entries
            .map((entry) =>
                PercentageRow(distance: entry.key, percentage: entry.value))
            .toList());
  }
}
