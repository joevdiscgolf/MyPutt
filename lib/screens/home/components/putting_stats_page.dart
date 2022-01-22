import 'package:flutter/material.dart';
import 'package:myputt/screens/home/components/percentages_card.dart';
import 'package:myputt/screens/home/components/enums.dart';

class PuttingStatsPage extends StatefulWidget {
  const PuttingStatsPage(
      {Key? key, required this.circle, required this.timeRange})
      : super(key: key);

  final TimeRange timeRange;
  final Circles circle;

  @override
  _PuttingStatsPageState createState() => _PuttingStatsPageState();
}

class _PuttingStatsPageState extends State<PuttingStatsPage> {
  final circleOnePercentages = {10: 0.75, 15: 0.6, 20: 0.6, 25: 0.4, 30: 0.3};
  final circleOneAllTimePercentages = {
    10: 0.9,
    15: 0.83,
    20: 0.45,
    25: 0.3,
    30: 0.2
  };
  final cirlceTwoPercentages = {40: 0.4, 50: 0.2, 60: 0.15};
  final circleTwoAllTimePercentages = {
    10: 0.9,
    15: 0.83,
    20: 0.45,
    25: 0.3,
    30: 0.2
  };

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        children: [
          Expanded(
            child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                ),
                child: PercentagesCard(
                  percentages: widget.circle == Circles.circle1
                      ? circleOnePercentages
                      : cirlceTwoPercentages,
                  allTimePercentages: widget.circle == Circles.circle1
                      ? circleOneAllTimePercentages
                      : circleTwoAllTimePercentages,
                )),
          ),
        ],
      ),
    );
  }
}
