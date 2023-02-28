import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart' hide ModalBottomSheetRoute;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myputt/cubits/challenges_cubit.dart';
import 'package:myputt/cubits/home_screen_cubit.dart';
import 'package:myputt/cubits/my_profile_cubit.dart';
import 'package:myputt/cubits/sessions_cubit.dart';
import 'package:myputt/locator.dart';
import 'package:myputt/repositories/events_repository.dart';
import 'package:myputt/repositories/session_repository.dart';
import 'package:myputt/repositories/challenges_repository.dart';
import 'package:myputt/repositories/user_repository.dart';

void fetchLocalRepositoryData() {
  locator.get<SessionRepository>().fetchLocalCompletedSessions();
  locator.get<SessionRepository>().fetchLocalCurrentSession();
}

Future<void> fetchRepositoryData() async {
  fetchLocalRepositoryData();
  await locator.get<UserRepository>().fetchCurrentUser();
  await Future.wait([
    locator.get<SessionRepository>().fetchCloudCompletedSessions(),
    locator.get<SessionRepository>().fetchCloudCurrentSession(),
    locator.get<ChallengesRepository>().fetchAllChallenges(),
  ]);
  await locator.get<ChallengesRepository>().addDeepLinkChallenges();
}

void clearRepositoryData() {
  locator.get<SessionRepository>().clearData();
  locator.get<ChallengesRepository>().clearData();
  locator.get<UserRepository>().clearData();
  locator.get<EventsRepository>().clearData();
}

void reloadCubits(BuildContext context) {
  BlocProvider.of<HomeScreenCubit>(context).reload();
  BlocProvider.of<SessionsCubit>(context).emitUpdatedState();
  BlocProvider.of<ChallengesCubit>(context).reload();
  BlocProvider.of<MyProfileCubit>(context).reload();
}

bool hasConnectivity(ConnectivityResult? connectivityResult) {
  if (connectivityResult == null) {
    return true;
  }
  return [
    ConnectivityResult.wifi,
    ConnectivityResult.mobile,
    ConnectivityResult.vpn
  ].contains(connectivityResult);
}
