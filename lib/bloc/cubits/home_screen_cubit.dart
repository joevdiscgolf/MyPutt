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

  HomeScreenCubit() : super(HomeScreenLoading()) {
    final stats =
        _statsService.getStatsForSessions(2, _sessionRepository.allSessions);
    print(stats.circleOnePercentages);
    print(stats.circleOneAverages);
    emit(HomeScreenLoaded(stats: stats));
  }
}
