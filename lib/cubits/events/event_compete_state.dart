part of 'event_compete_cubit.dart';

@immutable
abstract class EventCompeteState {}

class EventCompeteInitial extends EventCompeteState {}

class EventCompeteLoading extends EventCompeteState {}

class EventCompeteError extends EventCompeteState {
  EventCompeteError({this.error});
  final String? error;
}

class EventCompeteActive extends EventCompeteState {
  EventCompeteActive({required this.event, required this.eventPlayerData});

  final MyPuttEvent event;
  final EventPlayerData eventPlayerData;
}
