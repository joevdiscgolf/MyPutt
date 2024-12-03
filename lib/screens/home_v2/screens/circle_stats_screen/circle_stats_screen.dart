import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myputt/components/charts/distance_interval_performance_chart.dart';
import 'package:myputt/cubits/home/home_screen_v2_cubit.dart';
import 'package:myputt/models/data/sessions/putting_set.dart';
import 'package:myputt/models/data/stats/sets_interval.dart';
import 'package:myputt/screens/home_v2/screens/circle_stats_screen/components/circle_percentages_screen_bar_chart.dart';
import 'package:myputt/screens/home_v2/screens/circle_stats_screen/components/circle_stats_screen_app_bar.dart';
import 'package:myputt/screens/home_v2/screens/circle_stats_screen/components/distance_picker_double_slider.dart';
import 'package:myputt/utils/colors.dart';
import 'package:myputt/utils/enums.dart';
import 'package:myputt/utils/helpers.dart';
import 'package:myputt/utils/set_helpers.dart';

class CircleStatsScreen extends StatelessWidget {
  const CircleStatsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CircleStatsScreenAppBar(),
      body: _mainBody(context),
      // const CircleDiagram(circle: PuttingCircle.c3),
    );
  }

  Widget _mainBody(BuildContext context) {
    return BlocBuilder<HomeScreenV2Cubit, HomeScreenV2State>(
      builder: (context, homeScreenV2State) {
        final PuttingCircle selectedCircle = homeScreenV2State.selectedCircle;

        final HomeScreenV2Loaded? homeScreenV2Loaded =
            tryCast<HomeScreenV2Loaded>(homeScreenV2State);

        return ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          children: [
            Container(
              color: MyPuttColors.gray[800],
              child: DistanceIntervalPerformanceChart(
                height: 200,
                distanceInterval: DistanceInterval(
                  lowerBound:
                      homeScreenV2Loaded?.distanceRangeValues.start.toInt() ??
                          0,
                  upperBound:
                      homeScreenV2Loaded?.distanceRangeValues.end.toInt() ?? 25,
                ),
                chartDragData: null,
                hasAxisLabels: false,
                isDarkBackground: true,
              ),
            ),
            const SizedBox(height: 16),
            const DistancePickerDoubleSlider(),
            Divider(
              height: 48,
              color: MyPuttColors.gray[100]!,
              indent: 24,
              endIndent: 24,
            ),
            Builder(
              builder: (context) {
                final HomeScreenV2Loaded? homeScreenV2Loaded =
                    tryCast<HomeScreenV2Loaded>(homeScreenV2State);

                final Map<PuttingCircle,
                        Map<DistanceInterval, PuttingSetInterval>>
                    circleToIntervalPercentages =
                    homeScreenV2Loaded?.circleToIntervalPercentages ?? {};

                final Map<DistanceInterval, PuttingSetInterval>
                    intervalsForCircle =
                    circleToIntervalPercentages[selectedCircle] ?? {};

                final List<PuttingSet> allSetsInCircle =
                    SetHelpers.getPuttingSetsFromIntervals(intervalsForCircle);
                final double percentageForCircle =
                    SetHelpers.percentageFromSets(allSetsInCircle);

                return Padding(
                  padding: const EdgeInsets.only(left: 24, right: 24, top: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              'Ranges',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge
                                  ?.copyWith(
                                    fontWeight: FontWeight.w600,
                                    color: MyPuttColors.darkGray,
                                  ),
                            ),
                          ),
                          Text(
                            allSetsInCircle.isEmpty
                                ? '--% overall'
                                : '${(percentageForCircle * 100).toStringAsFixed(0)}% overall',
                            style: Theme.of(context)
                                .textTheme
                                .titleSmall
                                ?.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: MyPuttColors.green,
                                ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      CirclePercentagesScreenBarChart(
                        circle: selectedCircle,
                        setIntervalsMap: intervalsForCircle,
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }
}
