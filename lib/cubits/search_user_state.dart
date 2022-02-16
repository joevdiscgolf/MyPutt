part of 'search_user_cubit.dart';

@immutable
abstract class SearchUsersState {}

class SearchUsersInitial extends SearchUsersState {}

class SearchUsersLoading extends SearchUsersState {}

class SearchUsersLoaded extends SearchUsersState {
  SearchUsersLoaded({required this.users});
  final List<MyPuttUser> users;
}
