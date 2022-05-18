part of 'events_cubit.dart';

@immutable
abstract class EventsState {}

class EventsInitial extends EventsState {}

class EventErrorState extends EventsState {
  EventErrorState({this.error});
  final String? error;
}

class ActiveEventState extends EventsState {
  ActiveEventState({required this.event, this.sets});

  final MyPuttEvent event;
  final List<PuttingSet>? sets;
}
