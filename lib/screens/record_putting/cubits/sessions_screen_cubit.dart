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
    _sessionRepository.currentSession = PuttingSession(
        dateStarted:
            '${DateFormat.yMMMMd('en_US').format(DateTime.now()).toString()}, ${DateFormat.jm().format(DateTime.now()).toString()}',
        uid: 'myuid');
    SessionInProgressState(
        sessions: _sessionRepository.allSessions,
        currentSession: _sessionRepository.currentSession ??
            PuttingSession(
                dateStarted:
                    '${DateFormat.yMMMMd('en_US').format(DateTime.now()).toString()}, ${DateFormat.jm().format(DateTime.now()).toString()}',
                uid: 'myuid'));
  }

  void continueSession() {
    emit(SessionInProgressState(
        sessions: _sessionRepository.allSessions,
        currentSession: _sessionRepository.currentSession ??
            PuttingSession(
                dateStarted:
                    '${DateFormat.yMMMMd('en_US').format(DateTime.now()).toString()}, ${DateFormat.jm().format(DateTime.now()).toString()}',
                uid: 'myuid')));
  }

  void addSet(PuttingSet set) {
    print(_sessionRepository.allSessions);
    _sessionRepository.currentSession?.addSet(set);
    emit(SessionInProgressState(
        sessions: _sessionRepository.allSessions,
        currentSession: _sessionRepository.currentSession ??
            PuttingSession(
                dateStarted:
                    '${DateFormat.yMMMMd('en_US').format(DateTime.now()).toString()}, ${DateFormat.jm().format(DateTime.now()).toString()}',
                uid: 'myuid')));
  }

  void completeSession() {
    print('session completed, ${_sessionRepository.allSessions}');
    _sessionRepository.addCompletedSession(_sessionRepository.currentSession!);
    emit(NoActiveSessionState(sessions: _sessionRepository.allSessions));
  }
}
