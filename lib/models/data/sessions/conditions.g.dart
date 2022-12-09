// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'conditions.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Conditions _$ConditionsFromJson(Map json) => Conditions(
      windConditions:
          _$enumDecodeNullable(_$WindConditionsEnumMap, json['windConditions']),
      weatherConditions: _$enumDecodeNullable(
          _$WeatherConditionsEnumMap, json['weatherConditions']),
      windDirection:
          _$enumDecodeNullable(_$WindDirectionEnumMap, json['windDirection']),
    );

Map<String, dynamic> _$ConditionsToJson(Conditions instance) =>
    <String, dynamic>{
      'windConditions': _$WindConditionsEnumMap[instance.windConditions],
      'weatherConditions':
          _$WeatherConditionsEnumMap[instance.weatherConditions],
      'windDirection': _$WindDirectionEnumMap[instance.windDirection],
    };

K _$enumDecode<K, V>(
  Map<K, V> enumValues,
  Object? source, {
  K? unknownValue,
}) {
  if (source == null) {
    throw ArgumentError(
      'A value must be provided. Supported values: '
      '${enumValues.values.join(', ')}',
    );
  }

  return enumValues.entries.singleWhere(
    (e) => e.value == source,
    orElse: () {
      if (unknownValue == null) {
        throw ArgumentError(
          '`$source` is not one of the supported values: '
          '${enumValues.values.join(', ')}',
        );
      }
      return MapEntry(unknownValue, enumValues.values.first);
    },
  ).key;
}

K? _$enumDecodeNullable<K, V>(
  Map<K, V> enumValues,
  dynamic source, {
  K? unknownValue,
}) {
  if (source == null) {
    return null;
  }
  return _$enumDecode<K, V>(enumValues, source, unknownValue: unknownValue);
}

const _$WindConditionsEnumMap = {
  WindConditions.calm: 'calm',
  WindConditions.breezy: 'breezy',
  WindConditions.strong: 'strong',
  WindConditions.violent: 'violent',
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
  WindDirection.leftToRight: 'leftToRight',
  WindDirection.rightToLeft: 'rightToLeft',
};
