// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'conditions.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Conditions _$ConditionsFromJson(Map json) => Conditions(
      windConditions:
          $enumDecode(_$WindConditionsEnumMap, json['windConditions']),
      weatherConditions:
          $enumDecode(_$WeatherConditionsEnumMap, json['weatherConditions']),
    );

Map<String, dynamic> _$ConditionsToJson(Conditions instance) =>
    <String, dynamic>{
      'windConditions': _$WindConditionsEnumMap[instance.windConditions]!,
      'weatherConditions':
          _$WeatherConditionsEnumMap[instance.weatherConditions]!,
    };

const _$WindConditionsEnumMap = {
  WindConditions.calm: 'calm',
  WindConditions.breezy: 'breezy',
  WindConditions.strong: 'strong',
  WindConditions.intense: 'intense',
};

const _$WeatherConditionsEnumMap = {
  WeatherConditions.sunny: 'sunny',
  WeatherConditions.cloudy: 'cloudy',
  WeatherConditions.rainy: 'rainy',
  WeatherConditions.snowy: 'snowy',
};
