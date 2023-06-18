import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:myputt/models/data/conditions/conditions.dart';
import 'package:myputt/utils/constants.dart';

part 'putting_preferences.g.dart';

@JsonSerializable(explicitToJson: true, anyMap: true)
class PuttingPreferences extends Equatable {
  const PuttingPreferences({
    this.puttingConditions = const PuttingConditions(),
    this.preferredDistance = kDefaultDistanceFt,
    this.preferredSetLength = kDefaultSetLength,
  });
  final PuttingConditions puttingConditions;
  final int preferredDistance;
  final int preferredSetLength;

  PuttingPreferences copyWith({
    PuttingConditions? puttingConditions,
    int? preferredDistance,
    int? preferredSetLength,
  }) {
    return PuttingPreferences(
      puttingConditions: puttingConditions ?? this.puttingConditions,
      preferredDistance: preferredDistance ?? this.preferredDistance,
      preferredSetLength: preferredSetLength ?? this.preferredSetLength,
    );
  }

  factory PuttingPreferences.fromJson(Map<String, dynamic> json) =>
      _$PuttingPreferencesFromJson(json);

  Map<String, dynamic> toJson() => _$PuttingPreferencesToJson(this);

  @override
  List<Object?> get props =>
      [puttingConditions, preferredDistance, preferredSetLength];
}
