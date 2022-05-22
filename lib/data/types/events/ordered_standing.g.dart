// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ordered_standing.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OrderedStanding _$OrderedStandingFromJson(Map json) => OrderedStanding(
      eventPlayerData: EventPlayerData.fromJson(
          Map<String, dynamic>.from(json['eventPlayerData'] as Map)),
      puttsMade: json['puttsMade'] as int,
      position: json['position'] as String,
    );

Map<String, dynamic> _$OrderedStandingToJson(OrderedStanding instance) =>
    <String, dynamic>{
      'eventPlayerData': instance.eventPlayerData.toJson(),
      'puttsMade': instance.puttsMade,
      'position': instance.position,
    };
