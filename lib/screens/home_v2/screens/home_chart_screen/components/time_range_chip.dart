import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';
import 'package:myputt/cubits/home/home_screen_v2_cubit.dart';
import 'package:myputt/utils/colors.dart';
import 'package:myputt/utils/layout_helpers.dart';

class TimeRangeChip extends StatelessWidget {
  const TimeRangeChip({
    Key? key,
    required this.range,
    required this.isSelected,
  }) : super(key: key);

  final int range;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return Bounceable(
      onTap: () {
        Vibrate.feedback(FeedbackType.light);
        BlocProvider.of<HomeScreenV2Cubit>(context).updateTimeRange(range);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isSelected ? MyPuttColors.gray[50] : MyPuttColors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: standardBoxShadow(),
        ),
        child: Text(
          _getTitle(),
          style: Theme.of(context)
              .textTheme
              .titleSmall
              ?.copyWith(color: MyPuttColors.gray[isSelected ? 800 : 400]),
        ),
      ),
    );
  }

  String _getTitle() {
    if (range == 0) {
      return 'All time';
    } else {
      return 'Last $range';
    }
  }
}
