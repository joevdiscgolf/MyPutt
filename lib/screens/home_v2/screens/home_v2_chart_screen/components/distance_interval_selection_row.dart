import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myputt/cubits/home/home_screen_v2_cubit.dart';
import 'package:myputt/models/data/stats/sets_interval.dart';
import 'package:myputt/screens/home_v2/screens/home_v2_chart_screen/components/distance_interval_chip.dart';
import 'package:myputt/utils/colors.dart';
import 'package:myputt/utils/constants.dart';
import 'package:myputt/utils/enums.dart';
import 'package:myputt/utils/helpers.dart';

class DistanceIntervalSelectionRow extends StatelessWidget {
  const DistanceIntervalSelectionRow({
    Key? key,
    required this.circle,
    required this.distanceIntervals,
  }) : super(key: key);

  final PuttingCircle circle;
  final List<DistanceInterval> distanceIntervals;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.only(left: 24),
            alignment: Alignment.centerLeft,
            child: Text(
              kCircleToNameMap[circle]!,
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: MyPuttColors.gray[400],
                    fontWeight: FontWeight.w500,
                  ),
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: BlocConsumer<HomeScreenV2Cubit, HomeScreenV2State>(
              listener: (_, __) {},
              listenWhen: (_, __) => false,
              buildWhen: (previous, current) {
                return tryCast<HomeScreenV2Loaded>(previous)
                        ?.chartDistanceInterval !=
                    tryCast<HomeScreenV2Loaded>(current)?.chartDistanceInterval;
              },
              builder: (context, state) {
                return Wrap(
                  direction: Axis.horizontal,
                  spacing: 16,
                  runSpacing: 12,
                  children: distanceIntervals.map(
                    (interval) {
                      return DistanceIntervalChip(
                        distanceInterval: interval,
                        isSelected: state is HomeScreenV2Loaded &&
                            state.chartDistanceInterval == interval,
                      );
                    },
                  ).toList(),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
