// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'putting_session.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PuttingSession _$PuttingSessionFromJson(Map json) => PuttingSession(
      id: json['id'] as String,
      timeStamp: json['timeStamp'] as int,
    )..sets = (json['sets'] as List<dynamic>)
        .map((e) => PuttingSet.fromJson(Map<String, dynamic>.from(e as Map)))
        .toList();

Map<String, dynamic> _$PuttingSessionToJson(PuttingSession instance) =>
    <String, dynamic>{
      'id': instance.id,
      'timeStamp': instance.timeStamp,
      'sets': instance.sets.map((e) => e.toJson()).toList(),
    };
