import 'package:json_annotation/json_annotation.dart';
import 'package:myputt/models/data/sessions/condition_enums.dart';

part 'conditions.g.dart';

@JsonSerializable(explicitToJson: true, anyMap: true)
class Conditions {
  Conditions({
    this.windConditions,
    this.weatherConditions,
    this.windDirection,
  });
  final WindConditions? windConditions;
  final WeatherConditions? weatherConditions;
  final WindDirection? windDirection;

  factory Conditions.fromJson(Map<String, dynamic> json) =>
      _$ConditionsFromJson(json);

  Map<String, dynamic> toJson() => _$ConditionsToJson(this);
}
