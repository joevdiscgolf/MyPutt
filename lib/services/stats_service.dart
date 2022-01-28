import 'package:myputt/data/types/stats.dart';
import 'package:myputt/data/types/general_stats.dart';
import 'package:myputt/data/types/putting_session.dart';

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
    sessionsInOrder.forEach((session) {
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
    });

    sessionRangePuttsAttempted.entries.forEach((entry) {
      if (sessionRangePuttsMade[entry.key] != null) {
        if (entry.key < 40) {
          circleOneSessionRangeFractions[entry.key] =
              sessionRangePuttsMade[entry.key]! / entry.value;
        } else {
          circleTwoSessionRangeFractions[entry.key] =
              sessionRangePuttsMade[entry.key]! / entry.value;
        }
      }
    });

    overallPuttsAttempted.entries.forEach((entry) {
      if (overallPuttsMade[entry.key] != null) {
        if (entry.key < 40) {
          circleOneOverallFractions[entry.key] =
              overallPuttsMade[entry.key]! / entry.value;
        } else {
          circleTwoOverallFractions[entry.key] =
              overallPuttsMade[entry.key]! / entry.value;
        }
      }
    });

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

    num sessionIndex = 0;

    final sessionsInOrder = List.from(sessions).reversed;
    sessionsInOrder.forEach((session) {
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
      });
      sessionIndex += 1;
    });

    final focusSessionSets = focusSession.sets;
    focusSessionSets.forEach((set) {
      final distance = set.distance as int;
      focusSessionPuttsAttempted[distance] =
          focusSessionPuttsAttempted[distance] == null
              ? set.puttsAttempted
              : focusSessionPuttsAttempted[distance]! + set.puttsAttempted;

      focusSessionPuttsMade[distance] = focusSessionPuttsMade[distance] == null
          ? set.puttsMade
          : focusSessionPuttsMade[distance]! + set.puttsMade;
    });

    focusSessionPuttsAttempted.entries.forEach((entry) {
      if (focusSessionPuttsMade[entry.key] != null) {
        if (entry.key < 40) {
          circleOneFocusFractions[entry.key] =
              focusSessionPuttsMade[entry.key]! / entry.value;
        } else {
          circleTwoFocusFractions[entry.key] =
              focusSessionPuttsMade[entry.key]! / entry.value;
        }
      }
    });

    overallPuttsAttempted.entries.forEach((entry) {
      if (overallPuttsMade[entry.key] != null) {
        if (entry.key < 40) {
          circleOneOverallFractions[entry.key] =
              overallPuttsMade[entry.key]! / entry.value;
        } else {
          circleTwoOverallFractions[entry.key] =
              overallPuttsMade[entry.key]! / entry.value;
        }
      }
    });

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
}
