import 'dart:math';

import 'package:myputt/cubits/home/data/enums.dart';
import 'package:myputt/models/data/chart/chart_point.dart';
import 'package:myputt/models/data/stats/sets_interval.dart';
import 'package:myputt/models/data/stats/stats.dart';
import 'package:myputt/models/data/stats/general_stats.dart';
import 'package:myputt/models/data/sessions/putting_session.dart';
import 'package:myputt/models/data/challenges/putting_challenge.dart';
import 'package:myputt/models/data/sessions/putting_set.dart';
import 'package:myputt/locator.dart';
import 'package:myputt/screens/home/components/calendar_view/utils.dart';
import 'package:myputt/utils/calculators.dart';
import 'package:myputt/utils/challenge_helpers.dart';
import 'package:myputt/utils/constants/distance_constants.dart';
import 'package:myputt/utils/enums.dart';
import 'package:myputt/utils/helpers.dart';
import 'package:myputt/utils/set_helpers.dart';
import 'package:myputt/utils/sorting_helpers.dart';

import 'firebase_auth_service.dart';

class StatsService {
  // limit is an num and it's the number of sessions to look back for stats.
  Stats getStatsForRange(
    int limit,
    List<PuttingSession> sessions,
    List<PuttingChallenge> challenges,
  ) {
    // filtering out challenges that were generated from a session of the user.
    challenges =
        ChallengeHelpers.filterDuplicateChallenges(sessions, challenges);

    Map<int, dynamic> timestampToSessionOrChallenge = {};
    for (PuttingSession session in sessions) {
      timestampToSessionOrChallenge[session.timeStamp] = session;
    }
    for (PuttingChallenge challenge in challenges) {
      timestampToSessionOrChallenge[challenge.completionTimeStamp ?? 0] =
          challenge;
    }

    List<int> timestamps = timestampToSessionOrChallenge.entries
        .map((entry) => entry.key)
        .toList();
    timestamps.sort((t2, t1) => t1.compareTo(t2));

    Map<int, num> rangePuttsAttempted = {};
    Map<int, num> rangePuttsMade = {};
    Map<int, num> overallPuttsAttempted = {};
    Map<int, num> overallPuttsMade = {};
    Map<int, num> circleOneOverallFractions = {};
    Map<int, num> circleTwoOverallFractions = {};

    Map<int, num?> circleOneRangeFractions = {
      10: null,
      15: null,
      20: null,
      25: null,
      30: null
    };
    Map<int, num?> circleTwoRangeFractions = {
      40: null,
      50: null,
      60: null,
    };

    int totalAttempts = 0;
    int totalMade = 0;

    for (int index = 0; index < timestamps.length; index++) {
      final int timestamp = timestamps[index];
      final dynamic value = timestampToSessionOrChallenge[timestamp];
      List<PuttingSet> sets = [];
      if (value is PuttingSession) {
        final PuttingSession session = value;
        sets = session.sets;
      } else if (value is PuttingChallenge) {
        final PuttingChallenge challenge = value;
        sets = challenge.currentUserSets;
      }
      for (PuttingSet set in sets) {
        final int distance = set.distance;

        totalAttempts += set.puttsAttempted;
        totalMade += set.puttsMade;

        overallPuttsAttempted[distance] =
            overallPuttsAttempted[distance] == null
                ? set.puttsAttempted
                : overallPuttsAttempted[distance]! + set.puttsAttempted;
        overallPuttsMade[distance] = overallPuttsMade[distance] == null
            ? set.puttsMade
            : overallPuttsMade[distance]! + set.puttsMade;

        if (index < limit || limit == 0) {
          rangePuttsAttempted[distance] = rangePuttsAttempted[distance] == null
              ? set.puttsAttempted
              : rangePuttsAttempted[distance]! + set.puttsAttempted;

          rangePuttsMade[distance] = rangePuttsMade[distance] == null
              ? set.puttsMade
              : rangePuttsMade[distance]! + set.puttsMade;
        }
      }
    }

    for (var entry in rangePuttsAttempted.entries) {
      if (rangePuttsMade[entry.key] != null) {
        if (entry.key < 40) {
          circleOneRangeFractions[entry.key] =
              rangePuttsMade[entry.key]! / entry.value;
        } else {
          circleTwoRangeFractions[entry.key] =
              rangePuttsMade[entry.key]! / entry.value;
        }
      }
    }

    for (var entry in overallPuttsAttempted.entries) {
      if (overallPuttsMade[entry.key] != null) {
        if (entry.key < 40) {
          circleOneOverallFractions[entry.key] =
              overallPuttsMade[entry.key]! / entry.value;
        } else {
          circleTwoOverallFractions[entry.key] =
              overallPuttsMade[entry.key]! / entry.value;
        }
      }
    }

    return Stats(
      circleOnePercentages: circleOneRangeFractions,
      circleTwoPercentages: circleTwoRangeFractions,
      circleOneOverall: circleOneOverallFractions,
      circleTwoOverall: circleTwoOverallFractions,
      generalStats: GeneralStats(
        totalAttempts: totalAttempts,
        totalMade: totalMade,
      ),
    );
  }

