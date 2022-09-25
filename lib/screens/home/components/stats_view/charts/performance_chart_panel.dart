import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:mixpanel_flutter/mixpanel_flutter.dart';
import 'package:myputt/components/empty_state/empty_state_chart/empty_state_chart.dart';
import 'package:myputt/cubits/home_screen_cubit.dart';
import 'package:myputt/screens/home/components/stats_view/charts/performance_chart.dart';
import 'package:myputt/models/data/chart/chart_point.dart';
import 'package:myputt/locator.dart';
import 'package:myputt/repositories/challenges_repository.dart';
import 'package:myputt/repositories/session_repository.dart';
import 'package:myputt/services/stats_service.dart';
import 'package:myputt/utils/calculators.dart';
import 'package:myputt/utils/colors.dart';
import 'package:myputt/utils/constants.dart';

class PerformanceChartPanel extends StatefulWidget {
  const PerformanceChartPanel({Key? key, required this.rangeTabController})
      : super(key: key);

  final TabController rangeTabController;

  @override
  _PerformanceChartPanelState createState() => _PerformanceChartPanelState();
}

class _PerformanceChartPanelState extends State<PerformanceChartPanel>
    with TickerProviderStateMixin {
  final Mixpanel _mixpanel = locator.get<Mixpanel>();
  final ChallengesRepository _challengesRepository =
      locator.get<ChallengesRepository>();
  final SessionRepository _sessionRepository = locator.get<SessionRepository>();
  final StatsService _statsService = locator.get<StatsService>();

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
    widget.rangeTabController.addListener(() {
      setState(() => _sessionRangeIndex = widget.rangeTabController.index);
      BlocProvider.of<HomeScreenCubit>(context)
          .updateTimeRangeIndex(widget.rangeTabController.index);
      BlocProvider.of<HomeScreenCubit>(context).reload();
    });
    _totalSets = _statsService.getTotalPuttingSets(
      _sessionRepository.allSessions,
      _challengesRepository.completedChallenges,
      _selectedDistance,
    );
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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    int? limit =
        _sessionRangeIndex == 3 ? null : indexToTimeRange[_sessionRangeIndex]!;
    final List<ChartPoint> _points =
        _statsService.getPointsWithDistanceAndLimit(
            _sessionRepository.allSessions,
            _challengesRepository.completedChallenges,
            _selectedDistance,
            limit);
    PerformanceChartData smoothData = smoothChart(
      PerformanceChartData(points: _points),
      _smoothRange,
    );
    return Column(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _sessionRangeTabBar(context),
            _points.isEmpty
                ? EmptyStateChart(
                    hasSessions: _sessionRepository.allSessions.isNotEmpty,
                  )
                : PerformanceChart(data: smoothData),
            Row(
              children: distancesRow
                  .map((distance) =>
                      Expanded(child: _chooseDistanceButton(context, distance)))
                  .toList(),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: Slider(
                    inactiveColor: MyPuttColors.white,
                    activeColor: MyPuttColors.darkBlue,
                    thumbColor: MyPuttColors.darkBlue,
                    label: _numSets.toString(),
                    onChanged: (double newValue) {
                      _mixpanel.track(
                        'Home Screen Performance Chart Slider Dragged',
                        properties: {'Value': newValue},
                      );
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
        controller: widget.rangeTabController,
        labelPadding: const EdgeInsets.all(0),
        indicatorPadding: const EdgeInsets.all(0),
        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        labelColor: MyPuttColors.darkBlue,
        unselectedLabelColor: Colors.black,
        tabs: const [
          Tab(child: Text('Last 5')),
          Tab(child: Text('Last 20')),
          Tab(child: Text('Last 50')),
          Tab(child: Text('All time')),
        ],
      ),
    );
  }

  Widget _chooseDistanceButton(BuildContext context, int distance) {
    return Bounceable(
      onTap: () {
        _mixpanel.track(
          'Home Screen Performance Chart Distance Button Pressed',
          properties: {'Distance': distance},
        );
        setState(() {
          _selectedDistance = distance;
          _totalSets = _statsService.getTotalPuttingSets(
            _sessionRepository.allSessions,
            _challengesRepository.completedChallenges,
            distance,
          );
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
                ?.copyWith(color: MyPuttColors.darkGray, fontSize: 16),
            maxLines: 1,
          ),
        ),
      ),
    );
  }
}
