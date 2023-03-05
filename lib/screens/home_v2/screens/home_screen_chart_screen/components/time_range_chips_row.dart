import 'package:flutter/material.dart';
import 'package:myputt/components/misc/spaced_row.dart';
import 'package:myputt/screens/home_v2/screens/home_screen_chart_screen/components/time_range_chip.dart';
import 'package:myputt/utils/constants.dart';

class TimeRangeChipsRow extends StatelessWidget {
  const TimeRangeChipsRow({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: SpacedRow(
        children: indexToTimeRange.values
            .map(
              (range) => Expanded(
                child: TimeRangeChip(
                  range: range,
                  isSelected: range == TimeRange.allTime,
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}
