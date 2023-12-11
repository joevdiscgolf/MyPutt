import 'dart:math' as math;
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:myputt/components/charts/components/chart_scrubber.dart';
import 'package:myputt/cubits/home/home_screen_v2_cubit.dart';
import 'package:myputt/models/data/chart/chart_point.dart';
import 'package:myputt/utils/colors.dart';

class GenericPerformanceChart extends StatelessWidget {
  const GenericPerformanceChart({
    Key? key,
    required this.points,
    this.height = 200,
    required this.screenWidth,
    this.noData = false,
    this.chartDragData,
    this.onTapDown,
    this.onTapUp,
    this.onHorizontalDragStart,
    this.onHorizontalDragUpdate,
    this.onHorizontalDragEnd,
    this.onTap,
  }) : super(key: key);

  final List<ChartPoint> points;
  final double height;
  final double screenWidth;
  final bool noData;

  final ChartDragData? chartDragData;

  final Function? onTap;
  final Function(TapDownDetails)? onTapDown;
  final Function(TapUpDetails)? onTapUp;
  final Function(DragStartDetails)? onHorizontalDragStart;
  final Function(DragUpdateDetails)? onHorizontalDragUpdate;
  final Function(DragEndDetails)? onHorizontalDragEnd;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: Stack(
        children: [
          SizedBox(height: height, child: _mainLayer(context)),
          if (chartDragData != null) _scrubberLayer(),
          _gestureDetectorLayer(),
        ],
      ),
    );
  }

  Widget _mainLayer(BuildContext context) {
    if (noData) {
      return Container(
        alignment: Alignment.center,
        child: const Text('No data'),
      );
    } else if (points.isEmpty) {
      return Container(
        alignment: Alignment.center,
        child: const Text('No sets match those filters'),
      );
    } else {
      return LineChart(
        _mainData(context, points),
        duration: const Duration(milliseconds: 0),
      );
    }
  }

  Widget _gestureDetectorLayer() {
    return SizedBox(
      height: height,
      width: screenWidth,
      child: Align(
        alignment: Alignment.topLeft,
        child: GestureDetector(
          onTap: () {
            if (onTap != null) {
              onTap!();
            }
          },
          onTapDown: onTapDown,
          onTapUp: onTapUp,
          onHorizontalDragStart: onHorizontalDragStart,
          onHorizontalDragUpdate: onHorizontalDragUpdate,
          onHorizontalDragEnd: onHorizontalDragEnd,
        ),
      ),
    );
  }

  Widget _scrubberLayer() {
    return ChartScrubber(
      crossHairOffset: chartDragData!.crossHairOffset ?? const Offset(0, 0),
      labelHorizontalOffset: chartDragData!.labelHorizontalOffset ?? 0,
      chartHeight: height,
      dateLabel: chartDragData!.draggedDate != null
          ? DateFormat.yMMMd('en_US').format(chartDragData!.draggedDate!)
          : '',
      percentage: chartDragData!.draggedValue ?? 0,
    );
  }

  LineChartData _mainData(BuildContext context, List<ChartPoint> points) {
    return LineChartData(
      lineTouchData: const LineTouchData(enabled: false),
      gridData: const FlGridData(show: false),
      titlesData: const FlTitlesData(show: false),
      borderData: FlBorderData(show: false),
      minX: 0,
      maxX: points.length.toDouble() - 1,
      minY: 0,
      maxY: 105,
      lineBarsData: [
        LineChartBarData(
          belowBarData: BarAreaData(
            show: true,
            gradient: LinearGradient(
              transform: const GradientRotation(3 * math.pi / 2),
              colors: [
                MyPuttColors.blue.withOpacity(0.0),
                MyPuttColors.blue.withOpacity(0.0),
                MyPuttColors.blue.withOpacity(0.2),
                MyPuttColors.blue.withOpacity(0.8),
              ],
            ),
          ),
          spots: points
              .asMap()
              .entries
              .map((entry) => FlSpot(entry.key.toDouble(),
                  double.parse((entry.value.decimal * 100).toStringAsFixed(4))))
              .toList(),
          isCurved: true,
          curveSmoothness: 0.2,
          color: MyPuttColors.darkBlue,
          barWidth: 3,
          isStrokeCapRound: true,
          dotData: const FlDotData(show: false),
        ),
      ],
    );
  }
}
