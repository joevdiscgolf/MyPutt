import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myputt/cubits/challenges_cubit.dart';
import 'package:myputt/cubits/home_screen_cubit.dart';
import 'package:myputt/cubits/my_profile_cubit.dart';
import 'package:myputt/cubits/sessions_cubit.dart';
import 'package:myputt/locator.dart';
import 'package:myputt/repositories/session_repository.dart';
import 'package:myputt/repositories/challenges_repository.dart';
import 'package:myputt/repositories/user_repository.dart';

Future<void> fetchRepositoryData() async {
  await locator.get<UserRepository>().fetchCurrentUser();
  await Future.wait([
    locator.get<SessionRepository>().fetchCompletedSessions(),
    locator.get<SessionRepository>().fetchCurrentSession(),
    locator.get<ChallengesRepository>().fetchAllChallenges(),
  ]);
  await locator.get<ChallengesRepository>().addDeepLinkChallenges();
}

void clearRepositoryData() {
  locator.get<SessionRepository>().clearData();
  locator.get<ChallengesRepository>().clearData();
  locator.get<UserRepository>().clearData();
}

void reloadCubits(BuildContext context) {
  BlocProvider.of<HomeScreenCubit>(context).reload();
  BlocProvider.of<SessionsCubit>(context).reload();
  BlocProvider.of<ChallengesCubit>(context).reload();
  BlocProvider.of<MyProfileCubit>(context).reload();
}

bool isConnected(ConnectivityResult connectivityResult) {
  return [
    ConnectivityResult.wifi,
    ConnectivityResult.mobile,
    ConnectivityResult.vpn
  ].contains(connectivityResult);
}
