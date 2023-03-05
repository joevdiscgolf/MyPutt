import 'package:flutter/material.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';
import 'package:myputt/components/lines/dashed_line.dart';
import 'package:myputt/models/data/sessions/putting_set.dart';
import 'package:myputt/models/data/stats/sets_interval.dart';
import 'package:myputt/utils/colors.dart';
import 'package:myputt/utils/enums.dart';
import 'package:myputt/utils/layout_helpers.dart';
import 'package:myputt/utils/set_helpers.dart';

class CircleStatsCard extends StatelessWidget {
  const CircleStatsCard(
      {Key? key, required this.circle, required this.setIntervals})
      : super(key: key);

  final Circles circle;
  final List<PuttingSetsInterval> setIntervals;

  @override
  Widget build(BuildContext context) {
    final List<PuttingSet> sets = getPuttingSetsFromIntervals(setIntervals);

    return Bounceable(
      onTap: () {
        Vibrate.feedback(FeedbackType.light);
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
                        circle == Circles.circle1 ? 'Circle 1' : 'Circle 2',
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                              color: MyPuttColors.gray[400],
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${(percentageFromSets(sets) * 100).toInt()}%',
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
    return Column(
      children: [
        Transform.translate(
          offset: const Offset(0, -12),
          child: DashedLine(
            height: 1,
            width: double.infinity,
            color: MyPuttColors.gray[100]!,
          ),
        ),
        Expanded(
          child: Align(
            alignment: Alignment.bottomCenter,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: setIntervals
                  .map((setInterval) => setInterval.sets.isEmpty
                      ? null
                      : percentageFromSets(setInterval.sets))
                  .map((value) => _bar(value))
                  .toList(),
            ),
          ),
        ),
      ],
    );
  }

  Widget _bar(double? percentage) {
    return FractionallySizedBox(
      heightFactor: percentage,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8),
        width: 8,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          color:
              percentage != null ? MyPuttColors.blue : MyPuttColors.gray[100],
          boxShadow: percentage != null ? standardBoxShadow() : null,
        ),
      ),
    );
  }
}
