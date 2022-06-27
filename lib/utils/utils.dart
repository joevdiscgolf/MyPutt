import 'package:myputt/locator.dart';
import 'package:myputt/repositories/session_repository.dart';
import 'package:myputt/repositories/challenges_repository.dart';
import 'package:myputt/repositories/user_repository.dart';

Future<void> fetchRepositoryData() async {
  await locator.get<UserRepository>().fetchCurrentUser();
  await Future.wait([
    locator.get<SessionRepository>().fetchCompletedSessions(),
    locator.get<SessionRepository>().fetchCurrentSession(),
    locator.get<ChallengesRepository>().fetchAllChallenges(),
  ]);
  await locator.get<ChallengesRepository>().addDeepLinkChallenges();
}

void clearRepositoryData() {
  locator.get<SessionRepository>().clearData();
  locator.get<ChallengesRepository>().clearData();
  locator.get<UserRepository>().clearData();
}
