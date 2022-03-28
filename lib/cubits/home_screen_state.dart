part of 'home_screen_cubit.dart';

@immutable
abstract class HomeScreenState {}

class HomeScreenInitial extends HomeScreenState {}

class HomeScreenLoading extends HomeScreenState {}

class HomeScreenLoaded extends HomeScreenState {
  HomeScreenLoaded(
      {required this.stats,
      required this.sessionRange,
      this.allSessions = const [],
      this.allChallenges = const [],
      this.events = const []});
  final Stats stats;
  final List<Event> events;
  final int sessionRange;
  final List<PuttingSession> allSessions;
  final List<PuttingChallenge> allChallenges;
}
