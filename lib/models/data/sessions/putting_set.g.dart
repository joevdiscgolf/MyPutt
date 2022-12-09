// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'putting_set.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PuttingSet _$PuttingSetFromJson(Map json) => PuttingSet(
      puttsMade: json['puttsMade'] as int,
      puttsAttempted: json['puttsAttempted'] as int,
      distance: json['distance'] as int,
      timeStamp: json['timeStamp'] as int?,
      puttType: _$enumDecodeNullable(_$PuttTypeEnumMap, json['puttType']),
    )..conditions = json['conditions'] == null
        ? null
        : Conditions.fromJson(
            Map<String, dynamic>.from(json['conditions'] as Map));

Map<String, dynamic> _$PuttingSetToJson(PuttingSet instance) =>
    <String, dynamic>{
      'timeStamp': instance.timeStamp,
      'puttsMade': instance.puttsMade,
      'puttsAttempted': instance.puttsAttempted,
      'distance': instance.distance,
      'conditions': instance.conditions?.toJson(),
      'puttType': _$PuttTypeEnumMap[instance.puttType],
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

const _$PuttTypeEnumMap = {
  PuttType.straddle: 'straddle',
  PuttType.staggered: 'staggered',
};
