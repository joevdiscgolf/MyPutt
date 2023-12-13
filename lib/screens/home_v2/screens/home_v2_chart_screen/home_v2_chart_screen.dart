import 'package:flutter/material.dart';
import 'package:myputt/components/app_bars/myputt_app_bar.dart';
import 'package:myputt/screens/home_v2/screens/home_v2_chart_screen/components/circle_chart_section.dart';
import 'package:myputt/screens/home_v2/screens/home_v2_chart_screen/components/time_ranges_row.dart';
import 'package:myputt/utils/enums.dart';

class HomeV2ChartScreen extends StatelessWidget {
  const HomeV2ChartScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<Widget> children = [
      const TimeRangesRow(),
      ...[PuttingCircle.c1, PuttingCircle.c2, PuttingCircle.c3].map(
        (PuttingCircle circle) => CircleChartSection(
          circle: circle,
        ),
      ),
    ];

    return Scaffold(
      appBar: MyPuttAppBar(
        title: 'Performance',
        topViewPadding: MediaQuery.of(context).viewPadding.top,
      ),
      body: ListView.builder(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewPadding.bottom,
        ),
        itemBuilder: (context, index) => children[index],
        itemCount: children.length,
      ),
    );
  }
}
