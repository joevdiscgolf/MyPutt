import 'package:bloc/bloc.dart';
import 'package:intl/intl.dart';
import 'package:meta/meta.dart';
import 'package:myputt/data/types/putting_session.dart';
import 'package:myputt/repositories/session_repository.dart';
import 'package:myputt/locator.dart';

part 'sessions_screen_state.dart';

class SessionsScreenCubit extends Cubit<SessionsScreenState> {
  final SessionRepository _sessionRepository = locator.get<SessionRepository>();

  SessionsScreenCubit()
      : super(SessionsScreenInitial(sessions: [
          PuttingSession(
              dateStarted:
                  '${DateFormat.yMMMMd('en_US').format(DateTime.now()).toString()}, ${DateFormat.jm().format(DateTime.now()).toString()}',
              uid: 'myuid')
        ]));

  void continueSession(PuttingSession currentSession) {
    emit(SessionInProgressState(
        sessions: _sessionRepository.allSessions,
        currentSession: currentSession));
  }

  void completeSession() {
    emit(NoActiveSessionState(sessions: _sessionRepository.allSessions));
  }
}
