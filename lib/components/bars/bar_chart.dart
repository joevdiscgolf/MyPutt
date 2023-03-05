import 'package:flutter/material.dart';
import 'package:myputt/utils/colors.dart';
import 'package:myputt/utils/layout_helpers.dart';

class VerticalBarChartBar extends StatelessWidget {
  const VerticalBarChartBar({Key? key, required this.percentage})
      : super(key: key);

  final double? percentage;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        Container(
          width: 8,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            color: MyPuttColors.gray[100],
          ),
        ),
        if (percentage != null)
          FractionallySizedBox(
            heightFactor: percentage!,
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 4),
              width: 8,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                color: MyPuttColors.blue,
                boxShadow: standardBoxShadow(),
              ),
            ),
          ),
      ],
    );
  }
}

class HorizontalBarChartBar extends StatelessWidget {
  const HorizontalBarChartBar({Key? key, required this.percentage})
      : super(key: key);

  final double? percentage;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.centerLeft,
      child: Stack(
        children: [
          Align(
            child: Container(
              height: 8,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                color: MyPuttColors.gray[50],
              ),
            ),
          ),
          FractionallySizedBox(
            widthFactor: percentage,
            child: Align(
              child: Container(
                height: 8,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                  color: percentage != null
                      ? MyPuttColors.blue
                      : MyPuttColors.gray[100],
                  boxShadow: percentage != null ? standardBoxShadow() : null,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
