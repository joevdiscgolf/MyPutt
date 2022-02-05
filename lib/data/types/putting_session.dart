import 'package:json_annotation/json_annotation.dart';
import 'package:myputt/data/types/putting_set.dart';

part 'putting_session.g.dart';

@JsonSerializable(explicitToJson: true, anyMap: true)
class PuttingSession {
  PuttingSession({required this.dateStarted});
  final String dateStarted;
  List<PuttingSet> sets = [];

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

  void addSet(PuttingSet set) {
    sets.add(set);
  }

  Map<String, dynamic> toMap() {
    return {
      'dateStarted': dateStarted,
      'sets': sets,
    };
  }

  factory PuttingSession.fromJson(Map<String, dynamic> json) =>
      _$PuttingSessionFromJson(json);

  Map<String, dynamic> toJson() => _$PuttingSessionToJson(this);
}
