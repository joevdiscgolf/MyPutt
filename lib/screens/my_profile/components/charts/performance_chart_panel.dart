import 'package:flutter/material.dart';
import 'package:myputt/screens/my_profile/components/charts/performance_chart.dart';
import 'package:myputt/data/types/chart/chart_point.dart';
import 'package:myputt/locator.dart';
import 'package:myputt/repositories/challenges_repository.dart';
import 'package:myputt/repositories/session_repository.dart';
import 'package:myputt/services/stats_service.dart';

class PerformanceChartPanel extends StatefulWidget {
  const PerformanceChartPanel({Key? key}) : super(key: key);

  @override
  _PerformanceChartPanelState createState() => _PerformanceChartPanelState();
}

class _PerformanceChartPanelState extends State<PerformanceChartPanel> {
  final ChallengesRepository _challengesRepository =
      locator.get<ChallengesRepository>();
  final SessionRepository _sessionRepository = locator.get<SessionRepository>();
  final StatsService _statsService = locator.get<StatsService>();

  double _sliderValue = 1;
  late int _numSets;
  late int _totalSets;
  List<int> distances = [];
  int _selectedDistance = 20;

  @override
  void initState() {
    super.initState();
    _totalSets = _statsService.getTotalPuttingSets(
        _sessionRepository.allSessions,
        _challengesRepository.completedChallenges,
        _selectedDistance);
    _numSets = _totalSets;
    for (var distance = 10; distance <= 60; distance += 10) {
      distances.add(distance);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Distance',
            style: Theme.of(context).textTheme.headline6,
          ),
          Row(
            children: distances
                .map((distance) =>
                    Expanded(child: _chooseDistanceButton(context, distance)))
                .toList(),
          ),
          PerformanceChart(
              data: PerformanceChartData(
                  points: _statsService.getPointsWithDistanceAndLimit(
                      _sessionRepository.allSessions,
                      _challengesRepository.completedChallenges,
                      _selectedDistance,
                      _numSets))),
          _chartOptionsPanel(context),
        ],
      ),
      color: Colors.white,
    );
  }

  Widget _chartOptionsPanel(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Last',
                style: Theme.of(context).textTheme.headline6,
              ),
              const SizedBox(width: 5),
              Text(
                '$_numSets',
                style: Theme.of(context)
                    .textTheme
                    .headline6
                    ?.copyWith(color: Colors.blue),
              ),
              const SizedBox(width: 5),
              Text(
                _numSets == 1 ? 'Set' : 'Sets',
                style: Theme.of(context).textTheme.headline6,
              ),
            ],
          ),
          Row(
            children: [
              Expanded(
                child: Slider(
                  label: _numSets.toString(),
                  onChanged: (double newValue) {
                    setState(() {
                      _numSets = (newValue * _totalSets).toInt();
                      _sliderValue = newValue;
                    });
                  },
                  value: _sliderValue,
                ),
              )
            ],
          ),
        ],
      ),
    );
  }

  Widget _chooseDistanceButton(BuildContext context, int distance) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 2),
      child: ElevatedButton(
          style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              shadowColor: Colors.transparent,
              primary:
                  _selectedDistance == distance ? Colors.blue : Colors.white),
          onPressed: () {
            setState(() {
              _selectedDistance = distance;
              _totalSets = _statsService.getTotalPuttingSets(
                  _sessionRepository.allSessions,
                  _challengesRepository.completedChallenges,
                  distance);
              _numSets = (_sliderValue * _totalSets).toInt();
            });
          },
          child: Text(
            '$distance',
            style: Theme.of(context).textTheme.headline6?.copyWith(
                color:
                    _selectedDistance == distance ? Colors.white : Colors.blue),
          )),
    );
  }
}
