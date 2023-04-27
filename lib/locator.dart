import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:mixpanel_flutter/mixpanel_flutter.dart';
import 'package:myputt/cubits/app_phase_cubit.dart';
import 'package:myputt/cubits/challenges/challenge_cubit_helper.dart';
import 'package:myputt/cubits/challenges/challenges_cubit.dart';
import 'package:myputt/cubits/home/home_screen_v2_cubit.dart';
import 'package:myputt/protocols/singleton_consumer.dart';
import 'package:myputt/repositories/challenges_repository.dart';
import 'package:myputt/repositories/events_repository.dart';
import 'package:myputt/repositories/presets_repository.dart';
import 'package:myputt/repositories/session_repository.dart';
import 'package:myputt/repositories/user_repository.dart';
import 'package:myputt/services/challenges_service.dart';
import 'package:myputt/services/chart_service.dart';
import 'package:myputt/services/device_service.dart';
import 'package:myputt/services/firebase_auth_service.dart';
import 'package:myputt/services/beta_access_service.dart';
import 'package:myputt/services/database_service.dart';
import 'package:myputt/services/events_service.dart';
import 'package:myputt/services/localDB/local_db_service.dart';
import 'package:myputt/services/navigation_service.dart';
import 'package:myputt/services/shared_preferences_service.dart';
import 'package:myputt/services/myputt_auth_service.dart';
import 'package:myputt/services/stats_service.dart';
import 'package:myputt/services/toast/toast_service.dart';
import 'package:myputt/services/user_service.dart';
import 'package:myputt/services/web_scraper.dart';
import 'package:myputt/services/dynamic_link_service.dart';

import 'utils/constants.dart';

final locator = GetIt.instance;
Future<void> setUpLocator() async {
  final Mixpanel mixpanel = await Mixpanel.init(
    kDebugMode ? kMixpanelDevelopmentToken : kMixpanelProductionToken,
    optOutTrackingDefault: false,
  );
  locator.registerSingleton<Mixpanel>(mixpanel);
  locator.registerSingleton<AppPhaseCubit>(AppPhaseCubit());
  locator.registerSingleton<HomeScreenV2Cubit>(HomeScreenV2Cubit());
  locator.registerSingleton<ChallengesCubit>(ChallengesCubit());
  locator.registerSingleton<ChallengesCubitHelper>(ChallengesCubitHelper());
  locator
      .registerSingleton<SharedPreferencesService>(SharedPreferencesService());
  locator.registerSingleton<FirebaseAuthService>(FirebaseAuthService());
  locator.registerSingleton<DatabaseService>(DatabaseService());
  locator.registerSingleton<UserService>(UserService());
  locator.registerLazySingleton<ChallengesService>(() => ChallengesService());
  locator.registerSingleton<UserRepository>(UserRepository());
  locator.registerSingleton<SessionsRepository>(SessionsRepository());
  locator.registerSingleton<PresetsRepository>(PresetsRepository());
  locator.registerSingleton<ChallengesRepository>(ChallengesRepository());
  locator.registerSingleton<EventsRepository>(EventsRepository());
  locator.registerLazySingleton(() => StatsService());
  locator.registerLazySingleton(() => ChartService());
  locator.registerLazySingleton(() => MyPuttAuthService());
  locator.registerLazySingleton(() => WebScraperService());
  locator.registerLazySingleton(() => DynamicLinkService());
  locator.registerLazySingleton(() => EventsService());
  locator.registerSingleton<BetaAccessService>(BetaAccessService());
  locator.registerSingleton<LocalDBService>(LocalDBService());
  locator.registerLazySingleton(() => NavigationService());
  locator.registerSingleton<DeviceService>(DeviceService());
  locator.registerLazySingleton(() => ToastService());

  // initialize all services in repositories after
  final List<SingletonConsumer> repositories = [
    locator.get<ChallengesRepository>(),
    locator.get<SessionsRepository>(),
    locator.get<EventsRepository>(),
    locator.get<UserRepository>(),
  ];

  for (SingletonConsumer repository in repositories) {
    repository.initSingletons();
  }
}
