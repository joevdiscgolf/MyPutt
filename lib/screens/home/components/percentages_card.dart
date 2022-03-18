import 'package:flutter/material.dart';
import 'package:myputt/data/types/putting_session.dart';
import 'package:myputt/screens/home/components/rows/putting_stat_row.dart';
import 'package:myputt/utils/colors.dart';
import 'package:myputt/utils/constants.dart';
import 'package:myputt/utils/enums.dart';

class PercentagesCard extends StatelessWidget {
  const PercentagesCard(
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

  @override
  Widget build(BuildContext context) {
    List<int> distancesInOrder = [];

    for (MapEntry entry in percentages.entries) {
      if (entry.value != null) {
        distancesInOrder.add(entry.key);
      }
    }

    for (MapEntry entry in percentages.entries) {
      if (!distancesInOrder.contains(entry.key)) {
        distancesInOrder.add(entry.key);
      }
    }

    List<PuttingStatRow> children = distancesInOrder
        .asMap()
        .entries
        .map((MapEntry entry) => PuttingStatRow(
              distance: entry.value,
              allTimePercentage: allTimePercentages[entry.value],
              percentage: percentages[entry.value],
              backgroundColor: entry.key % 2 == 0
                  ? MyPuttColors.white
                  : MyPuttColors.gray[50]!,
            ))
        .toList();

    return ListView(
      children: children,
    );
  }
}
