import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:myputt/screens/my_profile/components/charts/performance_chart.dart';
import 'package:myputt/data/types/chart/chart_point.dart';
import 'package:myputt/locator.dart';
import 'package:myputt/repositories/challenges_repository.dart';
import 'package:myputt/repositories/session_repository.dart';
import 'package:myputt/services/stats_service.dart';
import 'package:myputt/utils/calculators.dart';
import 'package:myputt/utils/colors.dart';
import 'package:myputt/utils/constants.dart';

class PerformanceChartPanel extends StatefulWidget {
  const PerformanceChartPanel({Key? key}) : super(key: key);

  @override
  _PerformanceChartPanelState createState() => _PerformanceChartPanelState();
}

class _PerformanceChartPanelState extends State<PerformanceChartPanel>
    with TickerProviderStateMixin {
  final ChallengesRepository _challengesRepository =
      locator.get<ChallengesRepository>();
  final SessionRepository _sessionRepository = locator.get<SessionRepository>();
  final StatsService _statsService = locator.get<StatsService>();

  late final TabController _rangeTabController;
  int _sessionRangeIndex = 0;
  final double _sliderValue = 0;
  double _smoothnessSliderValue = 0.5;
  late int _numSets;
  late int _totalSets;
  List<int> distancesRow = [];
  int _selectedDistance = 20;
  int _smoothRange = 4;

  @override
  void initState() {
    _rangeTabController = TabController(length: 4, vsync: this);
    _rangeTabController.addListener(() {
      setState(() => _sessionRangeIndex = _rangeTabController.index);
    });
    _totalSets = _statsService.getTotalPuttingSets(
        _sessionRepository.allSessions,
        _challengesRepository.completedChallenges,
        _selectedDistance);
    _numSets = _totalSets;
    for (var distance = 10; distance <= 30; distance += 5) {
      distancesRow.add(distance);
    }
    for (var distance = 40; distance <= 60; distance += 10) {
      distancesRow.add(distance);
    }
    super.initState();
  }

  @override
  void dispose() {
    _rangeTabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    int? limit =
        _sessionRangeIndex == 3 ? null : indexToTimeRange[_sessionRangeIndex]!;
    PerformanceChartData smoothData = smoothChart(
        PerformanceChartData(
            points: _statsService.getPointsWithDistanceAndLimit(
                _sessionRepository.allSessions,
                _challengesRepository.completedChallenges,
                _selectedDistance,
                limit)),
        _smoothRange);
    return Column(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _sessionRangeTabBar(context),
            PerformanceChart(data: smoothData),
            Row(
              children: distancesRow
                  .map((distance) =>
                      Expanded(child: _chooseDistanceButton(context, distance)))
                  .toList(),
            ),
            const SizedBox(
              height: 8,
            ),
            Row(
              children: [
                Expanded(
                  child: Slider(
                    inactiveColor: Colors.grey[400]!,
                    activeColor: Colors.blue,
                    thumbColor: Colors.blue,
                    label: _numSets.toString(),
                    onChanged: (double newValue) {
                      setState(() {
                        _smoothRange = (newValue * 8).toInt();
                        _smoothnessSliderValue = newValue;
                      });
                    },
                    value: _smoothnessSliderValue,
                  ),
                )
              ],
            ),
          ],
        ),
        // _chartOptionsPanel(context),
      ],
    );
  }

  Widget _sessionRangeTabBar(BuildContext context) {
    return SizedBox(
      height: 60,
      child: TabBar(
        indicator: const UnderlineTabIndicator(
            borderSide: BorderSide(color: MyPuttColors.white)),
        controller: _rangeTabController,
        labelPadding: const EdgeInsets.all(0),
        indicatorPadding: const EdgeInsets.all(0),
        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        labelColor: Colors.white,
        unselectedLabelColor: Colors.black,
        tabs: const [
          Tab(
            child: Text('Last 5'),
          ),
          Tab(
            child: Text('Last 20'),
          ),
          Tab(
            child: Text('Last 50'),
          ),
          Tab(
            child: Text('All time'),
          ),
        ],
      ),
    );
  }

  Widget _chartOptionsPanel(BuildContext context) {
    return Container(
      color: MyPuttColors.white,
      padding: const EdgeInsets.all(4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.center,
          //   children: [
          //     Text(
          //       'Last',
          //       style: Theme.of(context).textTheme.headline6,
          //     ),
          //     const SizedBox(width: 5),
          //     Text(
          //       '$_numSets',
          //       style: Theme.of(context)
          //           .textTheme
          //           .headline6
          //           ?.copyWith(color: Colors.blue),
          //     ),
          //     const SizedBox(width: 5),
          //     Text(
          //       _numSets == 1 ? 'Set' : 'Sets',
          //       style: Theme.of(context).textTheme.headline6,
          //     ),
          //   ],
          // ),
          // Row(
          //   children: [
          //     Expanded(
          //       child: Slider(
          //         inactiveColor: Colors.blue,
          //         activeColor: Colors.grey[400]!,
          //         thumbColor: Colors.blue,
          //         label: _numSets.toString(),
          //         onChanged: (double newValue) {
          //           setState(() {
          //             _numSets = ((1 - newValue) * _totalSets).toInt();
          //             _sliderValue = newValue;
          //           });
          //         },
          //         value: _sliderValue,
          //       ),
          //     )
          //   ],
          // ),
          // Text(
          //   'Smoothness',
          //   style: Theme.of(context).textTheme.headline6,
          // ),
        ],
      ),
    );
  }

  Widget _chooseDistanceButton(BuildContext context, int distance) {
    return Bounceable(
      onTap: () {
        setState(() {
          _selectedDistance = distance;
          _totalSets = _statsService.getTotalPuttingSets(
              _sessionRepository.allSessions,
              _challengesRepository.completedChallenges,
              distance);
          _numSets = ((1 - _sliderValue) * _totalSets).toInt();
        });
      },
      child: Center(
        child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(40.0),
              color: _selectedDistance == distance
                  ? MyPuttColors.gray[100]
                  : Colors.transparent),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          margin: const EdgeInsets.symmetric(horizontal: 2),
          child: Text(
            '$distance',
            style: Theme.of(context)
                .textTheme
                .headline6
                ?.copyWith(color: MyPuttColors.blue, fontSize: 10),
          ),
        ),
      ),
    );
  }
}
