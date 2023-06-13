part of 'my_profile_cubit.dart';

@immutable
abstract class MyProfileState {}

class MyProfileInitial extends MyProfileState {}

class MyProfileLoaded extends MyProfileState {
  MyProfileLoaded({required this.myUser, required this.pdgaPlayerInfo});
  final MyPuttUser myUser;
  final PDGAPlayerInfo? pdgaPlayerInfo;
}

class NoProfileLoaded extends MyProfileState {
  NoProfileLoaded();
}
