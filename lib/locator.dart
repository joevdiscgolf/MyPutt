import 'package:get_it/get_it.dart';
import 'package:myputt/repositories/session_repository.dart';

final locator = GetIt.instance; // GetIt.I is also valid
Future<void> setUpLocator() async {
  locator.registerSingleton<SessionRepository>(SessionRepository());
}
