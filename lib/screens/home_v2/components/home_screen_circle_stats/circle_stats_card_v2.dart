import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';
import 'package:myputt/cubits/home/home_screen_cubit.dart';
import 'package:myputt/models/data/sessions/putting_set.dart';
import 'package:myputt/models/data/stats/sets_interval.dart';
import 'package:myputt/screens/home_v2/components/home_screen_circle_stats/circle_radial_diagram.dart';
import 'package:myputt/screens/home_v2/screens/circle_stats_screen/circle_stats_screen.dart';
import 'package:myputt/utils/colors.dart';
import 'package:myputt/utils/constants.dart';
import 'package:myputt/utils/constants/distance_constants.dart';
import 'package:myputt/utils/enums.dart';
import 'package:myputt/utils/set_helpers.dart';

class CircleStatsCardV2 extends StatelessWidget {
  const CircleStatsCardV2({
    super.key,
    required this.circle,
    required this.intervalToPuttingSetsData,
  });

  final PuttingCircle circle;
  final Map<DistanceInterval, PuttingSetInterval> intervalToPuttingSetsData;

  @override
  Widget build(BuildContext context) {
    final List<int> circleDistanceIntervals =
        kCircleToDistanceIntervals[circle]!;
    final List<PuttingSet> allSetsInCircle =
        SetHelpers.getPuttingSetsFromIntervals(intervalToPuttingSetsData);
    final double percentageForCircle =
        SetHelpers.percentageFromSets(allSetsInCircle);

    return Bounceable(
      onTap: () {
        Vibrate.feedback(FeedbackType.light);
        BlocProvider.of<HomeScreenCubit>(context).updateSelectedCircle(circle);
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => CircleStatsScreen(
              circle: circle,
              intervalToPuttingSetsData: intervalToPuttingSetsData,
              percentageForCircle: percentageForCircle,
              numSetsInCircle: allSetsInCircle.length,
            ),
          ),
        );
      },
      child: Container(
        height: 120,
        padding: const EdgeInsets.only(
          top: 12,
          bottom: 12,
          left: 20,
          right: 12,
        ),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: MyPuttColors.gray[100]!, width: 1),
          boxShadow: [
            BoxShadow(
              color: MyPuttColors.black.withOpacity(0.1),
              blurRadius: 20,
              offset: const Offset(0, 12),
            )
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    kCircleToNameMap[circle] ?? '',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: MyPuttColors.gray[400],
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '${circleDistanceIntervals.first}-${circleDistanceIntervals.last} ft',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.w800,
                        ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    allSetsInCircle.isEmpty
                        ? '--'
                        : '${(percentageForCircle * 100).toInt()}% made',
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          color: MyPuttColors.green,
                          fontWeight: FontWeight.bold,
                        ),
                  )
                ],
              ),
            ),
            CircleRadialDiagram(selectedCircle: circle),
            const SizedBox(width: 8),
            Align(
              alignment: Alignment.centerRight,
              child: Icon(
                Icons.chevron_right,
                color: MyPuttColors.gray[300],
                size: 24,
              ),
            )
          ],
        ),
      ),
    );
  }
}
