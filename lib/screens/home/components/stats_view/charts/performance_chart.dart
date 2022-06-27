import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import 'package:myputt/models/data/chart/chart_point.dart';
import 'package:myputt/utils/colors.dart';

class PerformanceChart extends StatelessWidget {
  const PerformanceChart({Key? key, required this.data}) : super(key: key);

  final PerformanceChartData data;

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.all(5),
        height: 250,
        child: LineChart(mainData(context, data)));
  }

  LineChartData mainData(BuildContext context, PerformanceChartData chartData) {
    return LineChartData(
      lineTouchData: LineTouchData(
        enabled: true,
        touchTooltipData: LineTouchTooltipData(
          tooltipRoundedRadius: 16,
          fitInsideHorizontally: true,
          fitInsideVertically: true,
          showOnTopOfTheChartBoxArea: true,
          tooltipBgColor: Colors.grey[100],
          getTooltipItems: (List<LineBarSpot> touchedBarSpots) {
            return touchedBarSpots.map((barSpot) {
              final flSpot = barSpot;
              final ChartPoint point = chartData.points[flSpot.x.toInt()];
              return LineTooltipItem(
                '${DateFormat.yMMMd('en_US').format(DateTime.fromMillisecondsSinceEpoch(point.timeStamp))}\n${double.parse((point.decimal * 100).toStringAsFixed(4))} %',
                Theme.of(context).textTheme.bodySmall!.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
              );
            }).toList();
          },
        ),
      ),
      clipData: FlClipData(bottom: true, left: true, top: true, right: true),
      axisTitleData: FlAxisTitleData(
        leftTitle: AxisTitle(
          margin: 0,
          textAlign: TextAlign.center,
          showTitle: false,
          titleText: '%',
        ),
      ),
      gridData: FlGridData(
        show: true,
        drawHorizontalLine: true,
        horizontalInterval: 20,
        drawVerticalLine: false,
      ),
      titlesData: LineTitles.getTitleData(),
      borderData: FlBorderData(show: false),
      minX: 0,
      maxX: chartData.points.length.toDouble() - 1,
      minY: 0,
      maxY: 105,
      lineBarsData: [
        LineChartBarData(
          spots: chartData.points
              .asMap()
              .entries
              .map((entry) => FlSpot(entry.key.toDouble(),
                  double.parse((entry.value.decimal * 100).toStringAsFixed(4))))
              .toList(),
          isCurved: true,
          curveSmoothness: 0.1,
          colors: [MyPuttColors.darkBlue],
          barWidth: 3,
          isStrokeCapRound: true,
          dotData: FlDotData(show: false),
        ),
      ],
    );
  }
}

class LineTitles {
  static getTitleData() => FlTitlesData(
      topTitles: SideTitles(showTitles: false),
      bottomTitles: SideTitles(
        showTitles: false,
      ),
      leftTitles: SideTitles(
          showTitles: false,
          getTextStyles: (value, context) => const TextStyle(
                fontSize: 10,
              ),
          getTitles: (value) {
            switch (value.toInt()) {
              case 0:
                return '0';
              case 50:
                return '50';
              case 100:
                return '100';
              default:
                return '';
            }
          }),
      rightTitles: SideTitles(showTitles: false));
}
