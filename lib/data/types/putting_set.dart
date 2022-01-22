import 'package:myputt/data/types/conditions/conditions.dart';

class PuttingSet {
  PuttingSet(
      {required this.puttsMade,
      required this.puttsAttempted,
      required this.distance});
  final num puttsMade;
  final num puttsAttempted;
  final int distance;
  Conditions? conditions;
}
