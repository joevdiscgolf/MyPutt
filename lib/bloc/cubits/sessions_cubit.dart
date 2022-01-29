import 'package:bloc/bloc.dart';
import 'package:intl/intl.dart';
import 'package:meta/meta.dart';
import 'package:myputt/data/types/putting_set.dart';
import 'package:myputt/data/types/putting_session.dart';
import 'package:myputt/data/types/stats.dart';
import 'package:myputt/services/stats_service.dart';
import 'package:myputt/repositories/sessions_repository.dart';
import 'package:myputt/locator.dart';

part 'sessions_state.dart';

class SessionsCubit extends Cubit<SessionsState> {
  final SessionRepository _sessionRepository = locator.get<SessionRepository>();
  final StatsService _statsService = locator.get<StatsService>();

  SessionsCubit() : super(const SessionLoadingState(sessions: [])) {
    reload();
  }

  void reload() {
    if (_sessionRepository.currentSession != null) {
      emit(SessionInProgressState(
          sessions: _sessionRepository.allSessions,
          currentSession: _sessionRepository.currentSession!,
          individualStats: _statsService
              .generateSessionsStatsMap(_sessionRepository.allSessions),
          currentSessionStats: _statsService.getStatsForSession(
              _sessionRepository.allSessions,
              _sessionRepository.currentSession!)));
    } else {
      emit(NoActiveSessionState(
          sessions: _sessionRepository.allSessions,
          individualStats: _statsService
              .generateSessionsStatsMap(_sessionRepository.allSessions)));
    }
  }

  void startSession() {
    _sessionRepository.startCurrentSession();
    emit(SessionInProgressState(
        sessions: _sessionRepository.allSessions,
        currentSession: _sessionRepository.currentSession!,
        individualStats: _statsService
            .generateSessionsStatsMap(_sessionRepository.allSessions),
        currentSessionStats: _statsService.getStatsForSession(
            _sessionRepository.allSessions,
            _sessionRepository.currentSession!)));
  }

  void continueSession() {
    emit(SessionInProgressState(
      sessions: _sessionRepository.allSessions,
      currentSession: _sessionRepository.currentSession ??
          PuttingSession(
              dateStarted:
                  '${DateFormat.yMMMMd('en_US').format(DateTime.now()).toString()}, ${DateFormat.jm().format(DateTime.now()).toString()}'),
      individualStats: _statsService
          .generateSessionsStatsMap(_sessionRepository.allSessions),
      currentSessionStats: _statsService.getStatsForSession(
          _sessionRepository.allSessions, _sessionRepository.currentSession!),
    ));
  }

  Future<void> completeSession() async {
    await _sessionRepository
        .addCompletedSession(_sessionRepository.currentSession!);
    _sessionRepository.deleteCurrentSession();
    emit(NoActiveSessionState(
        sessions: _sessionRepository.allSessions,
        individualStats: _statsService
            .generateSessionsStatsMap(_sessionRepository.allSessions)));
  }

  void addSet(PuttingSet set) {
    _sessionRepository.addSet(set);
    emit(SessionInProgressState(
        sessions: _sessionRepository.allSessions,
        currentSession: _sessionRepository.currentSession ??
            PuttingSession(
                dateStarted:
                    '${DateFormat.yMMMMd('en_US').format(DateTime.now()).toString()}, ${DateFormat.jm().format(DateTime.now()).toString()}'),
        individualStats: _statsService
            .generateSessionsStatsMap(_sessionRepository.allSessions),
        currentSessionStats: _statsService.getStatsForSession(
            _sessionRepository.allSessions,
            _sessionRepository.currentSession!)));
  }

  void deleteSet(PuttingSet set) {
    _sessionRepository.deleteSet(set);
    if (state is SessionInProgressState) {
      if (_sessionRepository.currentSession != null) {
        emit(SessionInProgressState(
          sessions: _sessionRepository.allSessions,
          currentSession: _sessionRepository.currentSession!,
          individualStats: _statsService
              .generateSessionsStatsMap(_sessionRepository.allSessions),
          currentSessionStats: _statsService.getStatsForSession(
              _sessionRepository.allSessions,
              _sessionRepository.currentSession!),
        ));
      } else {
        emit(SessionErrorState(sessions: _sessionRepository.allSessions));
      }
    }
  }

  void deleteSession(PuttingSession session) {
    _sessionRepository.deleteSession(session);
    if (state is SessionInProgressState) {
      if (_sessionRepository.currentSession != null) {
        emit(SessionInProgressState(
            sessions: _sessionRepository.allSessions,
            individualStats: _statsService
                .generateSessionsStatsMap(_sessionRepository.allSessions),
            currentSessionStats: _statsService.getStatsForSession(
                _sessionRepository.allSessions,
                _sessionRepository.currentSession!),
            currentSession: _sessionRepository.currentSession!));
      } else {
        emit(SessionErrorState(sessions: _sessionRepository.allSessions));
      }
    } else {
      if (_sessionRepository.currentSession == null) {
        emit(NoActiveSessionState(
            sessions: _sessionRepository.allSessions,
            individualStats: _statsService
                .generateSessionsStatsMap(_sessionRepository.allSessions)));
      } else {
        emit(SessionErrorState(sessions: _sessionRepository.allSessions));
      }
    }
  }

  void deleteCurrentSession() {
    _sessionRepository.deleteCurrentSession();
    emit(NoActiveSessionState(
        sessions: _sessionRepository.allSessions,
        individualStats: _statsService
            .generateSessionsStatsMap(_sessionRepository.allSessions)));
  }
}
