import 'package:flutter/material.dart';
import 'package:myputt/components/charts/generic_performance_chart/constants.dart';
import 'package:myputt/components/lines/dashed_line.dart';
import 'package:myputt/utils/colors.dart';

class GenericChartGridLines extends StatelessWidget {
  const GenericChartGridLines({super.key, required this.height});

  final double height;

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width - kAxisLabelsWidth;
    return SizedBox(
      height: height,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          DashedLine(
            height: 1,
            color: MyPuttColors.gray[100]!,
            width: width,
          ),
          DashedLine(
            height: 1,
            color: MyPuttColors.gray[100]!,
            width: width,
          ),
        ],
      ),
    );
  }
}
