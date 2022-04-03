import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:myputt/data/types/sessions/putting_set.dart';
import 'package:myputt/data/types/sessions/putting_session.dart';
import 'package:myputt/data/types/stats/stats.dart';
import 'package:myputt/repositories/user_repository.dart';
import 'package:myputt/services/stats_service.dart';
import 'package:myputt/repositories/session_repository.dart';
import 'package:myputt/locator.dart';

part 'sessions_state.dart';

class SessionsCubit extends Cubit<SessionsState> {
  final SessionRepository _sessionRepository = locator.get<SessionRepository>();
  final UserRepository _userRepository = locator.get<UserRepository>();
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

  Future<void> startNewSession() async {
    final String? currentUid = _userRepository.currentUser?.uid;
    if (currentUid != null) {
      final int now = DateTime.now().millisecondsSinceEpoch;
      final PuttingSession newSession = PuttingSession(
        timeStamp: now,
        id: '$currentUid~$now',
      );
      _sessionRepository.currentSession = newSession;
      emit(SessionInProgressState(
          sessions: _sessionRepository.allSessions,
          currentSession: _sessionRepository.currentSession!,
          individualStats: _statsService
              .generateSessionsStatsMap(_sessionRepository.allSessions),
          currentSessionStats: _statsService.getStatsForSession(
              _sessionRepository.allSessions,
              _sessionRepository.currentSession!)));
      final bool success = await _sessionRepository.startNewSession(newSession);
      if (success) {
        emit(SessionInProgressState(
            sessions: _sessionRepository.allSessions,
            currentSession: _sessionRepository.currentSession!,
            individualStats: _statsService
                .generateSessionsStatsMap(_sessionRepository.allSessions),
            currentSessionStats: _statsService.getStatsForSession(
                _sessionRepository.allSessions,
                _sessionRepository.currentSession!)));
      } else {
        emit(SessionErrorState(sessions: _sessionRepository.allSessions));
      }
    } else {
      emit(SessionErrorState(sessions: _sessionRepository.allSessions));
    }
  }

  void continueSession() {
    if (_sessionRepository.currentSession != null) {
      emit(SessionInProgressState(
        sessions: _sessionRepository.allSessions,
        currentSession: _sessionRepository.currentSession!,
        individualStats: _statsService
            .generateSessionsStatsMap(_sessionRepository.allSessions),
        currentSessionStats: _statsService.getStatsForSession(
            _sessionRepository.allSessions, _sessionRepository.currentSession!),
      ));
    } else {
      emit(SessionErrorState(sessions: _sessionRepository.allSessions));
    }
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
      emit(SessionErrorState(sessions: _sessionRepository.allSessions));
    }
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
