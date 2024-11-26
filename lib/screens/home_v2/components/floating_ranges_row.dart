import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';
import 'package:myputt/components/misc/spaced_row.dart';
import 'package:myputt/cubits/home/home_screen_v2_cubit.dart';
import 'package:myputt/utils/colors.dart';
import 'package:myputt/utils/constants.dart';

class FloatingRangesRow extends StatelessWidget {
  const FloatingRangesRow({Key? key}) : super(key: key);

  static const bool isDarkMode = true;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: BlocBuilder<HomeScreenV2Cubit, HomeScreenV2State>(
        builder: (context, state) {
          int selectedTimeRange = TimeRange.allTime;

          if (state is HomeScreenV2Loaded) {
            selectedTimeRange = state.timeRange;
          }
          return Container(
            height: 56,
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            decoration: BoxDecoration(
                color: isDarkMode
                    ? MyPuttColors.gray[800]
                    : MyPuttColors.gray[100],
                borderRadius: BorderRadius.circular(56),
                border: Border(
                  top: BorderSide(
                      color: MyPuttColors.gray[isDarkMode ? 700 : 100]!),
                ),
                boxShadow: [
                  BoxShadow(
                    blurRadius: 12,
                    offset: const Offset(0, 12),
                    color: MyPuttColors.black.withOpacity(0.15),
                  ),
                ]),
            child: SpacedRow(
              runSpacing: 8,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              mainAxisSize: MainAxisSize.min,
              children: kIndexToTimeRange.values
                  .map(
                    (range) => FloatingSelectionChip(
                      label: range == TimeRange.allTime
                          ? 'All time'
                          : 'Last $range',
                      onPressed: () {
                        BlocProvider.of<HomeScreenV2Cubit>(context)
                            .updateTimeRange(range);
                      },
                      isSelected: range == selectedTimeRange,
                      isDarkMode: isDarkMode,
                    ),
                  )
                  .toList(),
            ),
          );
        },
      ),
    );
  }
}

class FloatingSelectionChip extends StatelessWidget {
  const FloatingSelectionChip({
    Key? key,
    required this.label,
    required this.isSelected,
    required this.onPressed,
    this.isDarkMode = false,
  }) : super(key: key);

  final String label;
  final bool isSelected;
  final Function onPressed;
  final bool isDarkMode;

  @override
  Widget build(BuildContext context) {
    return Bounceable(
      onTap: () {
        Vibrate.feedback(FeedbackType.light);
        onPressed();
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: _getBackgroundColor(),
          borderRadius: BorderRadius.circular(32),
        ),
        child: Text(
          label,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: _getTextColor(),
                fontWeight: FontWeight.bold,
              ),
        ),
      ),
    );
  }

  Color? _getTextColor() {
    if (isDarkMode) {
      return MyPuttColors.white;
    } else {
      return isSelected ? MyPuttColors.gray[600] : MyPuttColors.gray[400];
    }
  }

  Color? _getBackgroundColor() {
    if (isDarkMode) {
      return isSelected ? MyPuttColors.gray[600] : MyPuttColors.gray[800];
    } else {
      return isSelected ? MyPuttColors.gray[200] : MyPuttColors.gray[100];
    }
  }
}
