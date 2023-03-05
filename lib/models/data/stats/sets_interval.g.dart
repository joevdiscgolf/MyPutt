// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sets_interval.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PuttingSetsInterval _$PuttingSetsIntervalFromJson(Map json) =>
    PuttingSetsInterval(
      lowerBound: json['lowerBound'] as int,
      upperBound: json['upperBound'] as int,
      sets: (json['sets'] as List<dynamic>)
          .map((e) => PuttingSet.fromJson(Map<String, dynamic>.from(e as Map)))
          .toList(),
      setsPercentage: (json['setsPercentage'] as num).toDouble(),
    );

Map<String, dynamic> _$PuttingSetsIntervalToJson(
        PuttingSetsInterval instance) =>
    <String, dynamic>{
      'lowerBound': instance.lowerBound,
      'upperBound': instance.upperBound,
      'sets': instance.sets.map((e) => e.toJson()).toList(),
      'setsPercentage': instance.setsPercentage,
    };
