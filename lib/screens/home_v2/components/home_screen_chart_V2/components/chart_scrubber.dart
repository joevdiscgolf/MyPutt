import 'package:flutter/material.dart';
import 'package:myputt/components/lines/custom_line.dart';
import 'package:myputt/screens/home_v2/components/home_screen_chart_V2/components/scrubber_label.dart';
import 'package:myputt/utils/colors.dart';

class ChartScrubber extends StatelessWidget {
  const ChartScrubber({
    Key? key,
    required this.crossHairOffset,
    required this.dateScrubberOffset,
    required this.chartHeight,
    required this.dateLabel,
    this.noData,
    required this.percentage,
    required this.labelHorizontalOffset,
  }) : super(key: key);

  final double chartHeight;
  final Offset crossHairOffset;
  final Offset dateScrubberOffset;
  final String dateLabel;
  final bool? noData;
  final double percentage;
  final double labelHorizontalOffset;

  static const double _dotSize = 8;

  @override
  Widget build(BuildContext context) {
    final double lineHeight = chartHeight * percentage;
    return Container(
      color: Colors.transparent,
      height: chartHeight,
      width: double.infinity,
      child: Stack(
        alignment: Alignment.topLeft,
        children: [
          Transform.translate(
            offset: Offset(crossHairOffset.dx, 0),
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
                  height: chartHeight * percentage,
                ),
                Transform.translate(
                  offset: Offset(
                    -_dotSize / 2,
                    lineHeight - _dotSize,
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
          // Transform.translate(
          //   offset: Offset(
          //     crosshairOffset.dx - _dotSize / 2,
          //     crosshairOffset.dy + _dotSize / 2,
          //   ),
          //   child: Container(
          //     height: _dotSize,
          //     width: _dotSize,
          //     decoration: const BoxDecoration(
          //       shape: BoxShape.circle,
          //       color: Color(0xffD1E8FF),
          //     ),
          //   ),
          // )
        ],
      ),
    );
  }
}
