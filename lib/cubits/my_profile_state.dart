part of 'my_profile_cubit.dart';

@immutable
abstract class MyProfileState {}

class MyProfileInitial extends MyProfileState {}

class MyProfileLoaded extends MyProfileState {
  MyProfileLoaded({required this.myUser});
  final MyPuttUser myUser;
}

class NoProfileLoaded extends MyProfileState {
  NoProfileLoaded();
}
