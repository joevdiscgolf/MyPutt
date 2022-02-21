import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class PerformanceChart extends StatelessWidget {
  const PerformanceChart({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container();
  }

  LineChartData mainData(PerformanceChart chart, double percentageChange) {
    return LineChartData(
      gridData: FlGridData(show: false),
      titlesData: FlTitlesData(show: false),
      borderData: FlBorderData(show: false),
      minX: 0,
      maxX: chart.points.length.toDouble() - 1,
      minY: chart.points.map((point) => point.value).reduce(min),
      maxY: chart.points.map((point) => point.value).reduce(max),
      lineTouchData: LineTouchData(
        enabled: true,
        handleBuiltInTouches: true,
        getTouchedSpotIndicator:
            (LineChartBarData barData, List<int> indicators) {
          return indicators.map((int index) {
            final flLine = FlLine(color: Colors.transparent, strokeWidth: 0);
            final dotData = FlDotData(
              getDotPainter: (spot, percent, bar, index) => FlDotCirclePainter(
                radius: 5,
                color: RoiColors.black,
                strokeWidth: 24,
                strokeColor: RoiColors.black.withOpacity(0.03),
              ),
            );
            return TouchedSpotIndicatorData(flLine, dotData);
          }).toList();
        },
        touchCallback: (FlTouchEvent event, LineTouchResponse? lineTouch) {
          if (lineTouch?.lineBarSpots?[0].y != null) {
            setState(() {
              _currentPrice = lineTouch!.lineBarSpots![0].y;
              _currentDate = null;
            });
          } else {
            Vibrate.feedback(FeedbackType.selection);
            setState(() {
              _currentPrice = widget.latestPrice;
              _currentDate =
                  getRangeLongLabelFromChartRange(_selectedChartRange);
            });
          }
        },
        touchTooltipData: LineTouchTooltipData(
          tooltipRoundedRadius: 16,
          fitInsideHorizontally: true,
          fitInsideVertically: true,
          showOnTopOfTheChartBoxArea: true,
          tooltipBgColor: RoiColors.gray[50],
          getTooltipItems: (List<LineBarSpot> touchedBarSpots) {
            return touchedBarSpots.map((barSpot) {
              final flSpot = barSpot;
              final Point point = chart.points[flSpot.x.toInt()];
              return LineTooltipItem(
                point.date,
                Theme.of(context).textTheme.bodyText1!.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
              );
            }).toList();
          },
        ),
      ),
      lineBarsData: [
        LineChartBarData(
          spots: chart.points
              .asMap()
              .entries
              .map((entry) => FlSpot(entry.key.toDouble(), entry.value.value))
              .toList(),
          isCurved: true,
          colors: [RoiColors.black],
          barWidth: 3,
          isStrokeCapRound: true,
          dotData: FlDotData(show: false),
          belowBarData: BarAreaData(
            show: false,
            colors:
                [RoiColors.black].map((color) => color.withOpacity(1)).toList(),
          ),
        ),
      ],
    );
  }
}
