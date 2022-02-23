import 'package:json_annotation/json_annotation.dart';
import 'package:myputt/data/types/conditions/conditions.dart';

part 'putting_set.g.dart';

@JsonSerializable(explicitToJson: true, anyMap: true)
class PuttingSet {
  PuttingSet(
      {required this.puttsMade,
      required this.puttsAttempted,
      required this.distance,
      this.timeStamp});
  final int? timeStamp;
  final num puttsMade;
  final num puttsAttempted;
  final num distance;
  Conditions? conditions;

  factory PuttingSet.fromJson(Map<String, dynamic> json) =>
      _$PuttingSetFromJson(json);

  Map<String, dynamic> toJson() => _$PuttingSetToJson(this);
}
