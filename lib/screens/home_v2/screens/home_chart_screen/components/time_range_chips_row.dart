import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myputt/components/misc/spaced_row.dart';
import 'package:myputt/cubits/home/home_screen_v2_cubit.dart';
import 'package:myputt/screens/home_v2/screens/home_chart_screen/components/time_range_chip.dart';
import 'package:myputt/utils/constants.dart';

class TimeRangeChipsRow extends StatelessWidget {
  const TimeRangeChipsRow({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeScreenV2Cubit, HomeScreenV2State>(
      builder: (context, state) {
        int selectedTimeRange = TimeRange.allTime;

        if (state is HomeScreenV2Loaded) {
          selectedTimeRange = state.timeRange;
        }
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: SpacedRow(
            children: indexToTimeRange.values
                .map(
                  (range) => Expanded(
                    child: TimeRangeChip(
                      range: range,
                      isSelected: range == selectedTimeRange,
                    ),
                  ),
                )
                .toList(),
          ),
        );
      },
    );
  }
}
