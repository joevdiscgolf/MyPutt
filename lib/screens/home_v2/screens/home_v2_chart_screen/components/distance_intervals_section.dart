import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myputt/cubits/home/home_screen_v2_cubit.dart';
import 'package:myputt/models/data/stats/sets_interval.dart';
import 'package:myputt/screens/home_v2/screens/home_v2_chart_screen/components/distance_interval_selection_row.dart';
import 'package:myputt/utils/constants.dart';
import 'package:myputt/utils/layout_helpers.dart';

class DistanceIntervalsSection extends StatelessWidget {
  const DistanceIntervalsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeScreenV2Cubit, HomeScreenV2State>(
      builder: (context, state) {
        if (state is HomeScreenV2Loaded) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 24),
                child: Text(
                  'Distance (ft)',
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge
                      ?.copyWith(fontWeight: FontWeight.w600),
                ),
              ),
              const SizedBox(height: 16),
              ...addRunSpacing(
                kHomeScreenStatPuttingCircles.map((circle) {
                  return DistanceIntervalSelectionRow(
                    circle: circle,
                    distanceIntervals: state
                            .circleToIntervalsMap[circle]?.values
                            .map((PuttingSetInterval puttingSetInterval) =>
                                puttingSetInterval.distanceInterval)
                            .toList() ??
                        [],
                  );
                }).toList(),
                axis: Axis.vertical,
                runSpacing: 16,
              ),
            ],
          );
        } else {
          return const SizedBox();
        }
      },
    );
  }
}
