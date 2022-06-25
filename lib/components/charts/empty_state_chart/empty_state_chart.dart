import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:myputt/components/charts/empty_state_chart/empty_chart_points.dart';
import 'package:myputt/utils/colors.dart';

class EmptyStateChart extends StatelessWidget {
  const EmptyStateChart({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(5),
      height: 250,
      child: Stack(
        alignment: Alignment.center,
        children: [
          LineChart(mainData(context)),
          Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(FlutterRemix.ghost_line, size: 40),
              Text(
                'No data',
                style: Theme.of(context).textTheme.headline6?.copyWith(
                      color: MyPuttColors.darkGray,
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  LineChartData mainData(BuildContext context) {
    return LineChartData(
      lineTouchData: LineTouchData(enabled: false),
      clipData: FlClipData(bottom: true, left: true, top: true, right: true),
      axisTitleData: FlAxisTitleData(
          leftTitle: AxisTitle(
        margin: 0,
        textAlign: TextAlign.center,
        showTitle: false,
        titleText: '%',
      )),
      gridData: FlGridData(show: false),
      titlesData: LineTitles.getTitleData(),
      borderData: FlBorderData(show: false),
      minX: 0,
      maxX: emptyStateChartPoints.length.toDouble() - 1,
      minY: 0,
      maxY: 25,
      lineBarsData: [
        LineChartBarData(
          spots: emptyStateChartPoints
              .asMap()
              .entries
              .map(
                (entry) => FlSpot(
                  entry.key.toDouble(),
                  entry.value.decimal,
                ),
              )
              .toList(),
          isCurved: true,
          colors: [MyPuttColors.darkBlue.withOpacity(0.2)],
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
