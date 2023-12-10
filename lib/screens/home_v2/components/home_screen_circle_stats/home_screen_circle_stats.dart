import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:myputt/components/buttons/my_putt_button.dart';
import 'package:myputt/cubits/home/home_screen_v2_cubit.dart';
import 'package:myputt/locator.dart';
import 'package:myputt/models/data/stats/sets_interval.dart';
import 'package:myputt/screens/home_v2/components/home_screen_circle_stats/circle_stats_card.dart';
import 'package:myputt/services/navigation_service.dart';
import 'package:myputt/utils/colors.dart';
import 'package:myputt/utils/constants.dart';
import 'package:myputt/utils/enums.dart';
import 'package:myputt/utils/layout_helpers.dart';

class HomeScreenCircleStats extends StatelessWidget {
  const HomeScreenCircleStats({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeScreenV2Cubit, HomeScreenV2State>(
      builder: (context, state) {
        late final Map<PuttingCircle, Map<DistanceInterval, PuttingSetInterval>>
            circleToIntervalsMap;

        if (state is HomeScreenV2Loaded) {
          circleToIntervalsMap = state.circleToIntervalsMap;
        } else {
          circleToIntervalsMap = {};
        }

        if (noSets(state, circleToIntervalsMap)) {
          return _emptyState(context);
        }

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: addRunSpacing(
              kHomeScreenStatPuttingCircles
                  .map(
                    (circle) => CircleStatsCard(
                      circle: circle,
                      intervalToPuttingSetsData:
                          circleToIntervalsMap[circle] ?? {},
                    ),
                  )
                  .toList(),
              axis: Axis.vertical,
              runSpacing: 12,
            ),
          ),
        );
      },
    );
  }

  bool noSets(
    HomeScreenV2State homeScreenV2State,
    Map<PuttingCircle, Map<DistanceInterval, PuttingSetInterval>>
        circleToIntervalsMap,
  ) {
    return homeScreenV2State is HomeScreenV2Loaded &&
        circleToIntervalsMap.entries
                .firstWhereOrNull((entry) => entry.value.isNotEmpty) ==
            null;
  }

  Widget _emptyState(BuildContext context) {
    return Center(
      child: Column(
        children: [
          const Text("🤷‍", style: TextStyle(fontSize: 64)),
          FittedBox(
            child: Text(
              "We don't have any data yet...",
              style: Theme.of(context)
                  .textTheme
                  .titleLarge
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "Looks like you need to make some putts first.",
            style: Theme.of(context)
                .textTheme
                .bodyLarge
                ?.copyWith(color: MyPuttColors.gray[400]),
          ),
          const SizedBox(height: 20),
          MyPuttButton(
            height: 48,
            title: 'Start a session',
            fontWeight: FontWeight.w600,
            onPressed: () {
              locator.get<NavigationService>().setMainWrapperTab(1);
            },
            iconData: FlutterRemix.add_line,
            backgroundColor: MyPuttColors.darkGray,
          ),
        ],
      ),
    );
  }
}
