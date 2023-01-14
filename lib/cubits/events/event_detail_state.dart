part of 'event_detail_cubit.dart';

@immutable
abstract class EventDetailState {}

class EventDetailInitial extends EventDetailState {}

class EventDetailLoading extends EventDetailState {}

class EventDetailError extends EventDetailState {
  EventDetailError({this.error});
  final String? error;
}

class EventDetailLoaded extends EventDetailState {
  EventDetailLoaded({
    required this.event,
    required this.currentPlayerData,
  });

  final MyPuttEvent event;
  final EventPlayerData currentPlayerData;
}
