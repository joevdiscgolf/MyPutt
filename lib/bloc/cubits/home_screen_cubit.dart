import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:myputt/data/types/stats.dart';
import 'package:myputt/services/stats_service.dart';
import 'package:myputt/repositories/sessions_repository.dart';
import 'package:myputt/locator.dart';

part 'home_screen_state.dart';

class HomeScreenCubit extends Cubit<HomeScreenState> {
  final SessionRepository _sessionRepository = locator.get<SessionRepository>();
  final StatsService _statsService = locator.get<StatsService>();

  final Map<int, num> sessionRanges = {0: 5, 1: 20, 2: 50, 3: 0};

  int _currentSessionRange = 0;

  HomeScreenCubit() : super(HomeScreenLoading()) {
    reloadStats();
  }

  void newUserLoggedIn() {}

  void reloadStats() {
    final stats = _statsService.getStatsForSessionRange(
        sessionRanges[_currentSessionRange]!, _sessionRepository.allSessions);
    emit(HomeScreenLoaded(stats: stats, sessionRange: _currentSessionRange));
  }

  void updateSessionRange(int sessionRange) {
    _currentSessionRange = sessionRange;
  }
}
