import 'dart:math';

import 'package:myputt/data/types/chart/chart_point.dart';
import 'package:myputt/data/types/stats/stats.dart';
import 'package:myputt/data/types/stats/general_stats.dart';
import 'package:myputt/data/types/putting_session.dart';
import 'package:myputt/data/types/challenges/putting_challenge.dart';
import 'package:myputt/data/types/putting_set.dart';
import 'package:myputt/locator.dart';
import 'package:myputt/utils/calculators.dart';
import 'package:myputt/utils/challenge_helpers.dart';
import 'package:myputt/utils/enums.dart';

import 'auth_service.dart';

class StatsService {
  // limit is an num and it's the number of sessions to look back for stats.
  Stats getStatsForRange(
    int limit,
    List<PuttingSession> sessions,
    List<PuttingChallenge> challenges,
  ) {
    // filtering out challenges that were generated from a session of the user.
    challenges = filterDuplicateChallenges(sessions, challenges);

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
        ));
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
        ));
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
    final AuthService _authService = locator.get<AuthService>();
    final String? currentUid = _authService.getCurrentUserId();

    // print(limit);
    if (currentUid == null) {
      return [];
    }
    List<ChartPoint> points = [];
    List<ChartPoint> finalPoints = [];

    challenges = filterDuplicateChallenges(sessions, challenges);

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
}
