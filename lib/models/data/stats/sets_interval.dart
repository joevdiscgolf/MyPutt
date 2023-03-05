import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:myputt/models/data/sessions/putting_set.dart';

part 'sets_interval.g.dart';

@JsonSerializable(explicitToJson: true, anyMap: true)
class PuttingSetInterval {
  const PuttingSetInterval({
    required this.distanceInterval,
    required this.sets,
    required this.setsPercentage,
  });

  final DistanceInterval distanceInterval;
  final List<PuttingSet> sets;
  final double setsPercentage;

  factory PuttingSetInterval.fromJson(Map<String, dynamic> json) =>
      _$PuttingSetIntervalFromJson(json);

  Map<String, dynamic> toJson() => _$PuttingSetIntervalToJson(this);
}

@JsonSerializable(explicitToJson: true, anyMap: true)
class DistanceInterval extends Equatable {
  const DistanceInterval({
    required this.lowerBound,
    required this.upperBound,
  });

  final int lowerBound;
  final int upperBound;

  factory DistanceInterval.fromJson(Map<String, dynamic> json) =>
      _$DistanceIntervalFromJson(json);

  Map<String, dynamic> toJson() => _$DistanceIntervalToJson(this);

  @override
  List<Object?> get props => [lowerBound, upperBound];
}
