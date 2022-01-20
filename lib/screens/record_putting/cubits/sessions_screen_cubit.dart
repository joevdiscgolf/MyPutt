import 'package:bloc/bloc.dart';
import 'package:intl/intl.dart';
import 'package:meta/meta.dart';
import 'package:myputt/data/types/putting_set.dart';
import 'package:myputt/data/types/putting_session.dart';
import 'package:myputt/repositories/sessions_repository.dart';
import 'package:myputt/locator.dart';

part 'sessions_screen_state.dart';

class SessionsScreenCubit extends Cubit<SessionsScreenState> {
  final SessionRepository _sessionRepository = locator.get<SessionRepository>();

  SessionsScreenCubit() : super(NoActiveSessionState(sessions: const []));

  void startSession() {
    print('start session');
    _sessionRepository.currentSession = PuttingSession(
        dateStarted:
            '${DateFormat.yMMMMd('en_US').format(DateTime.now()).toString()}, ${DateFormat.jm().format(DateTime.now()).toString()}',
        uid: 'myuid');
    emit(SessionInProgressState(
        sessions: _sessionRepository.allSessions,
        currentSession: _sessionRepository.currentSession ??
            PuttingSession(
                dateStarted:
                    '${DateFormat.yMMMMd('en_US').format(DateTime.now()).toString()}, ${DateFormat.jm().format(DateTime.now()).toString()}',
                uid: 'myuid')));
  }

  void continueSession() {
    print('continue session');
    emit(SessionInProgressState(
        sessions: _sessionRepository.allSessions,
        currentSession: _sessionRepository.currentSession ??
            PuttingSession(
                dateStarted:
                    '${DateFormat.yMMMMd('en_US').format(DateTime.now()).toString()}, ${DateFormat.jm().format(DateTime.now()).toString()}',
                uid: 'myuid')));
  }

  void completeSession() {
    _sessionRepository.addCompletedSession(_sessionRepository.currentSession!);
    emit(NoActiveSessionState(sessions: _sessionRepository.allSessions));
  }

  void addSet(PuttingSet set) {
    _sessionRepository.currentSession?.addSet(set);
    emit(SessionInProgressState(
        sessions: _sessionRepository.allSessions,
        currentSession: _sessionRepository.currentSession ??
            PuttingSession(
                dateStarted:
                    '${DateFormat.yMMMMd('en_US').format(DateTime.now()).toString()}, ${DateFormat.jm().format(DateTime.now()).toString()}',
                uid: 'myuid')));
  }

  void deleteSet(PuttingSet set) {}

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
