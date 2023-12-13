import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:myputt/components/charts/distance_interval_performance_chart.dart';
import 'package:myputt/cubits/home/home_screen_v2_cubit.dart';
import 'package:myputt/models/data/stats/sets_interval.dart';
import 'package:myputt/utils/colors.dart';
import 'package:myputt/utils/constants.dart';
import 'package:myputt/utils/constants/distance_constants.dart';
import 'package:myputt/utils/enums.dart';

class CircleChartSection extends StatelessWidget {
  const CircleChartSection({super.key, required this.circle});

  final PuttingCircle circle;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeScreenV2Cubit, HomeScreenV2State>(
      builder: (context, homeScreenV2State) {
        if (homeScreenV2State is! HomeScreenV2Loaded) {
          return const SizedBox();
        }
        final DistanceInterval distanceInterval =
            homeScreenV2State.circleToSelectedDistanceInterval[circle] ??
                kDefaultDistanceInterval;
        return Padding(
          padding: const EdgeInsets.only(top: 8, bottom: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(
                  top: 8,
                  bottom: 16,
                  left: 16,
                  right: 40,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        '${kCircleToNameMap[circle]}',
                        style: Theme.of(context)
                            .textTheme
                            .headlineSmall
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                    ),
                    Container(
                      padding:
                          const EdgeInsets.only(top: 8, bottom: 8, left: 8),
                      color: Colors.transparent,
                      child: Row(
                        children: [
                          Text(
                            '${distanceInterval.lowerBound} - ${distanceInterval.upperBound} ft',
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(
                                  fontWeight: FontWeight.w500,
                                  color: MyPuttColors.gray[400],
                                ),
                          ),
                          const SizedBox(width: 8),
                          Icon(
                            FlutterRemix.arrow_right_s_line,
                            size: 16,
                            color: MyPuttColors.gray[400],
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              DistanceIntervalPerformanceChart(
                height: 120,
                distanceInterval: distanceInterval,
                chartDragData: null,
              ),
            ],
          ),
        );
      },
    );
  }
}
