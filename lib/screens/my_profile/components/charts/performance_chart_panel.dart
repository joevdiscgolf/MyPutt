import 'package:flutter/material.dart';
import 'package:myputt/screens/my_profile/components/charts/performance_chart.dart';
import 'package:myputt/data/types/chart/chart_point.dart';
import 'package:myputt/locator.dart';
import 'package:myputt/repositories/challenges_repository.dart';
import 'package:myputt/repositories/session_repository.dart';
import 'package:myputt/services/stats_service.dart';
import 'package:myputt/utils/calculators.dart';

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

  double _sliderValue = 0;
  double _smoothnessSliderValue = 0.5;
  late int _numSets;
  late int _totalSets;
  List<int> distances = [];
  int _selectedDistance = 20;
  int _smoothRange = 4;

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
    PerformanceChartData smoothData = smoothChart(
        PerformanceChartData(
            points: _statsService.getPointsWithDistanceAndLimit(
                _sessionRepository.allSessions,
                _challengesRepository.completedChallenges,
                _selectedDistance,
                _numSets)),
        _smoothRange);
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
          PerformanceChart(data: smoothData),
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
                  inactiveColor: Colors.blue,
                  activeColor: Colors.grey[400]!,
                  thumbColor: Colors.blue,
                  label: _numSets.toString(),
                  onChanged: (double newValue) {
                    setState(() {
                      _numSets = ((1 - newValue) * _totalSets).toInt();
                      _sliderValue = newValue;
                    });
                  },
                  value: _sliderValue,
                ),
              )
            ],
          ),
          Text(
            'Smoothness',
            style: Theme.of(context).textTheme.headline6,
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
    );
  }

  PerformanceChartData smoothChart(
      PerformanceChartData data, int comparisonRange) {
    final List<ChartPoint> points = data.points;
    final List<ChartPoint> newPoints = [];
    for (int index = 0; index < points.length; index++) {
      if (index == 0 || index == points.length - 1) {
        newPoints.add(points[index]);
      } else {
        final double avgAdjacent =
            weightedAverageOfAdjacent(points, comparisonRange, index);
        newPoints.add(comparisonRange == 0
            ? points[index]
            : ChartPoint(
                distance: points[index].distance,
                decimal: avgAdjacent,
                timeStamp: points[index].timeStamp,
                index: index));
      }
    }
    return PerformanceChartData(points: newPoints);
  }

  double weightedAverageOfAdjacent(
      List<ChartPoint> points, int range, int focusIndex) {
    double sumOfWeightings = 0;
    double weightedTotal = 0;
    sumOfWeightings *= 2;
    for (var index = 1; index < range + 1; index++) {
      if (focusIndex - index < 0) {
        break;
      } else {
        num weighting = range - (index - 1);
        sumOfWeightings += weighting;
        weightedTotal += weighting * points[focusIndex - index].decimal;
      }
    }

    for (var index = 1; index < range + 1; index++) {
      if (focusIndex + index > points.length - 1) {
        break;
      } else {
        num weighting = range - (index - 1);
        sumOfWeightings += weighting;
        weightedTotal += weighting * points[focusIndex + index].decimal;
      }
    }

    return sumOfWeightings.toDouble() == 0
        ? 1
        : dp((weightedTotal.toDouble() / sumOfWeightings.toDouble()), 4);
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
              _numSets = ((1 - _sliderValue) * _totalSets).toInt();
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
