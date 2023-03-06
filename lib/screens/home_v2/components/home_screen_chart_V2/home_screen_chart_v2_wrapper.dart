import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';
import 'package:myputt/cubits/home/home_screen_v2_cubit.dart';
import 'package:myputt/screens/home_v2/components/home_screen_chart_V2/home_screen_chart_v2_builder.dart';
import 'package:myputt/screens/home_v2/screens/home_screen_chart_screen/home_screen_chart_screen.dart';
import 'package:myputt/utils/colors.dart';
import 'package:myputt/utils/constants/distance_constants.dart';

class HomeScreenChartV2Wrapper extends StatelessWidget {
  const HomeScreenChartV2Wrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Vibrate.feedback(FeedbackType.light);
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => const HomeScreenChartScreen(),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.only(top: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            _puttsMadeRow(context),
            const SizedBox(height: 16),
            const HomeScreenChartV2Builder(),
          ],
        ),
      ),
    );
  }

  Widget _puttsMadeRow(BuildContext context) {
    return BlocBuilder<HomeScreenV2Cubit, HomeScreenV2State>(
      builder: (context, state) {
        String rangeString =
            '${kPreferredDistanceInterval.lowerBound}-${kPreferredDistanceInterval.upperBound} ft';

        if (state is HomeScreenV2Loaded &&
            state.chartDistanceInterval != null) {
          rangeString =
              '${state.chartDistanceInterval!.lowerBound}-${state.chartDistanceInterval!.upperBound} ft';
        }
        return Padding(
          padding: const EdgeInsets.only(left: 24, right: 16),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  'Putts made (%)',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: MyPuttColors.gray[300],
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ),
              Text(
                rangeString,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: MyPuttColors.blue,
                      fontWeight: FontWeight.w600,
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
        );
      },
    );
  }
}
