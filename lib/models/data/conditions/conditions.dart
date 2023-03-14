import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:myputt/models/data/conditions/condition_enums.dart';

part 'conditions.g.dart';

@JsonSerializable(explicitToJson: true, anyMap: true)
class PuttingConditions extends Equatable {
  const PuttingConditions({
    this.windIntensity,
    this.weatherConditions,
    this.windDirection,
    this.puttingStance,
  });
  final WeatherConditions? weatherConditions;
  final WindIntensity? windIntensity;
  final WindDirection? windDirection;
  final PuttingStance? puttingStance;

  PuttingConditions copyWith(Map<String, dynamic> valuesToUpdate) {
    WeatherConditions? weatherConditions = this.weatherConditions;
    WindIntensity? windIntensity = this.windIntensity;
    WindDirection? windDirection = this.windDirection;
    PuttingStance? puttingStance = this.puttingStance;
    if (valuesToUpdate.containsKey('weatherConditions')) {
      weatherConditions = valuesToUpdate['weatherConditions'];
    }
    if (valuesToUpdate.containsKey('windIntensity')) {
      windIntensity = valuesToUpdate['windIntensity'];
    }
    if (valuesToUpdate.containsKey('windDirection')) {
      windDirection = valuesToUpdate['windDirection'];
    }
    if (valuesToUpdate.containsKey('puttingStance')) {
      puttingStance = valuesToUpdate['puttingStance'];
    }

    return PuttingConditions(
      weatherConditions: weatherConditions,
      windIntensity: windIntensity,
      windDirection: windDirection,
      puttingStance: puttingStance,
    );
  }

  factory PuttingConditions.fromJson(Map<String, dynamic> json) =>
      _$PuttingConditionsFromJson(json);

  Map<String, dynamic> toJson() => _$PuttingConditionsToJson(this);

  @override
  List<Object?> get props =>
      [windIntensity, weatherConditions, windDirection, puttingStance];
}
