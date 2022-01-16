import 'package:get_it/get_it.dart';
import 'package:myputt/services/session_service.dart';

final locator = GetIt.instance; // GetIt.I is also valid
Future<void> setUpLocator() async {
  locator.registerSingleton<SessionService>(SessionService());
}
