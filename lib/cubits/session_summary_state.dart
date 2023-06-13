part of 'session_summary_cubit.dart';

@immutable
abstract class SessionSummaryState {}

class SessionSummaryInitial extends SessionSummaryState {}

class SessionSummaryLoaded extends SessionSummaryState {
  SessionSummaryLoaded({required this.stats, required this.session});
  final PuttingSession session;
  final Stats stats;
}
