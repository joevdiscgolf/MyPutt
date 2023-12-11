import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';
import 'package:myputt/components/charts/generic_performance_chart.dart';
import 'package:myputt/cubits/home/home_screen_v2_cubit.dart';
import 'package:myputt/models/data/chart/chart_point.dart';
import 'package:myputt/screens/home_v2/screens/home_v2_chart_screen/home_v2_chart_screen.dart';
import 'package:myputt/utils/helpers.dart';

class HomeScreenV2Chart extends StatelessWidget {
  const HomeScreenV2Chart({
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
    return BlocBuilder<HomeScreenV2Cubit, HomeScreenV2State>(
      builder: (context, homeScreenV2State) {
        final ChartDragData? chartDragData =
            tryCast<HomeScreenV2Loaded>(homeScreenV2State)?.chartDragData;

        return GenericPerformanceChart(
          points: points,
          height: height,
          screenWidth: screenWidth,
          noData: noData,
          chartDragData: chartDragData,
          onTap: () {
            Navigator.of(context).push(
              CupertinoPageRoute(
                builder: (context) => const HomeV2ChartScreen(),
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
            BlocProvider.of<HomeScreenV2Cubit>(context).handleDragEnd(context);
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
            BlocProvider.of<HomeScreenV2Cubit>(context).handleDragEnd(context);
          },
        );
      },
    );
  }
}
