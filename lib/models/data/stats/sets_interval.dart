import 'package:json_annotation/json_annotation.dart';
import 'package:myputt/models/data/sessions/putting_set.dart';

part 'sets_interval.g.dart';

@JsonSerializable(explicitToJson: true, anyMap: true)
class PuttingSetsInterval {
  PuttingSetsInterval({
    required this.lowerBound,
    required this.upperBound,
    required this.sets,
    required this.setsPercentage,
  });

  final int lowerBound;
  final int upperBound;
  final List<PuttingSet> sets;
  final double setsPercentage;

  factory PuttingSetsInterval.fromJson(Map<String, dynamic> json) =>
      _$PuttingSetsIntervalFromJson(json);

  Map<String, dynamic> toJson() => _$PuttingSetsIntervalToJson(this);
}
