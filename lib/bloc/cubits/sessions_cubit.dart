import 'package:bloc/bloc.dart';
import 'package:intl/intl.dart';
import 'package:meta/meta.dart';
import 'package:myputt/data/types/putting_set.dart';
import 'package:myputt/data/types/putting_session.dart';
import 'package:myputt/repositories/sessions_repository.dart';
import 'package:myputt/locator.dart';

part 'sessions_state.dart';

class SessionsCubit extends Cubit<SessionsState> {
  final SessionRepository _sessionRepository = locator.get<SessionRepository>();

  //SessionsCubit() : super(const NoActiveSessionState(sessions: []));
  SessionsCubit() : super(const SessionLoadingState(sessions: [])) {
    if (_sessionRepository.currentSession != null) {
      emit(SessionInProgressState(
          sessions: _sessionRepository.allSessions,
          currentSession: _sessionRepository.currentSession!));
    } else {
      emit(NoActiveSessionState(sessions: _sessionRepository.allSessions));
    }
  }

  void startSession() {
    _sessionRepository.startCurrentSession();
    emit(SessionInProgressState(
        sessions: _sessionRepository.allSessions,
        currentSession: _sessionRepository.currentSession!));
  }

  void continueSession() {
    emit(SessionInProgressState(
        sessions: _sessionRepository.allSessions,
        currentSession: _sessionRepository.currentSession ??
            PuttingSession(
                dateStarted:
                    '${DateFormat.yMMMMd('en_US').format(DateTime.now()).toString()}, ${DateFormat.jm().format(DateTime.now()).toString()}')));
  }

  Future<void> completeSession() async {
    await _sessionRepository
        .addCompletedSession(_sessionRepository.currentSession!);
    _sessionRepository.deleteCurrentSession();
    emit(NoActiveSessionState(sessions: _sessionRepository.allSessions));
  }

  void addSet(PuttingSet set) {
    _sessionRepository.addSet(set);
    emit(SessionInProgressState(
        sessions: _sessionRepository.allSessions,
        currentSession: _sessionRepository.currentSession ??
            PuttingSession(
                dateStarted:
                    '${DateFormat.yMMMMd('en_US').format(DateTime.now()).toString()}, ${DateFormat.jm().format(DateTime.now()).toString()}')));
  }

  void deleteSet(PuttingSet set) {
    _sessionRepository.deleteSet(set);
    if (state is SessionInProgressState) {
      if (_sessionRepository.currentSession != null) {
        emit(SessionInProgressState(
            sessions: _sessionRepository.allSessions,
            currentSession: _sessionRepository.currentSession!));
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
            currentSession: _sessionRepository.currentSession!));
      } else {
        emit(SessionErrorState(sessions: _sessionRepository.allSessions));
      }
    } else {
      if (_sessionRepository.currentSession != null) {
        emit(NoActiveSessionState(sessions: _sessionRepository.allSessions));
      } else {
        emit(SessionErrorState(sessions: _sessionRepository.allSessions));
      }
    }
  }
}
