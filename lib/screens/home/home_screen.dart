import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myputt/cubits/home_screen_cubit.dart';
import 'package:myputt/screens/home/components/putting_stats_page.dart';
import 'package:myputt/screens/home/components/charts/performance_chart_panel.dart';
import 'package:myputt/utils/colors.dart';
import 'package:myputt/utils/constants.dart';
import 'package:myputt/utils/enums.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  static String routeName = '/';

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  int _sessionRangeIndex = 0;
  late final TabController _rangeTabController;
  late final TabController _circlesController;
  late ScrollController _scrollController;

  Map<int, int> indexToTimeRange = {
    0: TimeRange.lastFive,
    1: TimeRange.lastTwenty,
    2: TimeRange.lastFifty,
    3: TimeRange.allTime,
  };

  @override
  void initState() {
    _scrollController = ScrollController();
    _rangeTabController = TabController(length: 4, vsync: this);
    _circlesController = TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    _circlesController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _sessionRangeIndex = _rangeTabController.index;
    BlocProvider.of<HomeScreenCubit>(context).reloadStats();
    return Scaffold(
        backgroundColor: Colors.grey[100]!,
        appBar: AppBar(
          backgroundColor: Colors.white,
          shadowColor: Colors.transparent,
          title: RichText(
            text: TextSpan(
              style: Theme.of(context).textTheme.headline4,
              children: [
                const TextSpan(
                    text: 'My', style: TextStyle(color: Colors.blue)),
                TextSpan(
                    text: 'Putt',
                    style: TextStyle(color: MyPuttColors.gray[400])),
              ],
            ),
          ),
        ),
        body: NestedScrollView(
          controller: _scrollController,
          headerSliverBuilder: (BuildContext context, bool value) {
            return [
              SliverToBoxAdapter(
                child: Column(
                  children: [
                    Container(
                        padding: const EdgeInsets.only(top: 8),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                              end: const Alignment(1, 0),
                              transform:
                                  const GradientRotation(3 * math.pi / 2),
                              colors: [
                                MyPuttColors.blue.withOpacity(0.8),
                                MyPuttColors.white,
                              ]),
                        ),
                        child: const PerformanceChartPanel()),
                    _circlesTabBar(context)
                  ],
                ),
              ),
            ];
          },
          body: TabBarView(controller: _circlesController, children: [
            PuttingStatsPage(
              circle: Circles.circle1,
              timeRange: indexToTimeRange[_sessionRangeIndex] ?? 5,
              screenType: 'home',
            ),
            PuttingStatsPage(
              circle: Circles.circle2,
              timeRange: indexToTimeRange[_sessionRangeIndex] ?? 5,
              screenType: 'home',
            ),
          ]),
        ));
  }

  Widget _circlesTabBar(BuildContext context) {
    return Container(
      color: MyPuttColors.white,
      height: 60,
      child: TabBar(
        controller: _circlesController,
        labelPadding: const EdgeInsets.all(0),
        indicatorPadding: const EdgeInsets.all(0),
        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        labelColor: Colors.blue,
        unselectedLabelColor: Colors.black,
        indicator: const UnderlineTabIndicator(
            borderSide: BorderSide(color: MyPuttColors.blue)),
        tabs: const [
          HomeScreenTab(
            label: 'Circle 1',
          ),
          HomeScreenTab(label: 'Circle 2'),
        ],
      ),
    );
  }
}

class HomeScreenTab extends StatelessWidget {
  const HomeScreenTab({
    Key? key,
    required this.label,
    this.icon,
  }) : super(key: key);

  final String label;
  final Icon? icon;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        // margin: const EdgeInsets.all(4),
        padding: const EdgeInsets.all(4),
        child: Tab(
            icon: icon,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(label),
              ],
            )),
      ),
    );
  }
}
