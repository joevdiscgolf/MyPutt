part of 'sessions_screen_cubit.dart';

@immutable
abstract class SessionsScreenState {
  const SessionsScreenState({required this.sessions});
  final List sessions;

  void addSession(session) {
    sessions.add(session);
  }
}

class SessionInProgressState extends SessionsScreenState {
  const SessionInProgressState(
      {required sessions, required this.currentSession})
      : super(sessions: sessions);

  final PuttingSession currentSession;
}

class NoActiveSessionState extends SessionsScreenState {
  const NoActiveSessionState({required sessions}) : super(sessions: sessions);
}

class SessionErrorState extends SessionsScreenState {
  const SessionErrorState({required sessions}) : super(sessions: sessions);
}
