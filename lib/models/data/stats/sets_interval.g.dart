// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sets_interval.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PuttingSetInterval _$PuttingSetIntervalFromJson(Map json) => PuttingSetInterval(
      distanceInterval: DistanceInterval.fromJson(
          Map<String, dynamic>.from(json['distanceInterval'] as Map)),
      sets: (json['sets'] as List<dynamic>)
          .map((e) => PuttingSet.fromJson(Map<String, dynamic>.from(e as Map)))
          .toList(),
      setsPercentage: (json['setsPercentage'] as num).toDouble(),
    );

Map<String, dynamic> _$PuttingSetIntervalToJson(PuttingSetInterval instance) =>
    <String, dynamic>{
      'distanceInterval': instance.distanceInterval.toJson(),
      'sets': instance.sets.map((e) => e.toJson()).toList(),
      'setsPercentage': instance.setsPercentage,
    };

DistanceInterval _$DistanceIntervalFromJson(Map json) => DistanceInterval(
      lowerBound: json['lowerBound'] as int,
      upperBound: json['upperBound'] as int,
    );

Map<String, dynamic> _$DistanceIntervalToJson(DistanceInterval instance) =>
    <String, dynamic>{
      'lowerBound': instance.lowerBound,
      'upperBound': instance.upperBound,
    };
