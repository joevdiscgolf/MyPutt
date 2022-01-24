part of 'sessions_cubit.dart';

@immutable
abstract class SessionsState {
  const SessionsState({required this.sessions});
  final List sessions;

  void addSession(session) {
    sessions.add(session);
  }
}

class SessionInProgressState extends SessionsState {
  const SessionInProgressState(
      {required sessions, required this.currentSession})
      : super(sessions: sessions);

  final PuttingSession currentSession;
}

class NoActiveSessionState extends SessionsState {
  const NoActiveSessionState({required sessions}) : super(sessions: sessions);
}

class SessionErrorState extends SessionsState {
  const SessionErrorState({required sessions}) : super(sessions: sessions);
}

class SessionLoadingState extends SessionsState {
  const SessionLoadingState({required sessions}) : super(sessions: sessions);
}
