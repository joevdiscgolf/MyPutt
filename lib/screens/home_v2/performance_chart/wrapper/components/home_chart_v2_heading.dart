import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:myputt/cubits/home/home_screen_v2_cubit.dart';
import 'package:myputt/utils/colors.dart';
import 'package:myputt/utils/constants/distance_constants.dart';
import 'package:myputt/utils/enums.dart';

class HomeChartV2Heading extends StatelessWidget {
  const HomeChartV2Heading({
    super.key,
    this.defaultCircle = PuttingCircle.c1,
  });

  final PuttingCircle defaultCircle;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeScreenV2Cubit, HomeScreenV2State>(
      builder: (context, state) {
        String rangeString =
            '${kDefaultDistanceInterval.lowerBound}-${kDefaultDistanceInterval.upperBound} ft';

        if (state is HomeScreenV2Loaded &&
            state.circleToSelectedDistanceInterval[defaultCircle] != null) {
          rangeString =
              '${state.circleToSelectedDistanceInterval[defaultCircle]!.lowerBound}-${state.circleToSelectedDistanceInterval[defaultCircle]!.upperBound} ft';
        }
        return Container(
          height: 50,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Putting performance',
                      style:
                          Theme.of(context).textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.w800,
                                color: MyPuttColors.offWhite,
                              ),
                    ),
                  ),
                  const SizedBox(width: 4),
                  Icon(
                    FlutterRemix.arrow_right_s_line,
                    size: 20,
                    color: MyPuttColors.gray[400],
                  ),
                ],
              ),
              const SizedBox(height: 2),
              Text(
                rangeString,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: MyPuttColors.gray[300],
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ],
          ),
        );
      },
    );
  }
}
