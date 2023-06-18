// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'conditions.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PuttingConditions _$PuttingConditionsFromJson(Map json) => PuttingConditions(
      windIntensity:
          $enumDecodeNullable(_$WindIntensityEnumMap, json['windIntensity']),
      weatherConditions: $enumDecodeNullable(
          _$WeatherConditionsEnumMap, json['weatherConditions']),
      windDirection:
          $enumDecodeNullable(_$WindDirectionEnumMap, json['windDirection']),
      puttingStance:
          $enumDecodeNullable(_$PuttingStanceEnumMap, json['puttingStance']),
    );

Map<String, dynamic> _$PuttingConditionsToJson(PuttingConditions instance) =>
    <String, dynamic>{
      'weatherConditions':
          _$WeatherConditionsEnumMap[instance.weatherConditions],
      'windIntensity': _$WindIntensityEnumMap[instance.windIntensity],
      'windDirection': _$WindDirectionEnumMap[instance.windDirection],
      'puttingStance': _$PuttingStanceEnumMap[instance.puttingStance],
    };

const _$WindIntensityEnumMap = {
  WindIntensity.calm: 'calm',
  WindIntensity.breezy: 'breezy',
  WindIntensity.strong: 'strong',
  WindIntensity.intense: 'intense',
};

const _$WeatherConditionsEnumMap = {
  WeatherConditions.sunny: 'sunny',
  WeatherConditions.cloudy: 'cloudy',
  WeatherConditions.rainy: 'rainy',
  WeatherConditions.snowy: 'snowy',
};

const _$WindDirectionEnumMap = {
  WindDirection.headwind: 'headwind',
  WindDirection.tailwind: 'tailwind',
  WindDirection.ltrCross: 'ltr_cross',
  WindDirection.rtlCross: 'rtl_cross',
};

const _$PuttingStanceEnumMap = {
  PuttingStance.staggered: 'staggered',
  PuttingStance.straddle: 'straddle',
};
