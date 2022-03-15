import 'package:flutter/material.dart';
import 'package:myputt/data/types/putting_session.dart';
import 'package:myputt/screens/home/components/rows/putting_stat_row.dart';
import 'package:myputt/services/stats_service.dart';
import 'package:myputt/locator.dart';
import 'package:myputt/utils/constants.dart';
import 'package:myputt/utils/enums.dart';

class PercentagesCard extends StatelessWidget {
  PercentagesCard(
      {Key? key,
      this.allSessions = const [],
      this.timeRange = TimeRange.allTime,
      required this.percentages,
      required this.allTimePercentages,
      this.circle})
      : super(key: key);

  final List<PuttingSession> allSessions;
  final int timeRange;
  final Circles? circle;
  final Map<int, num?> percentages;
  final Map<int, num?> allTimePercentages;
  final StatsService _statsService = locator.get<StatsService>();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Flexible(
          fit: FlexFit.loose,
          child: ListView(
              children: percentages.entries
                  .map((entry) => Builder(builder: (context) {
                        final points =
                            _statsService.getPointsWithDistanceAndLimit(
                                allSessions, [], entry.key, timeRange);
                        return Column(
                          children: [
                            Divider(
                              thickness: 2,
                              color: Colors.grey[100]!,
                            ),
                            PuttingStatRow(
                                chartPoints: points,
                                distance: entry.key,
                                percentage: entry.value,
                                allTimePercentage:
                                    allTimePercentages[entry.key] ?? 0.5),
                            if (entry.key == 30 || entry.key == 60)
                              Divider(thickness: 2, color: Colors.grey[100]!),
                          ],
                        );
                      }))
                  .toList()),
        ),
      ],
    );
  }
}
