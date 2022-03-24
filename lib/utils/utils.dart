import 'package:myputt/locator.dart';
import 'package:myputt/repositories/session_repository.dart';
import 'package:myputt/repositories/challenges_repository.dart';
import 'package:myputt/repositories/user_repository.dart';
import 'package:myputt/data/types/challenges/challenge_structure_item.dart';
import 'package:myputt/data/types/putting_session.dart';

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

List<ChallengeStructureItem> challengeStructureFromSession(
    PuttingSession session) {
  return session.sets
      .map((set) => ChallengeStructureItem(
          distance: set.distance.toInt(),
          setLength: set.puttsAttempted.toInt()))
      .toList();
}
