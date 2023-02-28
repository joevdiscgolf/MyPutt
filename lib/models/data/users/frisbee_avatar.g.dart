// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'frisbee_avatar.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FrisbeeAvatar _$FrisbeeAvatarFromJson(Map json) => FrisbeeAvatar(
      backgroundColorHex: json['backgroundColorHex'] as String? ?? '2196F3',
      frisbeeIconColor: $enumDecodeNullable(
              _$FrisbeeIconColorEnumMap, json['frisbeeIconColor']) ??
          FrisbeeIconColor.red,
    );

Map<String, dynamic> _$FrisbeeAvatarToJson(FrisbeeAvatar instance) =>
    <String, dynamic>{
      'backgroundColorHex': instance.backgroundColorHex,
      'frisbeeIconColor': _$FrisbeeIconColorEnumMap[instance.frisbeeIconColor]!,
    };

const _$FrisbeeIconColorEnumMap = {
  FrisbeeIconColor.red: 'red',
  FrisbeeIconColor.green: 'green',
  FrisbeeIconColor.blue: 'blue',
  FrisbeeIconColor.purple: 'purple',
  FrisbeeIconColor.pink: 'pink',
};
