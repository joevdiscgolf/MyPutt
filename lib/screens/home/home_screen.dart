import 'package:flutter/material.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:mixpanel_flutter/mixpanel_flutter.dart';
import 'package:myputt/locator.dart';
import 'package:myputt/screens/home/components/home_app_bar.dart';
import 'package:myputt/screens/home/components/stats_view/stats_view.dart';
import 'package:myputt/utils/colors.dart';
import 'package:myputt/utils/enums.dart';

import 'components/calendar_view/calendar_view.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  static String routeName = '/';

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  final Mixpanel _mixpanel = locator.get<Mixpanel>();
  PerformanceViewMode _performanceViewMode = PerformanceViewMode.chart;
  late final TabController _calendarChartTabController;

  @override
  void initState() {
    super.initState();
    _mixpanel.track('Home Screen Impression');
    _calendarChartTabController = TabController(length: 2, vsync: this);
    _calendarChartTabController.addListener(
      () {
        if (_calendarChartTabController.index == 0) {
          _mixpanel.track('Home Screen Performance Chart Tab Pressed');
        } else {
          _mixpanel.track('Home Screen Performance Calendar Tab Pressed');
        }
        setState(
          () => _performanceViewMode = _calendarChartTabController.index == 0
              ? PerformanceViewMode.chart
              : PerformanceViewMode.calendar,
        );
      },
    );
  }

  @override
  void dispose() {
    _calendarChartTabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const HomeAppBar(),
      body: Column(
        children: [
          _calendarChartTabBar(context),
          Expanded(
            child: TabBarView(
              controller: _calendarChartTabController,
              children: const [
                StatsView(),
                CalendarView(),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _calendarChartTabBar(BuildContext context) {
    return TabBar(
      controller: _calendarChartTabController,
      indicator: const UnderlineTabIndicator(
          borderSide: BorderSide(color: MyPuttColors.darkGray)),
      tabs: [
        Container(
          padding: const EdgeInsets.all(8),
          child: Icon(FlutterRemix.line_chart_line,
              color: _performanceViewMode == PerformanceViewMode.chart
                  ? MyPuttColors.darkBlue
                  : MyPuttColors.gray[400]),
        ),
        Container(
          padding: const EdgeInsets.all(8),
          child: Icon(FlutterRemix.calendar_line,
              color: _performanceViewMode == PerformanceViewMode.calendar
                  ? MyPuttColors.darkBlue
                  : MyPuttColors.gray[400]),
        ),
      ],
    );
  }
}
