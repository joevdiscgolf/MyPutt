part of 'home_screen_cubit.dart';

@immutable
abstract class HomeScreenState {}

class HomeScreenInitial extends HomeScreenState {}

class HomeScreenLoading extends HomeScreenState {}

class HomeScreenLoaded extends HomeScreenState {
  HomeScreenLoaded({required this.stats, required this.sessionRange});
  final Stats stats;
  final int sessionRange;
}
