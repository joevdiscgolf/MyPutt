import 'package:get_it/get_it.dart';
import 'package:myputt/controllers/screen_controller.dart';
import 'package:myputt/repositories/challenges_repository.dart';
import 'package:myputt/repositories/events_repository.dart';
import 'package:myputt/repositories/presets_repository.dart';
import 'package:myputt/repositories/session_repository.dart';
import 'package:myputt/repositories/user_repository.dart';
import 'package:myputt/services/auth_service.dart';
import 'package:myputt/services/database_service.dart';
import 'package:myputt/services/events_service.dart';
import 'package:myputt/services/init_service.dart';
import 'package:myputt/services/shared_preferences_service.dart';
import 'package:myputt/services/signin_service.dart';
import 'package:myputt/services/stats_service.dart';
import 'package:myputt/services/user_service.dart';
import 'package:myputt/services/web_scraper.dart';
import 'package:myputt/services/dynamic_link_service.dart';

final locator = GetIt.instance;
Future<void> setUpLocator() async {
  locator
      .registerSingleton<SharedPreferencesService>(SharedPreferencesService());
  locator.registerSingleton<ScreenController>(ScreenController());
  locator.registerSingleton<AuthService>(AuthService());
  locator.registerSingleton<DatabaseService>(DatabaseService());
  locator.registerSingleton<UserService>(UserService());
  locator.registerSingleton<UserRepository>(UserRepository());
  locator.registerSingleton<SessionRepository>(SessionRepository());
  locator.registerSingleton<PresetsRepository>(PresetsRepository());
  locator.registerSingleton<ChallengesRepository>(ChallengesRepository());
  locator.registerSingleton<EventsRepository>(EventsRepository());
  locator.registerLazySingleton(() => StatsService());
  locator.registerLazySingleton(() => SigninService());
  locator.registerLazySingleton(() => InitService());
  locator.registerLazySingleton(() => WebScraperService());
  locator.registerLazySingleton(() => DynamicLinkService());
  locator.registerLazySingleton(() => EventsService());
}
