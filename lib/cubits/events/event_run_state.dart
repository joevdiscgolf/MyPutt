part of 'event_run_cubit.dart';

@immutable
abstract class EventRunState {}

class EventRunInitial extends EventRunState {}

class EventRunLoading extends EventRunState {}

class EventRunError extends EventRunState {
  EventRunError({this.error});
  final String? error;
}

class EventRunActive extends EventRunState {
  EventRunActive({required this.event});

  final MyPuttEvent event;
}
