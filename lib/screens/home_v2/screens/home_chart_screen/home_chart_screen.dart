import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myputt/components/app_bars/myputt_app_bar.dart';
import 'package:myputt/cubits/home/home_screen_v2_cubit.dart';
import 'package:myputt/models/data/stats/sets_interval.dart';
import 'package:myputt/screens/home_v2/components/home_screen_chart_V2/home_screen_chart_v2_builder.dart';
import 'package:myputt/screens/home_v2/screens/home_chart_screen/components/distance_interval_selection_row.dart';
import 'package:myputt/screens/home_v2/screens/home_chart_screen/components/time_range_chips_row.dart';
import 'package:myputt/utils/constants.dart';
import 'package:myputt/utils/layout_helpers.dart';

class HomeChartScreen extends StatelessWidget {
  const HomeChartScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<Widget> children = [
      const TimeRangeChipsRow(),
      const SizedBox(height: 48),
      const HomeScreenChartV2Builder(height: 240),
      const SizedBox(height: 16),
      _intervalSelectionSection(),
    ];
    return Scaffold(
      appBar: MyPuttAppBar(
        title: 'Performance',
        topViewPadding: MediaQuery.of(context).viewPadding.top,
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 24),
        child: ListView.builder(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewPadding.bottom,
          ),
          itemBuilder: (context, index) => children[index],
          itemCount: children.length,
        ),
      ),
    );
  }

  Widget _intervalSelectionSection() {
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
