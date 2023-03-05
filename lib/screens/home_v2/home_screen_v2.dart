import 'package:flutter/material.dart';
import 'package:myputt/screens/home_v2/components/circle_stats_section/circle_stats_section.dart';
import 'package:myputt/screens/home_v2/components/home_screen_chart_V2/home_screen_chart_v2_wrapper.dart';
import 'package:myputt/screens/home_v2/components/home_screen_v2_app_bar.dart';

class HomeScreenV2 extends StatelessWidget {
  const HomeScreenV2({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: HomeScreenV2AppBar(
        topViewPadding: MediaQuery.of(context).viewPadding.top,
      ),
      body: _mainBody(context),
    );
  }

  Widget _mainBody(BuildContext context) {
    final List<Widget> children = [
      const HomeScreenChartV2Wrapper(),
      const SizedBox(height: 16),
      const CircleStats()
    ];
    return CustomScrollView(
      physics: const ClampingScrollPhysics(),
      slivers: [
        SliverList(
          delegate: SliverChildBuilderDelegate(
              (context, index) => children[index],
              childCount: children.length),
        ),
      ],
    );
  }
}
