part of 'sessions_cubit.dart';

@immutable
abstract class SessionsState {
  const SessionsState({required this.sessions});
  final List<PuttingSession> sessions;

  void addSession(session) {
    sessions.add(session);
  }
}

class SessionActive extends SessionsState {
  const SessionActive({
    required sessions,
    required this.currentSession,
    required this.individualStats,
    required this.currentSessionStats,
  }) : super(sessions: sessions);

  final PuttingSession currentSession;
  final Map<String, Stats> individualStats;
  final Stats currentSessionStats;
}

class NoActiveSession extends SessionsState {
  const NoActiveSession({required sessions, required this.individualStats})
      : super(sessions: sessions);
  final Map<String, Stats> individualStats;
}

class SessionErrorState extends SessionsState {
  const SessionErrorState({required sessions}) : super(sessions: sessions);
}

class SessionLoadingState extends SessionsState {
  const SessionLoadingState({required sessions}) : super(sessions: sessions);
}
