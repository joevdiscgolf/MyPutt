import 'package:flutter/material.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';
import 'package:myputt/components/bars/bar_chart.dart';
import 'package:myputt/models/data/sessions/putting_set.dart';
import 'package:myputt/models/data/stats/sets_interval.dart';
import 'package:myputt/screens/home_v2/screens/circle_stats_screen/circle_stats_screen.dart';
import 'package:myputt/utils/colors.dart';
import 'package:myputt/utils/constants.dart';
import 'package:myputt/utils/distance_helpers.dart';
import 'package:myputt/utils/enums.dart';
import 'package:myputt/utils/layout_helpers.dart';
import 'package:myputt/utils/set_helpers.dart';

class CircleStatsCard extends StatelessWidget {
  const CircleStatsCard(
      {Key? key, required this.circle, required this.intervalToPuttingSetsData})
      : super(key: key);

  final PuttingCircle circle;
  final Map<DistanceInterval, PuttingSetInterval> intervalToPuttingSetsData;

  @override
  Widget build(BuildContext context) {
    DistanceHelpers.getPrimaryDistanceInterval({});
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
        height: 124,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: MyPuttColors.gray[50],
          boxShadow: standardBoxShadow(),
        ),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        kCircleToNameMap[circle] ?? '',
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                              color: MyPuttColors.gray[400],
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${allSetsInCircle.isEmpty ? '--' : (SetHelpers.percentageFromSets(allSetsInCircle) * 100).toInt()}%',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              color: MyPuttColors.blue,
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  FlutterRemix.arrow_right_s_line,
                  color: MyPuttColors.gray[400],
                )
              ],
            ),
            const SizedBox(height: 16),
            Expanded(child: _barsRow(context)),
          ],
        ),
      ),
    );
  }

  Widget _barsRow(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: intervalToPuttingSetsData.values
          .map(
        (setInterval) =>
            setInterval.sets.isEmpty ? null : setInterval.setsPercentage,
      )
          .map((percentage) {
        return Expanded(child: VerticalBarChartBar(percentage: percentage));
      }).toList(),
    );
  }
}
