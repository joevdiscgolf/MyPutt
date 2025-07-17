import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myputt/protocols/myputt_cubit.dart';
import 'package:myputt/models/data/sessions/putting_session.dart';
import 'package:myputt/models/data/stats/stats.dart';
import 'package:myputt/locator.dart';
import 'package:myputt/services/stats_service.dart';
import 'package:myputt/repositories/session_repository.dart';

part 'session_summary_state.dart';

class SessionSummaryCubit extends Cubit<SessionSummaryState>
    implements MyPuttCubit {
  @override
  void initCubit() {
    // todo: implement init
  }

  final SessionsRepository _sessionRepository =
      locator.get<SessionsRepository>();
  final StatsService _statsService = locator.get<StatsService>();
  SessionSummaryCubit() : super(SessionSummaryInitial());

  void openSessionSummary(PuttingSession session) {
    emit(SessionSummaryLoaded(
        stats: _statsService.getStatsForSession(
            _sessionRepository.validCompletedSessions, session),
        session: session));
  }
}
