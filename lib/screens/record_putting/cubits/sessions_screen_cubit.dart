import 'package:bloc/bloc.dart';
import 'package:intl/intl.dart';
import 'package:meta/meta.dart';
import 'package:myputt/data/types/putting_session.dart';
import 'package:myputt/services/session_service.dart';
import 'package:myputt/locator.dart';

part 'sessions_screen_state.dart';

class SessionsScreenCubit extends Cubit<SessionsScreenState> {
  final SessionService _sessionService = locator.get<SessionService>();
  SessionsScreenCubit()
      : super(SessionsScreenInitial(sessions: [
          PuttingSession(
              dateStarted:
                  '${DateFormat.yMMMMd('en_US').format(DateTime.now()).toString()}, ${DateFormat.jm().format(DateTime.now()).toString()}',
              uid: 'myuid')
        ]));

  void sessionInProgress(PuttingSession currentSession) {
    print('session in progress');
    emit(SessionInProgressState(
        sessions: _sessionService.allSessions, currentSession: currentSession));
  }

  void sessionComplete() {
    emit(NoActiveSessionState(sessions: _sessionService.allSessions));
  }
}
