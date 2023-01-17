import 'package:json_annotation/json_annotation.dart';
import 'package:myputt/models/data/sessions/putting_set.dart';

part 'putting_session.g.dart';

@JsonSerializable(explicitToJson: true, anyMap: true)
class PuttingSession {
  PuttingSession({
    required this.id,
    required this.timeStamp,
    this.isSynced = false,
  });
  final String id;
  final int timeStamp;
  List<PuttingSet> sets = [];
  final bool? isSynced;

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

  factory PuttingSession.fromJson(Map<String, dynamic> json) =>
      _$PuttingSessionFromJson(json);

  Map<String, dynamic> toJson() => _$PuttingSessionToJson(this);
}