  Stats getStatsForSession(
      List<PuttingSession> sessions, PuttingSession focusSession) {
    Map<int, num> focusSessionPuttsAttempted = {};
    Map<int, num> focusSessionPuttsMade = {};
    Map<int, num> overallPuttsAttempted = {};
    Map<int, num> overallPuttsMade = {};

    Map<int, num?> circleOneFocusFractions = {
      10: null,
      15: null,
      20: null,
      25: null,
      30: null
    };
    Map<int, num?> circleTwoFocusFractions = {
      40: null,
      50: null,
      60: null,
    };

    Map<int, num> circleOneOverallFractions = {};
    Map<int, num> circleTwoOverallFractions = {};

    int totalAttempts = 0;
    int totalMade = 0;

    final sessionsInOrder = List.from(sessions).reversed;
    for (var session in sessionsInOrder) {
      final sets = session.sets;
      for (var set in sets) {
        final distance = set.distance;

        overallPuttsAttempted[distance] =
            overallPuttsAttempted[distance] == null
                ? set.puttsAttempted
                : overallPuttsAttempted[distance]! + set.puttsAttempted;
        overallPuttsMade[distance] = overallPuttsMade[distance] == null
            ? set.puttsMade
            : overallPuttsMade[distance]! + set.puttsMade;
      }
    }

    final focusSessionSets = focusSession.sets;
    for (var set in focusSessionSets) {
      final distance = set.distance;
      totalAttempts += set.puttsAttempted;
      totalMade += set.puttsMade;
      focusSessionPuttsAttempted[distance] =
          focusSessionPuttsAttempted[distance] == null
              ? set.puttsAttempted
              : focusSessionPuttsAttempted[distance]! + set.puttsAttempted;

      focusSessionPuttsMade[distance] = focusSessionPuttsMade[distance] == null
          ? set.puttsMade
          : focusSessionPuttsMade[distance]! + set.puttsMade;
    }

    for (var entry in focusSessionPuttsAttempted.entries) {
      if (focusSessionPuttsMade[entry.key] != null) {
        if (entry.key < 40) {
          circleOneFocusFractions[entry.key] =
              focusSessionPuttsMade[entry.key]! / entry.value;
        } else {
          circleTwoFocusFractions[entry.key] =
              focusSessionPuttsMade[entry.key]! / entry.value;
        }
      }
    }

    for (var entry in overallPuttsAttempted.entries) {
      if (overallPuttsMade[entry.key] != null) {
        if (entry.key < 40) {
          circleOneOverallFractions[entry.key] =
              overallPuttsMade[entry.key]! / entry.value;
        } else {
          circleTwoOverallFractions[entry.key] =
              overallPuttsMade[entry.key]! / entry.value;
        }
      }
    }

    return Stats(
      circleOnePercentages: circleOneFocusFractions,
      circleTwoPercentages: circleTwoFocusFractions,
      circleOneOverall: circleOneOverallFractions,
      circleTwoOverall: circleTwoOverallFractions,
      generalStats: GeneralStats(
        totalAttempts: totalAttempts,
        totalMade: totalMade,
      ),
    );
  }

