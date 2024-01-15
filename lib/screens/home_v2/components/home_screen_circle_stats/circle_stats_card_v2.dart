import 'package:flutter/material.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';
import 'package:myputt/models/data/sessions/putting_set.dart';
import 'package:myputt/models/data/stats/sets_interval.dart';
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

    return Bounceable(
      onTap: () {
        Vibrate.feedback(FeedbackType.light);
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => CircleStatsScreen(
              circle: circle,
              intervalToPuttingSetsData: intervalToPuttingSetsData,
            ),
          ),
        );
      },
      child: Container(
        padding:
            const EdgeInsets.only(top: 12, bottom: 12, left: 20, right: 20),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.background,
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
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                    child: Column(
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
                      style:
                          Theme.of(context).textTheme.headlineMedium?.copyWith(
                                fontWeight: FontWeight.w800,
                              ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      allSetsInCircle.isEmpty
                          ? '--'
                          : '${(SetHelpers.percentageFromSets(allSetsInCircle) * 100).toInt()}% made',
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            color: MyPuttColors.green,
                            fontWeight: FontWeight.bold,
                          ),
                    )
                  ],
                )),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
