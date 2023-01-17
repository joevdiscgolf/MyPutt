import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:myputt/components/misc/sized_vertical_divider.dart';
import 'package:myputt/models/data/stats/stats.dart';
import 'package:myputt/screens/sessions/components/percentage_column.dart';
import 'colors.dart';

List<Widget> getPercentageColumnChildren(
  Stats stats,
) {
  List<Widget> children = [];

  final Map<int, num?>? c1Percentages = stats.circleOnePercentages;
  final Map<int, num?>? c2Percentages = stats.circleTwoPercentages;

  int entryIndex = 0;
  if (c1Percentages != null) {
    final List<MapEntry> c1FilteredEntries =
        c1Percentages.entries.where((entry) => entry.value != null).toList();
    for (MapEntry entry in c1FilteredEntries) {
      if (entryIndex > 0) {
        children.add(SizedVerticalDivider(color: MyPuttColors.gray[200]!));
      }
      if (entry.value != null) {
        children.add(PercentageColumn(
          distance: entry.key,
          decimal: entry.value,
          size: 30,
        ));
      }

      entryIndex += 1;
    }
  }

  entryIndex = 0;
  if (c2Percentages != null) {
    final List<MapEntry> c2FilteredEntries =
        c2Percentages.entries.where((entry) => entry.value != null).toList();
    for (MapEntry entry in c2FilteredEntries) {
      if (entryIndex > 0) {
        children.add(SizedVerticalDivider(color: MyPuttColors.gray[200]!));
      }

      children.add(PercentageColumn(
        distance: entry.key,
        decimal: entry.value,
        size: 30,
      ));

      entryIndex += 1;
    }
  }

  return children;
}
