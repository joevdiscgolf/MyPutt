import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:myputt/cubits/home/data/enums.dart';
import 'package:myputt/cubits/home/data/home_screen_cubit_data.dart';
import 'package:myputt/locator.dart';
import 'package:myputt/models/data/challenges/putting_challenge.dart';
import 'package:myputt/models/data/sessions/putting_session.dart';
import 'package:myputt/models/data/sessions/putting_set.dart';
import 'package:myputt/models/data/stats/sets_interval.dart';
import 'package:myputt/repositories/challenges_repository.dart';
import 'package:myputt/repositories/session_repository.dart';
import 'package:myputt/utils/constants.dart';
import 'package:myputt/utils/helpers.dart';
import 'package:myputt/utils/set_helpers.dart';

part 'home_screen_v2_state.dart';

class HomeScreenV2Cubit extends Cubit<HomeScreenV2State> {
  HomeScreenV2Cubit() : super(const HomeScreenV2Initial());

  listenForChanges() {
    locator.get<SessionRepository>().addListener(() {
      onActivitiesUpdated();
    });
    locator.get<ChallengesRepository>().addListener(() {
      onActivitiesUpdated();
    });
  }

  late final StreamSubscription<SessionRepository>
      sessionRepositorySubscription;

  void onActivitiesUpdated() {
    final List<dynamic> puttingActivities = getPuttingActivitiesByTimeRange(
      locator.get<SessionRepository>().validCompletedSessions,
      locator.get<ChallengesRepository>().completedChallenges,
      [PuttingActivityType.session, PuttingActivityType.challenge],
      5,
    );

    final List<PuttingSet> setsInActivities =
        puttingSetsFromPuttingActivities(puttingActivities);

    if (state is HomeScreenV2Loaded) {
    } else {
      // emit(HomeScreenV2Loaded());
    }
  }
}

List<dynamic> getPuttingActivitiesByTimeRange(
  List<PuttingSession> sessions,
  List<PuttingChallenge> challenges,
  List<PuttingActivityType> puttingActivityTypes,
  int timeRange,
) {
  List<dynamic> allActivities = [];

  if (puttingActivityTypes.contains(PuttingActivityType.session)) {
    allActivities.addAll(sessions);
  }
  if (puttingActivityTypes.contains(PuttingActivityType.challenge)) {
    allActivities.addAll(challenges);
  }

  // sorted, merged list of sessions and challenges
  allActivities = sortSessionsAndChallengesByDate(allActivities);

  // 'all time' time range
  if (timeRange == 0) {
    return allActivities;
  } else {
    return allActivities.safeSubList(0, timeRange);
  }
}

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
