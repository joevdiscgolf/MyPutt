import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:myputt/data/types/putting_session.dart';
import 'package:myputt/data/types/stats.dart';
import 'package:myputt/locator.dart';
import 'package:myputt/services/stats_service.dart';

part 'session_summary_state.dart';

class SessionSummaryCubit extends Cubit<SessionSummaryState> {
  final StatsService _statsService = locator.get<StatsService>();
  SessionSummaryCubit() : super(SessionSummaryInitial());

  void openSessionSummary(PuttingSession session) {
    emit(SessionSummaryLoaded(
        stats: _statsService.getStats(1, [session]), session: session));
  }
}