  Stats statsFromSets(List<PuttingSet> sets) {
    Map<int, num> puttsAttempted = {};
    Map<int, num> puttsMade = {};

    Map<int, num?> circleOneFractions = {
      10: null,
      15: null,
      20: null,
      25: null,
      30: null
    };
    Map<int, num?> circleTwoFractions = {
      40: null,
      50: null,
      60: null,
    };

    int totalAttempts = 0;
    int totalMade = 0;

    for (var set in sets) {
      final distance = set.distance;
      totalAttempts += set.puttsAttempted;
      totalMade += set.puttsMade;
      puttsAttempted[distance] = (puttsAttempted[distance] == null
              ? set.puttsAttempted
              : puttsAttempted[distance]! + set.puttsAttempted)
          .toDouble();

      puttsMade[distance] = puttsMade[distance] == null
          ? set.puttsMade
          : puttsMade[distance]! + set.puttsMade;
    }

    for (var entry in puttsAttempted.entries) {
      if (puttsMade[entry.key] != null) {
        if (entry.key < 40) {
          circleOneFractions[entry.key] = puttsMade[entry.key]! / entry.value;
        } else {
          circleTwoFractions[entry.key] = puttsMade[entry.key]! / entry.value;
        }
      }
    }

    return Stats(
        circleOnePercentages: circleOneFractions,
        circleTwoPercentages: circleTwoFractions,
        generalStats: GeneralStats(
          totalAttempts: totalAttempts,
          totalMade: totalMade,
        ));
  }

  EventStats getEventStats(List<PuttingSet> sets) {
    int c1Attempts = 0;
    int c1Makes = 0;
    int c2Attempts = 0;
    int c2Makes = 0;

    for (PuttingSet set in sets) {
      if (set.distance <= 30) {
        c1Attempts += set.puttsAttempted;
        c1Makes += set.puttsMade;
      } else {
        c2Attempts += set.puttsAttempted;
        c2Makes += set.puttsMade;
      }
    }

    final double? c1Percentage = c1Attempts > 0 ? c1Makes / c1Attempts : null;
    final double? c2Percentage = c2Attempts > 0 ? c2Makes / c2Attempts : null;
    final double? overallPercentage = (c1Attempts + c2Attempts) > 0
        ? (c1Makes + c2Makes) / (c1Attempts + c2Attempts)
        : null;

    return EventStats(
      c1Percentage: c1Percentage,
      c2Percentage: c2Percentage,
      overallPercentage: overallPercentage,
    );
  }

  Map<String, Stats> generateSessionsStatsMap(
      List<PuttingSession> allSessions) {
    Map<String, Stats> statsMap = {};

    for (var session in allSessions) {
      statsMap[session.id] = getStatsForSession(allSessions, session);
    }
    return statsMap;
  }

  int getPuttCountFromSessions(List<PuttingSession> sessions, bool puttsMade) {
    int total = 0;
    for (var session in sessions) {
      for (var set in session.sets) {
        total += puttsMade ? set.puttsMade.toInt() : set.puttsAttempted.toInt();
      }
    }
    return total;
  }

  int getPuttCountFromChallenges(
      List<PuttingChallenge> challenges, bool puttsMade) {
    int total = 0;
    for (var challenge in challenges) {
      for (var set in challenge.currentUserSets) {
        total += puttsMade ? set.puttsMade.toInt() : set.puttsAttempted.toInt();
      }
    }
    return total;
  }

