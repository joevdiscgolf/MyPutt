part of 'event_standings_cubit.dart';

@immutable
abstract class EventStandingsState {}

class EventStandingsLoading extends EventStandingsState {}

class EventStandingsLoaded extends EventStandingsState {
  EventStandingsLoaded({required this.divisionStandings});

  final List<EventPlayerData> divisionStandings;
}

class EventStandingsError extends EventStandingsState {}
