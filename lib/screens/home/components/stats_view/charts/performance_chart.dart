import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import 'package:mixpanel_flutter/mixpanel_flutter.dart';
import 'package:myputt/locator.dart';
import 'package:myputt/models/data/chart/chart_point.dart';
import 'package:myputt/utils/colors.dart';

class PerformanceChart extends StatelessWidget {
  const PerformanceChart({Key? key, required this.points}) : super(key: key);

  final List<ChartPoint> points;

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.all(5),
        height: 250,
        child: LineChart(mainData(context, points)));
  }

  LineChartData mainData(BuildContext context, List<ChartPoint> points) {
    return LineChartData(
      lineTouchData: LineTouchData(
        touchCallback: (FlTouchEvent event, LineTouchResponse? response) {
          locator
              .get<Mixpanel>()
              .track('Home Screen Performance Chart Dragged');
        },
        enabled: true,
        touchTooltipData: LineTouchTooltipData(
          tooltipRoundedRadius: 16,
          fitInsideHorizontally: true,
          fitInsideVertically: true,
          showOnTopOfTheChartBoxArea: true,
          tooltipBgColor: Colors.grey[100]!,
          getTooltipItems: (List<LineBarSpot> touchedBarSpots) {
            return touchedBarSpots.map((barSpot) {
              final flSpot = barSpot;
              final ChartPoint point = points[flSpot.x.toInt()];
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
      clipData:
          const FlClipData(bottom: true, left: true, top: true, right: true),
      // axisTitleData: FlAxisTitleData(
      //   leftTitle: AxisTitle(
      //     margin: 0,
      //     textAlign: TextAlign.center,
      //     showTitle: false,
      //     titleText: '%',
      //   ),
      // ),
      gridData: const FlGridData(
        show: true,
        drawHorizontalLine: true,
        horizontalInterval: 20,
        drawVerticalLine: false,
      ),
      titlesData: LineTitles.getTitleData(),
      borderData: FlBorderData(show: false),
      minX: 0,
      maxX: points.length.toDouble() - 1,
      minY: 0,
      maxY: 105,
      lineBarsData: [
        LineChartBarData(
          spots: points
              .asMap()
              .entries
              .map((entry) => FlSpot(entry.key.toDouble(),
                  double.parse((entry.value.decimal * 100).toStringAsFixed(4))))
              .toList(),
          isCurved: true,
          curveSmoothness: 0.1,
          color: MyPuttColors.darkBlue,
          barWidth: 3,
          isStrokeCapRound: true,
          dotData: const FlDotData(show: false),
        ),
      ],
    );
  }
}

class LineTitles {
  static getTitleData() => FlTitlesData(
        topTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        bottomTitles: const AxisTitles(
          sideTitles: SideTitles(
            showTitles: false,
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
              showTitles: false,
              getTitlesWidget: (double value, TitleMeta titleMeta) {
                late final String title;
                switch (value.toInt()) {
                  case 0:
                    title = '0';
                    break;
                  case 50:
                    title = '50';
                    break;
                  case 100:
                    title = '100';
                    break;
                  default:
                    title = '';
                    break;
                }
                return Text(
                  title,
                  style: const TextStyle(fontSize: 10),
                );
              }),
        ),
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
      );
}
