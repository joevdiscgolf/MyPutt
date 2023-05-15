import 'package:json_annotation/json_annotation.dart';
import 'package:myputt/models/data/sessions/putting_set.dart';

part 'putting_session.g.dart';

@JsonSerializable(explicitToJson: true, anyMap: true)
class PuttingSession {
  const PuttingSession({
    required this.id,
    required this.timeStamp,
    required this.sets,
    this.isSynced = false,
    this.deviceId,
    this.isDeleted,
  });

  final String id;
  final int timeStamp;
  final List<PuttingSet> sets;
  final bool? isSynced;
  final String? deviceId;
  final bool? isDeleted;

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

  PuttingSession copyWith({
    String? id,
    int? timeStamp,
    List<PuttingSet>? sets,
    bool? isSynced,
    String? deviceId,
    bool? isDeleted,
  }) {
    return PuttingSession(
      id: id ?? this.id,
      timeStamp: timeStamp ?? this.timeStamp,
      sets: sets ?? this.sets,
      isSynced: isSynced ?? this.isSynced,
      isDeleted: isDeleted ?? this.isDeleted,
      deviceId: deviceId ?? this.deviceId,
    );
  }

  factory PuttingSession.fromJson(Map<String, dynamic> json) =>
      _$PuttingSessionFromJson(json);

  Map<String, dynamic> toJson() => _$PuttingSessionToJson(this);
}
