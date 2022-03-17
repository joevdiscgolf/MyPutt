import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:myputt/screens/home/components/charts/performance_chart.dart';
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
                    inactiveColor: MyPuttColors.white,
                    activeColor: MyPuttColors.gray[600]!,
                    thumbColor: MyPuttColors.gray[600]!,
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
            borderSide: BorderSide(color: MyPuttColors.darkBlue)),
        controller: _rangeTabController,
        labelPadding: const EdgeInsets.all(0),
        indicatorPadding: const EdgeInsets.all(0),
        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        labelColor: MyPuttColors.darkBlue,
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
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          margin: const EdgeInsets.symmetric(horizontal: 2),
          child: AutoSizeText(
            '$distance',
            style: Theme.of(context)
                .textTheme
                .headline6
                ?.copyWith(color: MyPuttColors.gray[800], fontSize: 16),
            maxLines: 1,
          ),
        ),
      ),
    );
  }
}
