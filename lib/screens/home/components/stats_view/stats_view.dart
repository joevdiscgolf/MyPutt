import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:mixpanel_flutter/mixpanel_flutter.dart';
import 'package:myputt/locator.dart';
import 'package:myputt/screens/home/components/home_screen_tab.dart';
import 'package:myputt/screens/home/components/stats_view/putting_stats_page.dart';
import 'package:myputt/utils/colors.dart';
import 'package:myputt/utils/constants.dart';
import 'package:myputt/utils/enums.dart';

import 'charts/performance_chart_panel.dart';

class StatsView extends StatefulWidget {
  const StatsView({Key? key}) : super(key: key);

  @override
  _StatsViewState createState() => _StatsViewState();
}

class _StatsViewState extends State<StatsView> with TickerProviderStateMixin {
  final Mixpanel _mixpanel = locator.get<Mixpanel>();
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
    super.initState();
    _scrollController = ScrollController();
    _rangeTabController = TabController(length: 4, vsync: this);
    _circlesController = TabController(length: 2, vsync: this);
    _addListeners();
  }

  void _addListeners() {
    _rangeTabController.addListener(() {
      final int index = _rangeTabController.index;
      String? range;
      switch (index) {
        case 0:
          range = 'Last 5';
          break;
        case 1:
          range = 'Last 20';
          break;
        case 2:
          range = 'Last 50';
          break;
        case 3:
          range = 'All Time';
          break;
        default:
          break;
      }
      _mixpanel.track(
        'Home Screen Performance Chart Range Pressed',
        properties: {'Chart Range': range},
      );
    });
    _circlesController.addListener(() {
      _mixpanel.track(
        'Home Screen Circle Tab Bar Pressed',
        properties: {
          'Circle': _circlesController.index == 0 ? 'Circle 1' : 'Circle 2'
        },
      );
    });
  }

  @override
  void dispose() {
    _rangeTabController.dispose();
    _circlesController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return NestedScrollView(
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
                      end: const Alignment(0.9, 0),
                      transform: const GradientRotation(3 * math.pi / 2),
                      colors: [
                        MyPuttColors.blue.withOpacity(0.8),
                        MyPuttColors.white,
                      ],
                    ),
                  ),
                  child: PerformanceChartPanel(
                    rangeTabController: _rangeTabController,
                  ),
                ),
                _circlesTabBar(context)
              ],
            ),
          ),
        ];
      },
      body: TabBarView(controller: _circlesController, children: [
        PuttingStatsPage(
          circle: Circles.circle1,
          timeRange: indexToTimeRange[_rangeTabController.index] ?? 5,
          screenType: 'home',
        ),
        PuttingStatsPage(
          circle: Circles.circle2,
          timeRange: indexToTimeRange[_rangeTabController.index] ?? 5,
          screenType: 'home',
        ),
      ]),
    );
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
          HomeScreenTab(label: 'Circle 1'),
          HomeScreenTab(label: 'Circle 2'),
        ],
      ),
    );
  }
}
