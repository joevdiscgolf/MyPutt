import 'package:flutter/material.dart';
import 'package:myputt/components/charts/generic_performance_chart/constants.dart';
import 'package:myputt/utils/colors.dart';

class GenericChartAxisLabels extends StatelessWidget {
  const GenericChartAxisLabels({super.key, required this.height});

  final double height;

  @override
  Widget build(BuildContext context) {
    final double textHeight =
        (Theme.of(context).textTheme.bodyMedium?.height ?? 0) *
            (Theme.of(context).textTheme.bodyMedium?.fontSize ?? 0);
    return Container(
      padding: const EdgeInsets.only(left: 4, right: 8),
      height: height,
      width: kAxisLabelsWidth,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Transform.translate(
            offset: Offset(0, -textHeight / 2),
            child: Text(
              '100%',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: MyPuttColors.gray[300],
                  ),
            ),
          ),
          Transform.translate(
            offset: Offset(0, textHeight / 2),
            child: Text(
              '0%',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: MyPuttColors.gray[300],
                  ),
            ),
          ),
        ],
      ),
    );
  }
}
