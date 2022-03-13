import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';
import 'package:myputt/data/types/chart/chart_point.dart';
import 'package:myputt/utils/colors.dart';

class LineChartPreview extends StatelessWidget {
  const LineChartPreview({
    Key? key,
    required this.data,
    this.width = 80,
  }) : super(key: key);

  final PerformanceChartData data;
  final double width;

  @override
  Widget build(BuildContext context) {
    final bool overallIncrease = data.points.isEmpty
        ? false
        : data.points.first.decimal < data.points.last.decimal;
    // final List<Color> colors = overallIncrease
    //     ? const [MyPuttColors.lightGreen, MyPuttColors.lightBlue]
    //     : const [Colors.orange, Colors.red];
    const List<Color> colors = [
      MyPuttColors.lightGreen,
      MyPuttColors.lightBlue
    ];
    return Bounceable(
      onTap: () {
        Vibrate.feedback(FeedbackType.light);
      },
      child: SizedBox(
        height: 100,
        width: width,
        child: LineChart(
          LineChartData(
            borderData: FlBorderData(show: false),
            titlesData: FlTitlesData(show: false),
            gridData: FlGridData(show: false),
            minX: 0,
            maxX: data.points.length.toDouble() - 1,
            minY: 0,
            maxY: 105,
            lineTouchData: LineTouchData(enabled: false),
            lineBarsData: [
              LineChartBarData(
                curveSmoothness: 0.3,
                spots: data.points
                    .asMap()
                    .entries
                    .map((entry) => FlSpot(
                        entry.key.toDouble(),
                        double.parse(
                            (entry.value.decimal * 100).toStringAsFixed(4))))
                    .toList(),
                isCurved: true,
                colors: colors,
                barWidth: 2,
                isStrokeCapRound: true,
                dotData: FlDotData(show: false),
                belowBarData: BarAreaData(
                  show: true,
                  colors:
                      colors.map((color) => color.withOpacity(0.3)).toList(),
                ),
              ),
            ],
          ),
          swapAnimationDuration: const Duration(milliseconds: 500),
          swapAnimationCurve: Curves.decelerate,
        ),
      ),
    );
  }
}
