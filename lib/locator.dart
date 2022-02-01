import 'package:get_it/get_it.dart';
import 'package:myputt/repositories/sessions_repository.dart';
import 'package:myputt/services/auth_service.dart';
import 'package:myputt/services/database_service.dart';
import 'package:myputt/services/signin_service.dart';
import 'package:myputt/services/stats_service.dart';

final locator = GetIt.instance;
Future<void> setUpLocator() async {
  locator.registerSingleton<AuthService>(AuthService());
  locator.registerSingleton<DatabaseService>(DatabaseService());
  locator.registerSingleton<SessionRepository>(SessionRepository());
  locator.registerSingleton<StatsService>(StatsService());
  locator.registerSingleton<SigninService>(SigninService());
}
