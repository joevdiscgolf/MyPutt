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
      conditions: json['conditions'] == null
          ? null
          : PuttingConditions.fromJson(
              Map<String, dynamic>.from(json['conditions'] as Map)),
    );

Map<String, dynamic> _$PuttingSetToJson(PuttingSet instance) =>
    <String, dynamic>{
      'timeStamp': instance.timeStamp,
      'puttsMade': instance.puttsMade,
      'puttsAttempted': instance.puttsAttempted,
      'distance': instance.distance,
      'conditions': instance.conditions?.toJson(),
    };
