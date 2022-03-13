import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:myputt/data/types/putting_session.dart';
import 'package:myputt/data/types/stats/stats.dart';
import 'package:myputt/services/stats_service.dart';
import 'package:myputt/repositories/session_repository.dart';
import 'package:myputt/locator.dart';

part 'home_screen_state.dart';

class HomeScreenCubit extends Cubit<HomeScreenState> {
  final SessionRepository _sessionRepository = locator.get<SessionRepository>();
  final StatsService _statsService = locator.get<StatsService>();

  int timeRange = 0;

  HomeScreenCubit() : super(HomeScreenLoading()) {
    reloadStats();
  }

  void reloadStats() {
    final Stats stats = _statsService.getStatsForSessionRange(
        timeRange, _sessionRepository.allSessions);
    emit(HomeScreenLoaded(
        stats: stats,
        sessionRange: timeRange,
        allSessions: _sessionRepository.allSessions));
  }

  void updateSessionRange(int newRange) {
    timeRange = newRange;
  }
}
