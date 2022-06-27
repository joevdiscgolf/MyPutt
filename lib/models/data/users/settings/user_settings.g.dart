// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_settings.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserSettings _$UserSettingsFromJson(Map json) => UserSettings(
      sessionSettings: json['sessionSettings'] == null
          ? null
          : SessionSettings.fromJson(
              Map<String, dynamic>.from(json['sessionSettings'] as Map)),
    );

Map<String, dynamic> _$UserSettingsToJson(UserSettings instance) =>
    <String, dynamic>{
      'sessionSettings': instance.sessionSettings?.toJson(),
    };
