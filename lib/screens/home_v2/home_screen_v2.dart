import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myputt/cubits/home/home_screen_v2_cubit.dart';
import 'package:myputt/screens/home_v2/components/home_screen_chart_V2/home_screen_chart_v2_wrapper.dart';
import 'package:myputt/screens/home_v2/components/home_screen_circle_stats/home_screen_circle_stats.dart';
import 'package:myputt/screens/home_v2/components/home_screen_v2_app_bar.dart';

class HomeScreenV2 extends StatelessWidget {
  const HomeScreenV2({Key? key}) : super(key: key);

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
      const HomeScreenChartV2Wrapper(),
      const Divider(height: 32, indent: 24, endIndent: 24),
      const HomeScreenCircleStats()
    ];
    return CustomScrollView(
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
