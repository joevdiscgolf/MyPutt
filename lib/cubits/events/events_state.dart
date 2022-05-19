part of 'events_cubit.dart';

@immutable
abstract class EventsState {}

class EventsInitial extends EventsState {}

class EventsLoading extends EventsState {}

class EventErrorState extends EventsState {
  EventErrorState({this.error});
  final String? error;
}

class ActiveEventState extends EventsState {
  ActiveEventState({required this.event, required this.eventPlayerData});

  final MyPuttEvent event;
  final EventPlayerData eventPlayerData;
}
