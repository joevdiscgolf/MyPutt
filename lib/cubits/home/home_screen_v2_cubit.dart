import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:myputt/cubits/home/data/enums.dart';
import 'package:myputt/cubits/home/data/home_screen_cubit_data.dart';
import 'package:myputt/locator.dart';
import 'package:myputt/models/data/conditions/conditions.dart';
import 'package:myputt/models/data/sessions/putting_set.dart';
import 'package:myputt/models/data/stats/sets_interval.dart';
import 'package:myputt/repositories/challenges_repository.dart';
import 'package:myputt/repositories/session_repository.dart';
import 'package:myputt/services/stats_service.dart';
import 'package:myputt/utils/constants.dart';
import 'package:myputt/utils/constants/distance_constants.dart';
import 'package:myputt/utils/distance_helpers.dart';
import 'package:myputt/utils/enums.dart';
import 'package:myputt/utils/set_helpers.dart';

part 'home_screen_v2_state.dart';

class HomeScreenV2Cubit extends Cubit<HomeScreenV2State> {
  HomeScreenV2Cubit() : super(const HomeScreenV2Initial());

  listenForRepositoryChanges() {
    locator.get<SessionRepository>().addListener(() {
      onRepositoryUpdated();
    });
    locator.get<ChallengesRepository>().addListener(() {
      onRepositoryUpdated();
    });
  }

  void onRepositoryUpdated() {
    late final int timeRange;
    if (state is HomeScreenV2Loaded) {
      timeRange = (state as HomeScreenV2Loaded).timeRange;
    } else {
      timeRange = TimeRange.allTime;
    }

    final List<dynamic> puttingActivities =
        locator.get<StatsService>().getPuttingActivitiesByTimeRange(
              locator.get<SessionRepository>().validCompletedSessions,
              locator.get<ChallengesRepository>().completedChallenges,
              [PuttingActivityType.session, PuttingActivityType.challenge],
              timeRange,
            );

    final List<PuttingSet> setsInActivities =
        puttingSetsFromPuttingActivities(puttingActivities);

    final Map<Circles, Map<DistanceInterval, PuttingSetInterval>>
        circleToIntervalsMap =
        locator.get<StatsService>().getSetIntervals(setsInActivities);

    if (state is HomeScreenV2Loaded) {
      emit(
        (state as HomeScreenV2Loaded).copyWith(
          {'circleToIntervalsMap': circleToIntervalsMap},
        ),
      );
    } else {
      // update later
      final DistanceInterval? initialDistanceInterval =
          DistanceHelpers.getPrimaryDistanceInterval(
        circleToIntervalsMap[Circles.circle1] ?? {},
      );

      emit(
        HomeScreenV2Loaded(
          sets: setsInActivities,
          circleToIntervalsMap: circleToIntervalsMap,
          chartDistanceInterval:
              initialDistanceInterval ?? kPreferredDistanceInterval,
          timeRange: TimeRange.allTime,
          chartDistance: null,
          homeChartFilters: HomeChartFilters(
            puttingActivityTypes: PuttingActivityType.values,
            puttingConditions: const PuttingConditions(),
          ),
        ),
      );
    }
  }

  void updateTimeRange(int updatedTimeRange) {
    final List<dynamic> puttingActivities =
        locator.get<StatsService>().getPuttingActivitiesByTimeRange(
              locator.get<SessionRepository>().validCompletedSessions,
              locator.get<ChallengesRepository>().completedChallenges,
              [PuttingActivityType.session, PuttingActivityType.challenge],
              updatedTimeRange,
            );

    final List<PuttingSet> setsInActivities =
        puttingSetsFromPuttingActivities(puttingActivities);

    final Map<Circles, Map<DistanceInterval, PuttingSetInterval>>
        circleToIntervalsMap =
        locator.get<StatsService>().getSetIntervals(setsInActivities);

    if (state is HomeScreenV2Loaded) {
      emit(
        (state as HomeScreenV2Loaded).copyWith(
          {
            'sets': setsInActivities,
            'circleToIntervalsMap': circleToIntervalsMap,
            'timeRange': updatedTimeRange,
          },
        ),
      );
    } else {
      final DistanceInterval? initialDistanceInterval =
          DistanceHelpers.getPrimaryDistanceInterval(
        circleToIntervalsMap[Circles.circle1] ?? {},
      );

      emit(
        HomeScreenV2Loaded(
          sets: setsInActivities,
          circleToIntervalsMap: circleToIntervalsMap,
          chartDistanceInterval:
              initialDistanceInterval ?? kPreferredDistanceInterval,
          timeRange: updatedTimeRange,
          chartDistance: null,
          homeChartFilters: HomeChartFilters(
            puttingActivityTypes: PuttingActivityType.values,
            puttingConditions: const PuttingConditions(),
          ),
        ),
      );
    }
  }
}
