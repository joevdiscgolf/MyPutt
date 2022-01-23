import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:myputt/data/types/stats.dart';
import 'package:myputt/data/types/general_stats.dart';
import 'package:myputt/repositories/sessions_repository.dart';
import 'package:myputt/locator.dart';

part 'home_screen_state.dart';

class HomeScreenCubit extends Cubit<HomeScreenState> {
  final SessionRepository _sessionRepository = locator.get<SessionRepository>();

  HomeScreenCubit() : super(HomeScreenLoading()) {
    emit(HomeScreenLoaded(
        stats: Stats(circleOnePercentages: {
      10: 0.75,
      15: 0.6,
      20: 0.6,
      25: 0.4,
      30: 0.3
    }, circleOneAverages: {
      10: 0.75,
      15: 0.6,
      20: 0.6,
      25: 0.4,
      30: 0.3
    }, circleTwoPercentages: {
      40: 0.4,
      50: 0.2,
      60: 0.15
    }, circleTwoAverages: {
      40: 0.4,
      50: 0.2,
      60: 0.15
    }, generalStats: GeneralStats(totalAttempts: 50, totalMade: 20))));
  }
}
