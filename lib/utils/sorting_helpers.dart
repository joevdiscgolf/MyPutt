import 'package:myputt/models/data/challenges/putting_challenge.dart';
import 'package:myputt/models/data/sessions/putting_session.dart';

List<dynamic> sortSessionsAndChallengesByDate(
  List<dynamic> allActivities,
) {
  allActivities.sort((a1, a2) {
    late final int a1Timestamp;
    late final int a2Timestamp;

    if (a1 is PuttingSession) {
      a1Timestamp = a1.timeStamp;
    } else {
      a1Timestamp = (a1 as PuttingChallenge).creationTimeStamp;
    }

    if (a2 is PuttingSession) {
      a2Timestamp = a2.timeStamp;
    } else {
      a2Timestamp = (a2 as PuttingChallenge).creationTimeStamp;
    }

    return a2Timestamp.compareTo(a1Timestamp);
  });
  return allActivities;
}