  double? getPercentageWithCutoff(List<PuttingSession> sessions,
      List<PuttingChallenge> challenges, int cutoff) {
    double totalMade = 0;
    double totalAttmpted = 0;
    for (var session in sessions) {
      for (var set in session.sets) {
        if (set.distance > cutoff) {
          totalMade += set.puttsMade;
          totalAttmpted += set.puttsAttempted;
        }
      }
    }
    for (var challenge in challenges) {
      for (var set in challenge.currentUserSets) {
        if (set.distance > cutoff) {
          totalMade += set.puttsMade;
          totalAttmpted += set.puttsAttempted;
        }
      }
    }
    return totalAttmpted == 0 ? null : (totalMade / totalAttmpted);
  }

  int getNumChallengesWithResult(
      List<PuttingChallenge> challenges, ChallengeResult result) {
    int total = 0;
    for (var challenge in challenges) {
      final int currentUserPuttsMade =
          totalMadeFromSets(challenge.currentUserSets);
      final int opponentPuttsMade = totalMadeFromSubset(
          challenge.opponentSets, challenge.currentUserSets.length);
      final int puttsMadeDifference = currentUserPuttsMade - opponentPuttsMade;
      if (result == ChallengeResult.win) {
        if (puttsMadeDifference > 0) {
          total += 1;
        }
      } else if (result == ChallengeResult.loss) {
        if (puttsMadeDifference < 0) {
          total += 1;
        }
      } else if (result == ChallengeResult.draw) {
        if (puttsMadeDifference == 0) {
          total += 1;
        }
      }
    }
    return total;
  }

  List<ChartPoint> getPointsWithDistanceAndLimit(List<PuttingSession> sessions,
      List<PuttingChallenge> challenges, int distance, int? limit) {
    final FirebaseAuthService _authService = locator.get<FirebaseAuthService>();
    final String? currentUid = _authService.getCurrentUserId();

    if (currentUid == null) {
      return [];
    }
    List<ChartPoint> points = [];

    challenges =
        ChallengeHelpers.filterDuplicateChallenges(sessions, challenges);

    Map<int, dynamic> timestampToSessionOrChallenge = {};
    for (PuttingSession session in sessions) {
      timestampToSessionOrChallenge[session.timeStamp] = session;
    }
    for (PuttingChallenge challenge in challenges) {
      timestampToSessionOrChallenge[challenge.completionTimeStamp ?? 0] =
          challenge;
    }

    List<int> timestamps = timestampToSessionOrChallenge.entries
        .map((entry) => entry.key)
        .toList();
    timestamps.sort((t2, t1) => t1.compareTo(t2));

    for (int index = 0;
        index <
            (limit == null ? timestamps.length : min(timestamps.length, limit));
        index++) {
      int timestamp = timestamps[index];
      final dynamic value = timestampToSessionOrChallenge[timestamp];
      List<PuttingSet> sets = [];
      if (value is PuttingSession) {
        final PuttingSession session = value;
        sets = session.sets;
      } else if (value is PuttingChallenge) {
        final PuttingChallenge challenge = value;
        sets = challenge.currentUserSets;
      }
      sets = sets.where((oldSet) => oldSet.distance == distance).toList();
      for (PuttingSet set in sets) {
        final double decimal = set.puttsAttempted.toDouble() == 0
            ? 0
            : (set.puttsMade.toDouble() / set.puttsAttempted.toDouble());
        points.add(ChartPoint(
            index: index,
            timeStamp: set.timeStamp ??
                (value is PuttingSession
                    ? value.timeStamp
                    : value.completionTimeStamp ?? value.creationTimeStamp),
            distance: set.distance.toInt(),
            decimal: decimal));
      }
    }

    points.sort((p1, p2) {
      final int timestampDifference = p1.timeStamp.compareTo(p2.timeStamp);
      return timestampDifference != 0
          ? timestampDifference
          : p1.index.compareTo(p2.index);
    });

    return List.from(points);
  }

