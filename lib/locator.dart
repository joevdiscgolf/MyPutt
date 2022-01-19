import 'package:get_it/get_it.dart';
import 'package:myputt/repositories/sessions_repository.dart';

final locator = GetIt.instance;
Future<void> setUpLocator() async {
  locator.registerSingleton<SessionRepository>(SessionRepository());
}
