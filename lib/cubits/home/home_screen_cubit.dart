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

  HomeScreenCubit() : super(HomeScreenLoading()) {
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
        stats: stats,
        sessionRange: timeRangeIndex,
        allSessions: _sessionRepository.validCompletedSessions,
        allChallenges: _challengesRepository.completedChallenges,
        events: events,
      ),
    );
  }

  void updateTimeRangeIndex(int newIndex) {
    timeRangeIndex = newIndex;
  }
}
