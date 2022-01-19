import 'package:myputt/data/types/putting_set.dart';

class PuttingSession {
  PuttingSession({required this.dateStarted, required this.uid});
  final String uid;
  final String dateStarted;
  List<PuttingSet> sets = [];

  void addSet(PuttingSet set) {
    sets.add(set);
  }
}
