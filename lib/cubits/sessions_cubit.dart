import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myputt/protocols/myputt_cubit.dart';
import 'package:myputt/models/data/sessions/putting_set.dart';
import 'package:myputt/models/data/sessions/putting_session.dart';
import 'package:myputt/models/data/stats/stats.dart';
import 'package:myputt/services/stats_service.dart';
import 'package:myputt/repositories/session_repository.dart';
import 'package:myputt/locator.dart';

part 'sessions_state.dart';

class SessionsCubit extends Cubit<SessionsState> implements MyPuttCubit {
  @override
  void initCubit() {
    // TODO: implement init
  }

  final SessionsRepository _sessionRepository =
      locator.get<SessionsRepository>();
  final StatsService _statsService = locator.get<StatsService>();

  SessionsCubit()
      : super(const SessionLoadingState(sessions: <PuttingSession>[]));

  Future<void> reloadCloudSessions() async {
    await Future.wait(
      [
        _sessionRepository.fetchCloudCompletedSessions(),
        _sessionRepository.fetchCloudCurrentSession()
      ],
    );
    emitUpdatedState();
  }

  void emitUpdatedState() {
    if (_sessionRepository.currentSession != null) {
      emit(
        SessionActive(
          sessions: _sessionRepository.validCompletedSessions,
          currentSession: _sessionRepository.currentSession!,
          individualStats: _statsService.generateSessionsStatsMap(
              _sessionRepository.validCompletedSessions),
          currentSessionStats: _statsService.getStatsForSession(
            _sessionRepository.validCompletedSessions,
            _sessionRepository.currentSession!,
          ),
        ),
      );
    } else {
      emit(
        NoActiveSession(
          sessions: _sessionRepository.validCompletedSessions,
          individualStats: _statsService.generateSessionsStatsMap(
            _sessionRepository.validCompletedSessions,
          ),
        ),
      );
    }
  }

  Future<void> startNewSession() async {
    final bool success = await _sessionRepository.startActiveSession();
    if (!success || _sessionRepository.currentSession == null) {
      // toast error
      return;
    }
    emit(
      SessionActive(
        sessions: _sessionRepository.validCompletedSessions,
        currentSession: _sessionRepository.currentSession!,
        individualStats: _statsService.generateSessionsStatsMap(
            _sessionRepository.validCompletedSessions),
        currentSessionStats: _statsService.getStatsForSession(
          _sessionRepository.validCompletedSessions,
          _sessionRepository.currentSession!,
        ),
      ),
    );

    emit(
      SessionActive(
        sessions: _sessionRepository.validCompletedSessions,
        currentSession: _sessionRepository.currentSession!,
        individualStats: _statsService.generateSessionsStatsMap(
            _sessionRepository.validCompletedSessions),
        currentSessionStats: _statsService.getStatsForSession(
          _sessionRepository.validCompletedSessions,
          _sessionRepository.currentSession!,
        ),
      ),
    );
  }

  void continueSession() {
    if (_sessionRepository.currentSession != null) {
      emit(SessionActive(
        sessions: _sessionRepository.validCompletedSessions,
        currentSession: _sessionRepository.currentSession!,
        individualStats: _statsService.generateSessionsStatsMap(
            _sessionRepository.validCompletedSessions),
        currentSessionStats: _statsService.getStatsForSession(
            _sessionRepository.validCompletedSessions,
            _sessionRepository.currentSession!),
      ));
    } else {
      emit(SessionErrorState(
          sessions: _sessionRepository.validCompletedSessions));
    }
  }

  Future<void> completeSession() async {
    await _sessionRepository
        .finishCurrentSession(_sessionRepository.currentSession!);
    _sessionRepository.deleteCurrentSession();
    emit(NoActiveSession(
        sessions: _sessionRepository.validCompletedSessions,
        individualStats: _statsService.generateSessionsStatsMap(
            _sessionRepository.validCompletedSessions)));
  }

  void addSet(PuttingSet set) {
    _sessionRepository.addSet(set);
    if (_sessionRepository.currentSession != null) {
      emit(SessionActive(
        sessions: _sessionRepository.validCompletedSessions,
        currentSession: _sessionRepository.currentSession!,
        individualStats: _statsService.generateSessionsStatsMap(
            _sessionRepository.validCompletedSessions),
        currentSessionStats: _statsService.getStatsForSession(
          _sessionRepository.validCompletedSessions,
          _sessionRepository.currentSession!,
        ),
      ));
    } else {
      emit(
        SessionErrorState(sessions: _sessionRepository.validCompletedSessions),
      );
    }
  }

  void deleteSet(PuttingSet set) {
    _sessionRepository.deleteSet(set);
    if (state is SessionActive) {
      if (_sessionRepository.currentSession != null) {
        emit(SessionActive(
          sessions: _sessionRepository.validCompletedSessions,
          currentSession: _sessionRepository.currentSession!,
          individualStats: _statsService.generateSessionsStatsMap(
              _sessionRepository.validCompletedSessions),
          currentSessionStats: _statsService.getStatsForSession(
              _sessionRepository.validCompletedSessions,
              _sessionRepository.currentSession!),
        ));
      } else {
        emit(SessionErrorState(
            sessions: _sessionRepository.validCompletedSessions));
      }
    }
  }

  Future<void> deleteCompletedSession(PuttingSession session) async {
    await _sessionRepository.deleteCompletedSession(session);

    if (state is SessionActive) {
      if (_sessionRepository.currentSession != null) {
        emit(SessionActive(
            sessions: _sessionRepository.validCompletedSessions,
            individualStats: _statsService.generateSessionsStatsMap(
              _sessionRepository.validCompletedSessions,
            ),
            currentSessionStats: _statsService.getStatsForSession(
                _sessionRepository.validCompletedSessions,
                _sessionRepository.currentSession!),
            currentSession: _sessionRepository.currentSession!));
      } else {
        emit(SessionErrorState(
            sessions: _sessionRepository.validCompletedSessions));
      }
    } else {
      if (_sessionRepository.currentSession == null) {
        emit(
          NoActiveSession(
            sessions: _sessionRepository.validCompletedSessions,
            individualStats: _statsService.generateSessionsStatsMap(
              _sessionRepository.validCompletedSessions,
            ),
          ),
        );
      } else {
        emit(SessionErrorState(
            sessions: _sessionRepository.validCompletedSessions));
      }
    }
  }

  void deleteCurrentSession() {
    _sessionRepository.deleteCurrentSession();
    emit(
      NoActiveSession(
        sessions: _sessionRepository.validCompletedSessions,
        individualStats: _statsService.generateSessionsStatsMap(
          _sessionRepository.validCompletedSessions,
        ),
      ),
    );
  }

  Future<void> onConnectionEstablished() async {
    await locator.get<SessionsRepository>().fetchCloudCompletedSessions();
    await locator.get<SessionsRepository>().syncLocalCompletedSessionsToCloud();
    emitUpdatedState();
  }
}
