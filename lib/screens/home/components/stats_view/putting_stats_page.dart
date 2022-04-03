import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myputt/cubits/home_screen_cubit.dart';
import 'package:myputt/cubits/session_summary_cubit.dart';
import 'package:myputt/screens/home/components/stats_view/percentages_card.dart';
import 'package:myputt/utils/enums.dart';

class PuttingStatsPage extends StatefulWidget {
  const PuttingStatsPage(
      {Key? key,
      required this.circle,
      required this.timeRange,
      required this.screenType})
      : super(key: key);

  final int timeRange;
  final Circles circle;
  final String screenType;

  @override
  _PuttingStatsPageState createState() => _PuttingStatsPageState();
}

class _PuttingStatsPageState extends State<PuttingStatsPage> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
          decoration: const BoxDecoration(
            color: Colors.white,
          ),
          child: widget.screenType == 'home'
              ? BlocBuilder<HomeScreenCubit, HomeScreenState>(
                  builder: (context, state) {
                    if (state is HomeScreenLoaded) {
                      return PercentagesCard(
                        percentages: widget.circle == Circles.circle1
                            ? state.stats.circleOnePercentages ?? {}
                            : state.stats.circleTwoPercentages ?? {},
                        timeRange: widget.timeRange,
                        allTimePercentages: widget.circle == Circles.circle1
                            ? state.stats.circleOneOverall ?? {}
                            : state.stats.circleTwoOverall ?? {},
                        allSessions: state.allSessions,
                      );
                    } else {
                      return const CircularProgressIndicator();
                    }
                  },
                )
              : BlocBuilder<SessionSummaryCubit, SessionSummaryState>(
                  builder: (context, state) {
                    if (state is SessionSummaryLoaded) {
                      return PercentagesCard(
                        percentages: widget.circle == Circles.circle1
                            ? state.stats.circleOnePercentages ?? {}
                            : state.stats.circleTwoPercentages ?? {},
                        allTimePercentages: widget.circle == Circles.circle1
                            ? state.stats.circleOneOverall ?? {}
                            : state.stats.circleTwoOverall ?? {},
                      );
                    } else {
                      return const CircularProgressIndicator();
                    }
                  },
                )),
    );
  }
}
