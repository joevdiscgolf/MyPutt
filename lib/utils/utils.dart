import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart' hide ModalBottomSheetRoute;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myputt/cubits/challenges/challenges_cubit.dart';
import 'package:myputt/cubits/home/home_screen_cubit.dart';
import 'package:myputt/cubits/my_profile_cubit.dart';
import 'package:myputt/cubits/sessions_cubit.dart';
import 'package:myputt/locator.dart';
import 'package:myputt/protocols/myputt_cubit.dart';
import 'package:myputt/protocols/singleton_consumer.dart';
import 'package:myputt/repositories/events_repository.dart';
import 'package:myputt/repositories/putting_preferences_repository.dart';
import 'package:myputt/repositories/session_repository.dart';
import 'package:myputt/repositories/challenges_repository.dart';
import 'package:myputt/repositories/user_repository.dart';

void fetchLocalRepositoryData() {
  // sessions
  locator.get<SessionsRepository>().fetchLocalCompletedSessions();
  locator.get<SessionsRepository>().fetchLocalCurrentSession();

  // challenges
  locator.get<ChallengesRepository>().fetchLocalChallenges();

  // current user
  locator.get<UserRepository>().fetchLocalCurrentUser();

  // saved putting conditions
  locator.get<PuttingPreferencesRepository>().fetchLocalPuttingPreferences();
}

Future<void> fetchRepositoryData() async {
  fetchLocalRepositoryData();
  await Future.wait([
    // sessions
    locator.get<SessionsRepository>().fetchCloudCompletedSessions(),
    locator.get<SessionsRepository>().fetchCloudCurrentSession(),

    // challenges
    locator.get<ChallengesRepository>().fetchCloudChallenges(),

    // current user
    locator.get<UserRepository>().fetchCloudCurrentUser(),
  ]);
  // Add back deep link challenge functionality in the future
  // await locator.get<ChallengesRepository>().addDeepLinkChallenges();
}

void clearRepositoryData() {
  locator.get<SessionsRepository>().clearData();
  locator.get<ChallengesRepository>().clearData();
  locator.get<UserRepository>().clearData();
  locator.get<EventsRepository>().clearData();
  locator.get<PuttingPreferencesRepository>().clearData();
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

void initAllSingletons(List<SingletonConsumer> singletonConsumers) {
  for (var consumer in singletonConsumers) {
    consumer.initSingletons();
  }
}

void initMyPuttCubits(List<MyPuttCubit> cubits) {
  for (var cubit in cubits) {
    cubit.initCubit();
  }
}
