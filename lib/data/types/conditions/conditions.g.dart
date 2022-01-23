// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'conditions.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Conditions _$ConditionsFromJson(Map json) => Conditions(
      windConditions:
          _$enumDecode(_$WindConditionsEnumMap, json['windConditions']),
      weatherConditions:
          _$enumDecode(_$WeatherConditionsEnumMap, json['weatherConditions']),
    );

Map<String, dynamic> _$ConditionsToJson(Conditions instance) =>
    <String, dynamic>{
      'windConditions': _$WindConditionsEnumMap[instance.windConditions],
      'weatherConditions':
          _$WeatherConditionsEnumMap[instance.weatherConditions],
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
