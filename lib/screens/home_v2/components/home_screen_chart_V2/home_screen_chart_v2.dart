import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';
import 'package:myputt/cubits/home/home_screen_v2_cubit.dart';
import 'package:myputt/models/data/chart/chart_point.dart';
import 'package:myputt/screens/home/components/stats_view/charts/performance_chart.dart';
import 'package:myputt/screens/home_v2/components/home_screen_chart_V2/components/chart_scrubber.dart';
import 'package:myputt/utils/colors.dart';

class HomeScreenChartV2 extends StatelessWidget {
  const HomeScreenChartV2({
    Key? key,
    required this.chartPoints,
    this.height = 200,
  }) : super(key: key);

  final List<ChartPoint> chartPoints;
  final double height;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: Stack(
        children: [
          // chart crosshair
          BlocBuilder<HomeScreenV2Cubit, HomeScreenV2State>(
            builder: (context, homeScreenV2State) {
              return ChartScrubber(
                crossHairOffset: Offset(200, 0),
                dateScrubberOffset: Offset(0, 100),
                chartHeight: height,
                dateLabel: 'march 10',
                percentage: 0.5,
                labelHorizontalOffset: 0,
              );
            },
          ),
          SizedBox(
            height: height,
            width: MediaQuery.of(context).size.width,
            child: Align(
              alignment: Alignment.topLeft,
              child: GestureDetector(
                onTapDown: (TapDownDetails details) {
                  Vibrate.feedback(FeedbackType.heavy);

                  // BlocProvider.of<PortfolioChartCubit>(context).handleDrag(
                  //   dragOffset: details.localPosition,
                  //   points: points,
                  //   screenWidth: screenWidth,
                  //   chartHeight: chartHeight,
                  //   tappedDown: true,
                  //   maxScrubberWidth: maxScrubberWidth,
                  //   isPositionsScreen: isPositionsScreen,
                  // );
                },
                onTapUp: (TapUpDetails details) {
                  // BlocProvider.of<PortfolioChartCubit>(context).onDragEnd(
                  //   points,
                  //   chartHeight,
                  //   isPositionsScreen: isPositionsScreen,
                  // );
                },
                onHorizontalDragStart: (DragStartDetails details) {
                  // BlocProvider.of<PortfolioChartCubit>(context).handleDrag(
                  //   dragOffset: details.localPosition,
                  //   points: points,
                  //   screenWidth: screenWidth,
                  //   chartHeight: chartHeight,
                  //   horizontalDragStart: true,
                  //   maxScrubberWidth: maxScrubberWidth,
                  //   isPositionsScreen: isPositionsScreen,
                  // );
                },
                onHorizontalDragUpdate: (DragUpdateDetails details) {
                  // BlocProvider.of<PortfolioChartCubit>(context).handleDrag(
                  //   dragOffset: details.localPosition,
                  //   points: points,
                  //   screenWidth: screenWidth,
                  //   chartHeight: chartHeight,
                  //   maxScrubberWidth: maxScrubberWidth,
                  //   isPositionsScreen: isPositionsScreen,
                  // );
                },
                onHorizontalDragEnd: (DragEndDetails details) {
                  // BlocProvider.of<PortfolioChartCubit>(context).onDragEnd(
                  //   points,
                  //   chartHeight,
                  //   isPositionsScreen: isPositionsScreen,
                  // );
                },
              ),
            ),
          ),
          SizedBox(
            height: height,
            child: LineChart(
              mainData(
                context,
                PerformanceChartData(points: chartPoints),
              ),
              swapAnimationDuration: const Duration(milliseconds: 0),
            ),
          ),
        ],
      ),
    );
  }

  LineChartData mainData(BuildContext context, PerformanceChartData chartData) {
    // multiply by 100 because of percentage conversion

    final List<double> yValues =
        chartData.points.map((point) => point.decimal).toList();
    final double minY = yValues.reduce(min) * 100;
    final double maxY = yValues.reduce(max) * 100;

    return LineChartData(
      lineTouchData: LineTouchData(enabled: false),
      // clipData: FlClipData(bottom: true, left: true, top: true, right: true),
      axisTitleData: FlAxisTitleData(
        leftTitle: AxisTitle(
          margin: 0,
          textAlign: TextAlign.center,
          showTitle: false,
          titleText: '%',
        ),
      ),
      gridData: FlGridData(show: false),
      titlesData: LineTitles.getTitleData(),
      borderData: FlBorderData(show: false),
      minX: 0,
      maxX: chartData.points.length.toDouble() - 1,
      minY: minY,
      maxY: maxY + 5,
      lineBarsData: [
        LineChartBarData(
          spots: chartData.points
              .asMap()
              .entries
              .map((entry) => FlSpot(entry.key.toDouble(),
                  double.parse((entry.value.decimal * 100).toStringAsFixed(4))))
              .toList(),
          isCurved: true,
          curveSmoothness: 0.5,
          colors: [MyPuttColors.darkBlue],
          barWidth: 4,
          isStrokeCapRound: true,
          dotData: FlDotData(show: false),
        ),
      ],
    );
  }
}
