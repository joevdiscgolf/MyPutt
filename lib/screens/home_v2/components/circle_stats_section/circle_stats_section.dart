import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myputt/cubits/home/home_screen_v2_cubit.dart';
import 'package:myputt/models/data/stats/sets_interval.dart';
import 'package:myputt/screens/home_v2/components/circle_stats_section/circle_stats_card.dart';
import 'package:myputt/utils/enums.dart';

class CircleStats extends StatelessWidget {
  const CircleStats({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeScreenV2Cubit, HomeScreenV2State>(
      builder: (context, state) {
        late final Map<Circles, Map<DistanceInterval, PuttingSetInterval>>
            circleToIntervalsMap;

        if (state is HomeScreenV2Loaded) {
          circleToIntervalsMap = state.circleToIntervalsMap;
        } else {
          circleToIntervalsMap = {};
        }

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Row(
            children: [
              Expanded(
                child: CircleStatsCard(
                  circle: Circles.circle1,
                  intervalToPuttingSetsData:
                      circleToIntervalsMap[Circles.circle1] ?? {},
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: CircleStatsCard(
                  circle: Circles.circle2,
                  intervalToPuttingSetsData:
                      circleToIntervalsMap[Circles.circle2] ?? {},
                ),
              )
            ],
          ),
        );
      },
    );
  }
}
