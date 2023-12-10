import 'dart:math' as math;
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';
import 'package:intl/intl.dart';
import 'package:myputt/cubits/home/home_screen_v2_cubit.dart';
import 'package:myputt/models/data/chart/chart_point.dart';
import 'package:myputt/screens/home_v2/components/home_screen_chart_V2/components/chart_scrubber.dart';
import 'package:myputt/screens/home_v2/screens/home_chart_screen/home_chart_screen.dart';
import 'package:myputt/utils/colors.dart';
import 'package:myputt/utils/helpers.dart';

class HomeScreenChartV2 extends StatelessWidget {
  const HomeScreenChartV2({
    Key? key,
    required this.points,
    this.height = 200,
    required this.screenWidth,
    this.noData = false,
  }) : super(key: key);

  final List<ChartPoint> points;
  final double height;
  final double screenWidth;
  final bool noData;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: SizedBox(
            height: height,
            child: Stack(
              children: [
                SizedBox(
                  height: height,
                  child: Builder(builder: (context) {
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
                  }),
                ),
                BlocBuilder<HomeScreenV2Cubit, HomeScreenV2State>(
                  builder: (context, homeScreenV2State) {
                    final ChartDragData? chartDragData =
                        tryCast<HomeScreenV2Loaded>(homeScreenV2State)
                            ?.chartDragData;
                    if (chartDragData != null && chartDragData.dragging) {
                      return ChartScrubber(
                        crossHairOffset:
                            chartDragData.crossHairOffset ?? const Offset(0, 0),
                        labelHorizontalOffset:
                            chartDragData.labelHorizontalOffset ?? 0,
                        chartHeight: height,
                        dateLabel: chartDragData.draggedDate != null
                            ? DateFormat.yMMMd('en_US')
                                .format(chartDragData.draggedDate!)
                            : '',
                        percentage: chartDragData.draggedValue ?? 0,
                      );
                    } else {
                      return const SizedBox();
                    }
                  },
                ),
                SizedBox(
                  height: height,
                  width: screenWidth,
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(
                          CupertinoPageRoute(
                            builder: (context) => const HomeChartScreen(),
                          ),
                        );
                      },
                      onTapDown: (TapDownDetails details) {
                        Vibrate.feedback(FeedbackType.heavy);
                        BlocProvider.of<HomeScreenV2Cubit>(context).handleDrag(
                          context,
                          dragOffset: details.localPosition,
                          points: points,
                          screenWidth: screenWidth,
                          chartHeight: height,
                          tappedDown: true,
                        );
                      },
                      onTapUp: (TapUpDetails details) {
                        BlocProvider.of<HomeScreenV2Cubit>(context)
                            .handleDragEnd(context);
                      },
                      onHorizontalDragStart: (DragStartDetails details) {
                        BlocProvider.of<HomeScreenV2Cubit>(context).handleDrag(
                          context,
                          dragOffset: details.localPosition,
                          points: points,
                          screenWidth: screenWidth,
                          chartHeight: height,
                          horizontalDragStart: true,
                        );
                      },
                      onHorizontalDragUpdate: (DragUpdateDetails details) {
                        BlocProvider.of<HomeScreenV2Cubit>(context).handleDrag(
                          context,
                          dragOffset: details.localPosition,
                          points: points,
                          screenWidth: screenWidth,
                          chartHeight: height,
                        );
                      },
                      onHorizontalDragEnd: (DragEndDetails details) {
                        BlocProvider.of<HomeScreenV2Cubit>(context)
                            .handleDragEnd(context);
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        // _verticalAxis(context)
      ],
    );
  }

  // Widget _verticalAxis(BuildContext context) {
  //   final TextStyle style = Theme.of(context)
  //       .textTheme
  //       .bodyMedium!
  //       .copyWith(color: MyPuttColors.gray[300]);
  //   return SizedBox(
  //     width: 40,
  //     height: height,
  //     child: Column(
  //       crossAxisAlignment: CrossAxisAlignment.center,
  //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //       children: [
  //         Text('100%', style: style),
  //         Text('0%', style: style),
  //       ],
  //     ),
  //   );
  // }

  LineChartData _mainData(BuildContext context, List<ChartPoint> points) {
    // multiply by 100 because of percentage conversion

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
