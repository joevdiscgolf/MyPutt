import 'package:myputt/data/types/conditions/conditions.dart';

class PuttingSetData {
  PuttingSetData(
      {required this.puttsMade,
      required this.puttsAttempted,
      required this.distance});
  final int puttsMade;
  final int puttsAttempted;
  final int distance;
  Conditions? conditions;
}
