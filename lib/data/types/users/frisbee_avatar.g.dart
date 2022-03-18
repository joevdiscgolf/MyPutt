// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'frisbee_avatar.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FrisbeeAvatar _$FrisbeeAvatarFromJson(Map json) => FrisbeeAvatar(
      backgroundColorHex: json['backgroundColorHex'] as String? ?? '2196F3',
      frisbeeIconColor: _$enumDecodeNullable(
              _$FrisbeeIconColorEnumMap, json['frisbeeIconColor']) ??
          FrisbeeIconColor.red,
    );

Map<String, dynamic> _$FrisbeeAvatarToJson(FrisbeeAvatar instance) =>
    <String, dynamic>{
      'backgroundColorHex': instance.backgroundColorHex,
      'frisbeeIconColor': _$FrisbeeIconColorEnumMap[instance.frisbeeIconColor],
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

const _$FrisbeeIconColorEnumMap = {
  FrisbeeIconColor.red: 'red',
  FrisbeeIconColor.green: 'green',
  FrisbeeIconColor.blue: 'blue',
  FrisbeeIconColor.purple: 'purple',
  FrisbeeIconColor.pink: 'pink',
};
