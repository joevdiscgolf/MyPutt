import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myputt/cubits/home/home_screen_v2_cubit.dart';
import 'package:myputt/screens/home_v2/components/home_screen_circle_stats/home_screen_circle_stats.dart';
import 'package:myputt/screens/home_v2/components/home_screen_v2_app_bar/home_screen_v2_app_bar.dart';
import 'package:myputt/screens/home_v2/performance_chart/wrapper/home_v2_chart_wrapper.dart';
import 'package:myputt/utils/physics.dart';

class HomeScreenV2 extends StatelessWidget {
  const HomeScreenV2({super.key, required this.scrollController});

  final ScrollController scrollController;

  static const String routeName = 'home_v2';
  static const String screenName = 'Home V2';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: HomeScreenV2AppBar(
        topViewPadding: MediaQuery.of(context).viewPadding.top,
      ),
      body: BlocBuilder<HomeScreenV2Cubit, HomeScreenV2State>(
        builder: (context, state) {
          return _mainBody(context);
        },
      ),
    );
  }

  Widget _mainBody(BuildContext context) {
    final List<Widget> children = [
      const HomeChartV2Wrapper(),
      const SizedBox(height: 24),
      const HomeScreenCircleStats()
    ];
    return CustomScrollView(
      physics: const BottomBouncingScrollPhysics(),
      slivers: [
        SliverPadding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewPadding.bottom,
          ),
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) => children[index],
              childCount: children.length,
            ),
          ),
        ),
      ],
    );
  }
}
