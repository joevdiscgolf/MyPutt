import 'package:flutter/material.dart';
import 'package:myputt/components/lines/custom_line.dart';
import 'package:myputt/screens/home_v2/components/home_screen_chart_V2/components/scrubber_label.dart';
import 'package:myputt/utils/colors.dart';

class ChartScrubber extends StatelessWidget {
  const ChartScrubber({
    Key? key,
    required this.crossHairOffset,
    required this.chartHeight,
    required this.dateLabel,
    this.noData,
    required this.percentage,
    required this.labelHorizontalOffset,
  }) : super(key: key);

  final double chartHeight;
  final Offset crossHairOffset;
  final String dateLabel;
  final bool? noData;
  final double percentage;
  final double labelHorizontalOffset;

  static const double _dotSize = 8;
  static const double _chartScrubberVerticalPadding = 8;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      height: chartHeight,
      width: double.infinity,
      child: Stack(
        alignment: Alignment.topLeft,
        children: [
          Transform.translate(
            offset: Offset(crossHairOffset.dx, -_chartScrubberVerticalPadding),
            child: Stack(
              alignment: Alignment.topLeft,
              children: [
                ScrubberLabel(
                  dateLabel: dateLabel,
                  percentage: percentage,
                  horizontalOffset: labelHorizontalOffset,
                ),
                CustomLine(
                  color: MyPuttColors.gray[800]!,
                  height: chartHeight * (1 - percentage) +
                      (_dotSize / 2) +
                      _chartScrubberVerticalPadding,
                ),
                Transform.translate(
                  offset: Offset(
                    -_dotSize / 2,
                    chartHeight * (1 - percentage) +
                        (_dotSize / 2) +
                        _chartScrubberVerticalPadding,
                  ),
                  child: Container(
                    height: _dotSize,
                    width: _dotSize,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color(0xffD1E8FF),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
