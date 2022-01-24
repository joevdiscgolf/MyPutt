// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stats.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Stats _$StatsFromJson(Map json) => Stats(
      circleOnePercentages: (json['circleOnePercentages'] as Map?)?.map(
        (k, e) => MapEntry(int.parse(k as String), (e as num).toDouble()),
      ),
      circleOneAverages: (json['circleOneAverages'] as Map?)?.map(
        (k, e) => MapEntry(int.parse(k as String), (e as num).toDouble()),
      ),
      circleTwoAverages: (json['circleTwoAverages'] as Map?)?.map(
        (k, e) => MapEntry(int.parse(k as String), (e as num).toDouble()),
      ),
      circleTwoPercentages: (json['circleTwoPercentages'] as Map?)?.map(
        (k, e) => MapEntry(int.parse(k as String), (e as num).toDouble()),
      ),
      generalStats: json['generalStats'] == null
          ? null
          : GeneralStats.fromJson(
              Map<String, dynamic>.from(json['generalStats'] as Map)),
    );

Map<String, dynamic> _$StatsToJson(Stats instance) => <String, dynamic>{
      'circleOnePercentages': instance.circleOnePercentages
          ?.map((k, e) => MapEntry(k.toString(), e)),
      'circleOneAverages':
          instance.circleOneAverages?.map((k, e) => MapEntry(k.toString(), e)),
      'circleTwoPercentages': instance.circleTwoPercentages
          ?.map((k, e) => MapEntry(k.toString(), e)),
      'circleTwoAverages':
          instance.circleTwoAverages?.map((k, e) => MapEntry(k.toString(), e)),
      'generalStats': instance.generalStats?.toJson(),
    };
