import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';
import 'package:myputt/cubits/home/home_screen_v2_cubit.dart';
import 'package:myputt/models/data/stats/sets_interval.dart';
import 'package:myputt/utils/colors.dart';
import 'package:myputt/utils/layout_helpers.dart';

class DistanceIntervalChip extends StatelessWidget {
  const DistanceIntervalChip({
    Key? key,
    required this.distanceInterval,
    required this.isSelected,
  }) : super(key: key);

  final DistanceInterval distanceInterval;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return Bounceable(
      onTap: () {
        Vibrate.feedback(FeedbackType.light);
        BlocProvider.of<HomeScreenV2Cubit>(context)
            .updateDistanceInterval(distanceInterval);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        decoration: BoxDecoration(
          color: isSelected ? MyPuttColors.gray[50] : MyPuttColors.white,
          borderRadius: BorderRadius.circular(40),
          boxShadow: standardBoxShadow(),
        ),
        child: Text(
          distanceInterval.toString(),
          style: Theme.of(context)
              .textTheme
              .bodyLarge
              ?.copyWith(color: MyPuttColors.gray[isSelected ? 800 : 400]),
        ),
      ),
    );
  }
}
