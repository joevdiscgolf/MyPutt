import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:myputt/data/types/challenges/putting_challenge.dart';
import 'package:myputt/data/types/putting_session.dart';
import 'package:myputt/data/types/stats/stats.dart';
import 'package:myputt/repositories/challenges_repository.dart';
import 'package:myputt/screens/home/components/calendar_view/utils.dart';
import 'package:myputt/services/stats_service.dart';
import 'package:myputt/repositories/session_repository.dart';
import 'package:myputt/locator.dart';
import 'package:myputt/utils/constants.dart';

part 'home_screen_state.dart';

class HomeScreenCubit extends Cubit<HomeScreenState> {
  final SessionRepository _sessionRepository = locator.get<SessionRepository>();
  final ChallengesRepository _challengesRepository =
      locator.get<ChallengesRepository>();
  final StatsService _statsService = locator.get<StatsService>();

  int timeRangeIndex = 0;

  HomeScreenCubit() : super(HomeScreenLoading()) {
    reload();
  }

  void reload() {
    final Stats stats = _statsService.getStatsForRange(
      indexToTimeRange[timeRangeIndex]!,
      _sessionRepository.allSessions,
      _challengesRepository.completedChallenges,
    );
    final List<Event> events = _statsService.getCalendarEvents(
        _sessionRepository.allSessions,
        _challengesRepository.completedChallenges);
    emit(HomeScreenLoaded(
        stats: stats,
        sessionRange: timeRangeIndex,
        allSessions: _sessionRepository.allSessions,
        allChallenges: _challengesRepository.completedChallenges,
        events: events));
  }

  void updateTimeRangeIndex(int newIndex) {
    timeRangeIndex = newIndex;
  }
}
