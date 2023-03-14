import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:myputt/models/data/conditions/conditions.dart';

part 'putting_set.g.dart';

@JsonSerializable(explicitToJson: true, anyMap: true)
class PuttingSet extends Equatable {
  const PuttingSet({
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
  final PuttingConditions? conditions;

  factory PuttingSet.fromJson(Map<String, dynamic> json) =>
      _$PuttingSetFromJson(json);

  Map<String, dynamic> toJson() => _$PuttingSetToJson(this);

  @override
  List<Object?> get props =>
      [timeStamp, puttsMade, puttsAttempted, distance, conditions];
}
