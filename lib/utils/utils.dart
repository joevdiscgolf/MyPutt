import 'package:myputt/locator.dart';
import 'package:myputt/repositories/session_repository.dart';
import 'package:myputt/repositories/challenges_repository.dart';
import 'package:myputt/repositories/user_repository.dart';

Future<void> fetchRepositoryData() async {
  print('fetching repository data');
  await locator.get<UserRepository>().fetchCurrentUser();
  await Future.wait([
    locator.get<SessionRepository>().fetchCompletedSessions(),
    locator.get<SessionRepository>().fetchCurrentSession(),
    locator.get<ChallengesRepository>().fetchAllChallenges(),
  ]);
}

void clearRepositoryData() {
  locator.get<SessionRepository>().clearData();
  // challenges repository.clearData();
}
