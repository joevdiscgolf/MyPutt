part of 'event_run_cubit.dart';

@immutable
abstract class EventRunState {}

class EventRunLoading extends EventRunState {}

class EventRunError extends EventRunState {
  EventRunError({this.error});
  final String? error;
}

class EventRunComplete extends EventRunState {}

class EventRunActive extends EventRunState {
  EventRunActive({required this.event});

  final MyPuttEvent event;
}
