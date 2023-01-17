import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:mixpanel_flutter/mixpanel_flutter.dart';
import 'package:myputt/controllers/screen_controller.dart';
import 'package:myputt/repositories/challenges_repository.dart';
import 'package:myputt/repositories/events_repository.dart';
import 'package:myputt/repositories/presets_repository.dart';
import 'package:myputt/repositories/session_repository.dart';
import 'package:myputt/repositories/user_repository.dart';
import 'package:myputt/services/firebase_auth_service.dart';
import 'package:myputt/services/beta_access_service.dart';
import 'package:myputt/services/database_service.dart';
import 'package:myputt/services/events_service.dart';
import 'package:myputt/services/hive/hive_service.dart';
import 'package:myputt/services/init_manager.dart';
import 'package:myputt/services/navigation_service.dart';
import 'package:myputt/services/shared_preferences_service.dart';
import 'package:myputt/services/myputt_auth_service.dart';
import 'package:myputt/services/stats_service.dart';
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
  locator
      .registerSingleton<SharedPreferencesService>(SharedPreferencesService());
  locator.registerSingleton<ScreenController>(ScreenController());
  locator.registerSingleton<FirebaseAuthService>(FirebaseAuthService());
  locator.registerSingleton<DatabaseService>(DatabaseService());
  locator.registerSingleton<UserService>(UserService());
  locator.registerSingleton<UserRepository>(UserRepository());
  locator.registerSingleton<SessionRepository>(SessionRepository());
  locator.registerSingleton<PresetsRepository>(PresetsRepository());
  locator.registerSingleton<ChallengesRepository>(ChallengesRepository());
  locator.registerSingleton<EventsRepository>(EventsRepository());
  locator.registerLazySingleton(() => StatsService());
  locator.registerLazySingleton(() => MyPuttAuthService());
  locator.registerLazySingleton(() => InitManager());
  locator.registerLazySingleton(() => WebScraperService());
  locator.registerLazySingleton(() => DynamicLinkService());
  locator.registerLazySingleton(() => EventsService());
  locator.registerSingleton<BetaAccessService>(BetaAccessService());
  locator.registerSingleton<HiveService>(HiveService());
  locator.registerLazySingleton(() => NavigationService());
}
