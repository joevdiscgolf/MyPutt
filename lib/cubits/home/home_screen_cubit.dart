import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myputt/protocols/myputt_cubit.dart';
import 'package:myputt/models/data/challenges/putting_challenge.dart';
import 'package:myputt/models/data/sessions/putting_session.dart';
import 'package:myputt/models/data/stats/stats.dart';
import 'package:myputt/repositories/challenges_repository.dart';
import 'package:myputt/screens/home/components/calendar_view/utils.dart';
import 'package:myputt/services/stats_service.dart';
import 'package:myputt/repositories/session_repository.dart';
import 'package:myputt/locator.dart';
import 'package:myputt/utils/constants.dart';
import 'package:myputt/utils/enums.dart';

part 'home_screen_state.dart';

class HomeScreenCubit extends Cubit<HomeScreenState> implements MyPuttCubit {
  @override
  void initCubit() {
    // Implement init
  }

  final SessionsRepository _sessionRepository =
      locator.get<SessionsRepository>();
  final ChallengesRepository _challengesRepository =
      locator.get<ChallengesRepository>();
  final StatsService _statsService = locator.get<StatsService>();

  int timeRangeIndex = 0;

  HomeScreenCubit()
      : super(const HomeScreenLoading(selectedCircle: PuttingCircle.c1)) {
    reload();
  }

  void reload() {
    final Stats stats = _statsService.getStatsForRange(
      kIndexToTimeRange[timeRangeIndex]!,
      _sessionRepository.validCompletedSessions,
      _challengesRepository.completedChallenges,
    );
    final List<Event> events = _statsService.getCalendarEvents(
      _sessionRepository.validCompletedSessions,
      _challengesRepository.completedChallenges,
    );
    emit(
      HomeScreenLoaded(
        selectedCircle: PuttingCircle.c1,
        stats: stats,
        sessionRange: timeRangeIndex,
        allSessions: _sessionRepository.validCompletedSessions,
        allChallenges: _challengesRepository.completedChallenges,
        events: events,
        distanceRangeValues: const RangeValues(0, 100),
      ),
    );
  }

  void updateSelectedCircle(PuttingCircle newCircle) {
    if (state is HomeScreenLoaded) {
      final HomeScreenLoaded loadedState = state as HomeScreenLoaded;
      emit(HomeScreenLoaded(
        selectedCircle: newCircle,
        stats: loadedState.stats,
        sessionRange: loadedState.sessionRange,
        allSessions: loadedState.allSessions,
        allChallenges: loadedState.allChallenges,
        events: loadedState.events,
        distanceRangeValues: loadedState.distanceRangeValues,
      ));
    } else if (state is HomeScreenInitial) {
      emit(HomeScreenInitial(selectedCircle: newCircle));
    } else if (state is HomeScreenLoading) {
      emit(HomeScreenLoading(selectedCircle: newCircle));
    }
  }

  void updateDistanceRangeValues(RangeValues newValues) {
    if (state is HomeScreenLoaded) {
      final HomeScreenLoaded loadedState = state as HomeScreenLoaded;
      emit(HomeScreenLoaded(
          selectedCircle: loadedState.selectedCircle,
          stats: loadedState.stats,
          sessionRange: loadedState.sessionRange,
          allSessions: loadedState.allSessions,
          allChallenges: loadedState.allChallenges,
          events: loadedState.events,
          distanceRangeValues: newValues));
    }
  }

  void updateTimeRangeIndex(int newIndex) {
    timeRangeIndex = newIndex;
  }
}
