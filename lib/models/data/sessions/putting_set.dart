import 'package:json_annotation/json_annotation.dart';
import 'package:myputt/models/data/sessions/conditions.dart';

part 'putting_set.g.dart';

enum PuttType {
  @JsonValue('straddle')
  straddle,
  @JsonValue('staggered')
  staggered,
}

@JsonSerializable(explicitToJson: true, anyMap: true)
class PuttingSet {
  PuttingSet({
    required this.puttsMade,
    required this.puttsAttempted,
    required this.distance,
    this.timeStamp,
    this.puttType,
  });

  final int? timeStamp;
  final int puttsMade;
  final int puttsAttempted;
  final int distance;
  Conditions? conditions;
  PuttType? puttType;

  factory PuttingSet.fromJson(Map<String, dynamic> json) =>
      _$PuttingSetFromJson(json);

  Map<String, dynamic> toJson() => _$PuttingSetToJson(this);
}
