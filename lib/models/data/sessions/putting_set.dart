import 'package:json_annotation/json_annotation.dart';
import 'package:myputt/models/data/conditions/conditions.dart';

part 'putting_set.g.dart';

@JsonSerializable(explicitToJson: true, anyMap: true)
class PuttingSet {
  PuttingSet({
    required this.puttsMade,
    required this.puttsAttempted,
    required this.distance,
    this.timeStamp,
    this.conditions,
  });

  final int? timeStamp;
  final int puttsMade;
  final int puttsAttempted;
  final int distance;
  PuttingConditions? conditions;

  factory PuttingSet.fromJson(Map<String, dynamic> json) =>
      _$PuttingSetFromJson(json);

  Map<String, dynamic> toJson() => _$PuttingSetToJson(this);
}
