import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myputt/bloc/cubits/home_screen_cubit.dart';
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
    return Column(
      children: [
        Expanded(
          child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
              ),
              child: BlocBuilder<HomeScreenCubit, HomeScreenState>(
                builder: (context, state) {
                  if (state is HomeScreenLoaded) {
                    return PercentagesCard(
                      percentages: widget.circle == Circles.circle1
                          ? state.stats.circleOnePercentages ?? {}
                          : state.stats.circleTwoPercentages ?? {},
                      allTimePercentages: widget.circle == Circles.circle1
                          ? state.stats.circleOneAverages ?? {}
                          : state.stats.circleTwoAverages ?? {},
                    );
                  } else {
                    return const CircularProgressIndicator();
                  }
                },
              )),
        ),
      ],
    );
  }
}
