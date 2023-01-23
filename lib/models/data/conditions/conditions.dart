import 'package:json_annotation/json_annotation.dart';
import 'package:myputt/models/data/conditions/condition_enums.dart';

part 'conditions.g.dart';

@JsonSerializable(explicitToJson: true, anyMap: true)
class Conditions {
  Conditions({
    this.windIntensity,
    this.weatherConditions,
    this.windDirection,
    this.puttingStance,
  });
  final WeatherConditions? weatherConditions;
  final WindIntensity? windIntensity;
  final WindDirection? windDirection;
  final PuttingStance? puttingStance;

  factory Conditions.fromJson(Map<String, dynamic> json) =>
      _$ConditionsFromJson(json);

  Map<String, dynamic> toJson() => _$ConditionsToJson(this);
}
