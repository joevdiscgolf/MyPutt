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

  // final List<String> _sessionRangeLabels = [
  //   'Last 5',
  //   'Last 20',
  //   'Last 50',
  //   'All time'
  // ];

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
                child: Container(
                    padding: const EdgeInsets.only(top: 8),
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                          end: Alignment(1.1, 0),
                          transform: GradientRotation(math.pi / 2),
                          colors: [
                            MyPuttColors.blue,
                            MyPuttColors.white,
                          ]),
                    ),
                    child: Column(
                      children: [
                        const PerformanceChartPanel(),
                        _circlesTabBar(context)
                      ],
                    )),
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

  // Widget _sessionRangeRow(BuildContext context) {
  //   return Container(
  //     padding: const EdgeInsets.fromLTRB(5, 10, 5, 5),
  //     decoration: const BoxDecoration(
  //       color: Colors.white,
  //     ),
  //     child: Row(
  //         children: _sessionRangeLabels
  //             .asMap()
  //             .entries
  //             .map((entry) => Expanded(
  //                   child: Builder(builder: (context) {
  //                     if (_sessionRangeIndex == entry.key) {
  //                       return ElevatedButton(
  //                           child: Text(entry.value,
  //                               style: const TextStyle(
  //                                   color: Colors.white, fontSize: 15)),
  //                           style: ElevatedButton.styleFrom(
  //                               shape: RoundedRectangleBorder(
  //                                 borderRadius: BorderRadius.circular(10.0),
  //                               ),
  //                               side: const BorderSide(
  //                                   width: 2.0, color: Colors.blue),
  //                               primary: Colors.blue,
  //                               shadowColor: Colors.transparent),
  //                           onPressed: () {
  //                             setState(() {
  //                               _sessionRangeIndex = entry.key;
  //                             });
  //
  //                             BlocProvider.of<HomeScreenCubit>(context)
  //                                 .updateSessionRange(
  //                                     indexToTimeRange[_sessionRangeIndex] ??
  //                                         5);
  //                             BlocProvider.of<HomeScreenCubit>(context)
  //                                 .reloadStats();
  //                           });
  //                     }
  //                     return ElevatedButton(
  //                         style: ElevatedButton.styleFrom(
  //                             shape: RoundedRectangleBorder(
  //                               borderRadius: BorderRadius.circular(10.0),
  //                             ),
  //                             primary: Colors.transparent,
  //                             shadowColor: Colors.transparent),
  //                         child: Text(entry.value,
  //                             style: const TextStyle(
  //                                 fontSize: 15, color: Colors.blue)),
  //                         onPressed: () {
  //                           setState(() {
  //                             _sessionRangeIndex = entry.key;
  //                           });
  //                           BlocProvider.of<HomeScreenCubit>(context)
  //                               .updateSessionRange(
  //                                   indexToTimeRange[_sessionRangeIndex] ?? 5);
  //                           BlocProvider.of<HomeScreenCubit>(context)
  //                               .reloadStats();
  //                         });
  //                   }),
  //                 ))
  //             .toList()),
  //   );
  // }

  Widget _circlesTabBar(BuildContext context) {
    return Container(
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
