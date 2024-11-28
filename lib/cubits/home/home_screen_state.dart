part of 'home_screen_cubit.dart';

@immutable
abstract class HomeScreenState {
  const HomeScreenState({required this.selectedCircle});
  final PuttingCircle selectedCircle;
}

class HomeScreenInitial extends HomeScreenState {
  const HomeScreenInitial({required super.selectedCircle});
}

class HomeScreenLoading extends HomeScreenState {
  const HomeScreenLoading({required super.selectedCircle});
}

class HomeScreenLoaded extends HomeScreenState {
  const HomeScreenLoaded({
    required super.selectedCircle,
    required this.stats,
    required this.sessionRange,
    this.allSessions = const [],
    this.allChallenges = const [],
    this.events = const [],
    required this.distanceRangeValues,
  });

  final RangeValues distanceRangeValues;
  final Stats stats;
  final List<Event> events;
  final int sessionRange;
  final List<PuttingSession> allSessions;
  final List<PuttingChallenge> allChallenges;
}
