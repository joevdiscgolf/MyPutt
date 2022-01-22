import 'package:myputt/data/types/putting_set.dart';

class PuttingSession {
  PuttingSession({required this.dateStarted, required this.uid});
  final String uid;
  final String dateStarted;
  List<PuttingSet> sets = [];

  void addSet(PuttingSet set) {
    sets.add(set);
  }

  num get totalPuttsMade {
    num total = 0;
    for (var set in sets) {
      total += set.puttsMade;
    }
    return total;
  }

  num get totalPuttsAttempted {
    num total = 0;
    for (var set in sets) {
      total += set.puttsAttempted;
    }
    return total;
  }
}
