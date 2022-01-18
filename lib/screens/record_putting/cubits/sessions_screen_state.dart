part of 'sessions_screen_cubit.dart';

@immutable
abstract class SessionsScreenState {
  const SessionsScreenState({required this.sessions});
  final List<PuttingSession> sessions;
}

class SessionsScreenInitial extends SessionsScreenState {
  const SessionsScreenInitial({required sessions}) : super(sessions: sessions);
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
