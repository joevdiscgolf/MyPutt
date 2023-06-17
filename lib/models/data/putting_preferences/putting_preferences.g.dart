// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'putting_preferences.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PuttingPreferences _$PuttingPreferencesFromJson(Map json) => PuttingPreferences(
      puttingConditions: json['puttingConditions'] == null
          ? const PuttingConditions()
          : PuttingConditions.fromJson(
              Map<String, dynamic>.from(json['puttingConditions'] as Map)),
      preferredDistance:
          json['preferredDistance'] as int? ?? kDefaultDistanceFt,
      preferredSetLength:
          json['preferredSetLength'] as int? ?? kDefaultSetLength,
    );

Map<String, dynamic> _$PuttingPreferencesToJson(PuttingPreferences instance) =>
    <String, dynamic>{
      'puttingConditions': instance.puttingConditions.toJson(),
      'preferredDistance': instance.preferredDistance,
      'preferredSetLength': instance.preferredSetLength,
    };
