import 'package:myputt/data/types/stats.dart';
import 'package:myputt/data/types/general_stats.dart';
import 'package:myputt/data/types/putting_session.dart';

class StatsService {
  // sessionLimit is an int and it's the number of sessions to look back for stats.
  /*Stats getStats(int sessionLimit, List<PuttingSession> sessions) {
    Map<int, int> sessionRangePuttsAttempted = {};
    Map<int, int> sessionRangePuttsMade = {};
    Map<int, int> overallPuttsAttempted = {};
    Map<int, int> overallPuttsMade = {};

    int sessionIndex = 0;

    final sessionsInOrder = List.from(sessions).reversed;
    sessionsInOrder.forEach((session) {
      final sets = session.sets;
        sets.forEach((set) {
          final distance = set.distance;
          /*overallPuttsAttempted[distance] += set.puttsAttempted;
          overallPuttsMade[distance] += set.puttsMade;*/
          if (sessionIndex < sessionLimit) {

          }
        });
    });
  }*/
}
