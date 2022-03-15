import 'package:myputt/data/types/chart/chart_point.dart';
import 'package:myputt/data/types/stats/stats.dart';
import 'package:myputt/data/types/stats/general_stats.dart';
import 'package:myputt/data/types/putting_session.dart';
import 'package:myputt/data/types/challenges/putting_challenge.dart';
import 'package:myputt/data/types/putting_set.dart';
import 'package:myputt/utils/calculators.dart';
import 'package:myputt/utils/enums.dart';

class StatsService {
  // sessionLimit is an num and it's the number of sessions to look back for stats.
  Stats getStatsForSessionRange(
      num sessionLimit, List<PuttingSession> sessions) {
    Map<int, num> sessionRangePuttsAttempted = {};
    Map<int, num> sessionRangePuttsMade = {};
    Map<int, num> overallPuttsAttempted = {};
    Map<int, num> overallPuttsMade = {};

    Map<int, num?> circleOneSessionRangeFractions = {
      10: null,
      15: null,
      20: null,
      25: null,
      30: null
    };
    Map<int, num?> circleTwoSessionRangeFractions = {
      40: null,
      50: null,
      60: null,
    };

    Map<int, num> circleOneOverallFractions = {};
    Map<int, num> circleTwoOverallFractions = {};

    int totalAttempts = 0;
    int totalMade = 0;

    num sessionIndex = 0;

    final sessionsInOrder = List.from(sessions).reversed;
    for (var session in sessionsInOrder) {
      final sets = session.sets;
      sets.forEach((set) {
        final distance = set.distance;

        totalAttempts += set.puttsAttempted as int;
        totalMade += set.puttsMade as int;

        overallPuttsAttempted[distance] =
            overallPuttsAttempted[distance] == null
                ? set.puttsAttempted
                : overallPuttsAttempted[distance]! + set.puttsAttempted;
        overallPuttsMade[distance] = overallPuttsMade[distance] == null
            ? set.puttsMade
            : overallPuttsMade[distance]! + set.puttsMade;

        if (sessionIndex < sessionLimit || sessionLimit == 0) {
          sessionRangePuttsAttempted[distance] =
              sessionRangePuttsAttempted[distance] == null
                  ? set.puttsAttempted
                  : sessionRangePuttsAttempted[distance]! + set.puttsAttempted;

          sessionRangePuttsMade[distance] =
              sessionRangePuttsMade[distance] == null
                  ? set.puttsMade
                  : sessionRangePuttsMade[distance]! + set.puttsMade;
        }
      });
      sessionIndex += 1;
    }

    for (var entry in sessionRangePuttsAttempted.entries) {
      if (sessionRangePuttsMade[entry.key] != null) {
        if (entry.key < 40) {
          circleOneSessionRangeFractions[entry.key] =
              sessionRangePuttsMade[entry.key]! / entry.value;
        } else {
          circleTwoSessionRangeFractions[entry.key] =
              sessionRangePuttsMade[entry.key]! / entry.value;
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
        circleOnePercentages: circleOneSessionRangeFractions,
        circleTwoPercentages: circleTwoSessionRangeFractions,
        circleOneAverages: circleOneOverallFractions,
        circleTwoAverages: circleTwoOverallFractions,
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
      final distance = set.distance as int;
      totalAttempts += set.puttsAttempted as int;
      totalMade += set.puttsMade as int;
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
        circleOneAverages: circleOneOverallFractions,
        circleTwoAverages: circleTwoOverallFractions,
        generalStats: GeneralStats(
          totalAttempts: totalAttempts,
          totalMade: totalMade,
        ));
  }

  Map<String, Stats> generateSessionsStatsMap(
      List<PuttingSession> allSessions) {
    Map<String, Stats> statsMap = {};

    for (var session in allSessions) {
      statsMap[session.dateStarted] = getStatsForSession(allSessions, session);
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

  double? getPercentagesWithCutoff(List<PuttingSession> sessions,
      List<PuttingChallenge> challenges, int cutoff) {
    double totalMade = 0;
    double totalAttmpted = 0;
    for (var session in sessions) {
      for (var set in session.sets) {
        if (set.distance > cutoff) {
          totalMade += set.puttsMade.toInt();
          totalAttmpted += set.puttsAttempted.toInt();
        }
      }
    }
    for (var challenge in challenges) {
      for (var set in challenge.currentUserSets) {
        if (set.distance > cutoff) {
          totalMade += set.puttsMade.toInt();
          totalAttmpted += set.puttsAttempted.toInt();
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
    List<ChartPoint> points = [];
    List<ChartPoint> finalPoints = [];
    for (var session in sessions) {
      int index = 0;
      session.sets
          .where((oldSet) => oldSet.distance == distance)
          .forEach((set) {
        final double decimal = set.puttsAttempted == 0
            ? 0
            : double.parse(
                (set.puttsMade.toDouble() / set.puttsAttempted.toDouble())
                    .toStringAsFixed(4));
        points.add(ChartPoint(
            index: index,
            timeStamp: set.timeStamp ?? session.timeStamp,
            distance: set.distance.toInt(),
            decimal: decimal));
        index += 1;
      });
    }
    for (var challenge in challenges) {
      int index = 0;
      challenge.currentUserSets
          .where((oldset) => oldset.distance == distance)
          .forEach((set) {
        final double decimal = set.puttsAttempted == 0
            ? 0
            : double.parse(
                (set.puttsMade.toDouble() / set.puttsAttempted.toDouble())
                    .toStringAsFixed(4));
        points.add(ChartPoint(
            index: index,
            timeStamp: set.timeStamp ?? challenge.creationTimeStamp,
            distance: set.distance.toInt(),
            decimal: decimal));
        index += 1;
      });
    }
    points.sort((p1, p2) {
      final int timeStampDifference = p1.timeStamp.compareTo(p2.timeStamp);
      return timeStampDifference != 0
          ? timeStampDifference
          : p1.index.compareTo(p2.index);
    });
    List<ChartPoint> reversedPoints = List.from(points.reversed);
    if (limit == null) {
      finalPoints = reversedPoints;
    } else {
      for (var index = 0; index < limit; index++) {
        if (index >= reversedPoints.length) {
          break;
        }
        finalPoints.add(reversedPoints[index]);
      }
    }

    return List.from(finalPoints.reversed);
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