  int getTotalPuttingSets(List<PuttingSession> sessions,
      List<PuttingChallenge> challenges, int distance) {
    int totalSets = 0;
    for (var session in sessions) {
      List<PuttingSet> setsWithDistance =
          session.sets.where((set) => set.distance == distance).toList();
      totalSets += setsWithDistance.length;
    }
    for (var challenge in challenges) {
      List<PuttingSet> setsWithDistance = challenge.currentUserSets
          .where((set) => set.distance == distance)
          .toList();
      totalSets += setsWithDistance.length;
    }
    return totalSets;
  }

  List<Event> getCalendarEvents(
      List<PuttingSession> sessions, List<PuttingChallenge> challenges) {
    List<Event> events = [];

    for (PuttingSession session in sessions) {
      events.add(Event(
          dateTime: DateTime.fromMillisecondsSinceEpoch(session.timeStamp),
          item: session));
    }
    challenges = challenges
        .where((challenge) => challenge.completionTimeStamp != null)
        .toList();
    for (PuttingChallenge challenge in challenges) {
      events.add(Event(
          dateTime: DateTime.fromMillisecondsSinceEpoch(
              challenge.completionTimeStamp!),
          item: challenge));
    }
    return events;
  }

  Map<Circles, Map<DistanceInterval, PuttingSetInterval>> getSetIntervals(
    List<PuttingSet> sets,
  ) {
    final Map<int, List<PuttingSet>> setsByDistanceMap =
        SetHelpers.sortSetsByDistance(sets);

    final Map<DistanceInterval, PuttingSetInterval> circle1IntervalToDataMap =
        {};
    final Map<DistanceInterval, PuttingSetInterval> circle2IntervalToDataMap =
        {};

    // circle 1 intervals
    for (int i = 0; i < kC1DistanceIntervals.length - 1; i++) {
      final List<PuttingSet> puttingSetsInInterval = [];

      int lowerBound = kC1DistanceIntervals[i];
      if (i > 0) {
        lowerBound++;
      }
      final int upperBound = kC1DistanceIntervals[i + 1];

      final DistanceInterval distanceInterval =
          DistanceInterval(lowerBound: lowerBound, upperBound: upperBound);

      for (int distance in setsByDistanceMap.keys) {
        // if distance in interval
        if (distance >= lowerBound && distance <= upperBound) {
          puttingSetsInInterval.addAll(setsByDistanceMap[distance]!);
        }
      }
      circle1IntervalToDataMap[distanceInterval] = PuttingSetInterval(
        distanceInterval: distanceInterval,
        sets: puttingSetsInInterval,
        setsPercentage: SetHelpers.percentageFromSets(puttingSetsInInterval),
      );
    }

    // circle 2 intervals
    for (int i = 0; i < kC2DistanceIntervals.length - 1; i++) {
      final List<PuttingSet> puttingSetsInInterval = [];

      int lowerBound = kC2DistanceIntervals[i];
      if (i > 0) {
        lowerBound++;
      }
      final int upperBound = kC2DistanceIntervals[i + 1];

      final DistanceInterval distanceInterval =
          DistanceInterval(lowerBound: lowerBound, upperBound: upperBound);

      for (int distance in setsByDistanceMap.keys) {
        // if distance in interval
        if (distance >= lowerBound && distance <= upperBound) {
          puttingSetsInInterval.addAll(setsByDistanceMap[distance]!);
        }
      }
      circle2IntervalToDataMap[distanceInterval] = PuttingSetInterval(
        distanceInterval: distanceInterval,
        sets: puttingSetsInInterval,
        setsPercentage: SetHelpers.percentageFromSets(puttingSetsInInterval),
      );
    }

    return {
      Circles.circle1: circle1IntervalToDataMap,
      Circles.circle2: circle2IntervalToDataMap
    };
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
}
