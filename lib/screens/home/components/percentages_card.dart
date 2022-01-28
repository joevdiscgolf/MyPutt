import 'package:flutter/material.dart';
import './percentage_row.dart';
import 'package:myputt/screens/home/components/enums.dart';

class PercentagesCard extends StatelessWidget {
  const PercentagesCard(
      {Key? key,
      required this.percentages,
      required this.allTimePercentages,
      this.circle})
      : super(key: key);

  final Circles? circle;
  final Map<int, num?> percentages;
  final Map<int, num?> allTimePercentages;

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
                        return entry.key == 30 || entry.key == 60
                            ? Column(
                                children: [
                                  Divider(
                                    thickness: 2,
                                    color: Colors.grey[100]!,
                                  ),
                                  PercentageRow(
                                      distance: entry.key,
                                      percentage: entry.value,
                                      allTimePercentage:
                                          allTimePercentages[entry.key] ?? 0.5),
                                  Divider(
                                      thickness: 2, color: Colors.grey[100]!),
                                ],
                              )
                            : Column(
                                children: [
                                  Divider(
                                      thickness: 2, color: Colors.grey[100]!),
                                  PercentageRow(
                                      distance: entry.key,
                                      percentage: entry.value,
                                      allTimePercentage:
                                          allTimePercentages[entry.key] ?? 0.5),
                                ],
                              );
                      }))
                  .toList()),
        ),
      ],
    );
  }
}
