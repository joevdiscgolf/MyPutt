import 'package:get_it/get_it.dart';
import 'package:myputt/repositories/sessions_repository.dart';
import 'package:myputt/services/database_service.dart';

final locator = GetIt.instance;
Future<void> setUpLocator() async {
  locator.registerSingleton<DatabaseService>(DatabaseService());
  locator.registerSingleton<SessionRepository>(SessionRepository());
}
