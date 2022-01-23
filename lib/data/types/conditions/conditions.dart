import 'package:json_annotation/json_annotation.dart';
import 'package:myputt/data/types/conditions/condition_enums.dart';

part 'conditions.g.dart';

@JsonSerializable(explicitToJson: true, anyMap: true)
class Conditions {
  Conditions({required this.windConditions, required this.weatherConditions});
  final WindConditions windConditions;
  final WeatherConditions weatherConditions;

  factory Conditions.fromJson(Map<String, dynamic> json) =>
      _$ConditionsFromJson(json);

  Map<String, dynamic> toJson() => _$ConditionsToJson(this);
}
