// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stats.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Stats _$StatsFromJson(Map json) => Stats(
      circleOnePercentages: (json['circleOnePercentages'] as Map?)?.map(
        (k, e) => MapEntry(int.parse(k as String), e as num?),
      ),
      circleTwoPercentages: (json['circleTwoPercentages'] as Map?)?.map(
        (k, e) => MapEntry(int.parse(k as String), e as num?),
      ),
      circleOneOverall: (json['circleOneOverall'] as Map?)?.map(
        (k, e) => MapEntry(int.parse(k as String), e as num?),
      ),
      circleTwoOverall: (json['circleTwoOverall'] as Map?)?.map(
        (k, e) => MapEntry(int.parse(k as String), e as num?),
      ),
      generalStats: json['generalStats'] == null
          ? null
          : GeneralStats.fromJson(
              Map<String, dynamic>.from(json['generalStats'] as Map)),
    );

Map<String, dynamic> _$StatsToJson(Stats instance) => <String, dynamic>{
      'circleOnePercentages': instance.circleOnePercentages
          ?.map((k, e) => MapEntry(k.toString(), e)),
      'circleOneOverall':
          instance.circleOneOverall?.map((k, e) => MapEntry(k.toString(), e)),
      'circleTwoPercentages': instance.circleTwoPercentages
          ?.map((k, e) => MapEntry(k.toString(), e)),
      'circleTwoOverall':
          instance.circleTwoOverall?.map((k, e) => MapEntry(k.toString(), e)),
      'generalStats': instance.generalStats?.toJson(),
    };
