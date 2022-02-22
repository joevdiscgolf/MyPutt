import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:myputt/data/types/chart/chart_point.dart';

class PerformanceChart extends StatelessWidget {
  const PerformanceChart({Key? key, required this.data}) : super(key: key);

  final PerformanceChartData data;

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.all(10),
        margin: const EdgeInsets.all(10),
        height: 150,
        child: LineChart(mainData(context, data)));
  }

  LineChartData mainData(BuildContext context, PerformanceChartData chartData) {
    return LineChartData(
      clipData: FlClipData(bottom: true, left: true, top: true, right: true),
      axisTitleData: FlAxisTitleData(
          leftTitle: AxisTitle(
              margin: 5,
              textAlign: TextAlign.center,
              showTitle: true,
              titleText: 'Percentage (%)',
              textStyle: Theme.of(context).textTheme.headline6)),
      gridData:
          FlGridData(show: true, verticalInterval: 10, horizontalInterval: 20),
      titlesData: FlTitlesData(show: false),
      borderData: FlBorderData(show: true),
      minX: 0,
      maxX: chartData.points.length.toDouble() - 1,
      minY: 0,
      maxY: 105,
      lineBarsData: [
        LineChartBarData(
          spots: chartData.points
              .asMap()
              .entries
              .map((entry) =>
                  FlSpot(entry.key.toDouble(), entry.value.decimal * 100))
              .toList(),
          isCurved: true,
          colors: [Colors.blue],
          barWidth: 2,
          isStrokeCapRound: true,
          dotData: FlDotData(show: false),
          belowBarData: BarAreaData(
            show: false,
            colors: [Colors.blue].map((color) => color.withOpacity(1)).toList(),
          ),
        ),
      ],
    );
  }
}
