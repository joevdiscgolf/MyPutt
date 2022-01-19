import 'package:bloc/bloc.dart';
import 'package:intl/intl.dart';
import 'package:meta/meta.dart';
import 'package:myputt/data/types/putting_session.dart';
import 'package:myputt/services/session_manager.dart';
import 'package:myputt/locator.dart';

part 'sessions_screen_state.dart';

class SessionsScreenCubit extends Cubit<SessionsScreenState> {
  final SessionManager _sessionManager = locator.get<SessionManager>();

  SessionsScreenCubit()
      : super(SessionsScreenInitial(sessions: [
          PuttingSession(
              dateStarted:
                  '${DateFormat.yMMMMd('en_US').format(DateTime.now()).toString()}, ${DateFormat.jm().format(DateTime.now()).toString()}',
              uid: 'myuid')
        ]));

  void continueSession() {
    emit(SessionInProgressState(
        sessions: _sessionManager.allSessions,
        currentSession: _sessionManager.currentSession ??
            PuttingSession(
                dateStarted:
                    '${DateFormat.yMMMMd('en_US').format(DateTime.now()).toString()}, ${DateFormat.jm().format(DateTime.now()).toString()}',
                uid: 'myuid')));
  }

  void completeSession() {
    emit(NoActiveSessionState(sessions: _sessionManager.allSessions));
  }
}
