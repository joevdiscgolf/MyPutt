// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'event_player_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EventPlayerData _$EventPlayerDataFromJson(Map json) => EventPlayerData(
      usermetadata: MyPuttUserMetadata.fromJson(
          Map<String, dynamic>.from(json['usermetadata'] as Map)),
      division: $enumDecode(_$DivisionEnumMap, json['division']),
      sets: (json['sets'] as List<dynamic>)
          .map((e) => PuttingSet.fromJson(Map<String, dynamic>.from(e as Map)))
          .toList(),
      verificationImg: json['verificationImg'] as String?,
      lockedIn: json['lockedIn'] as bool,
    );

Map<String, dynamic> _$EventPlayerDataToJson(EventPlayerData instance) =>
    <String, dynamic>{
      'usermetadata': instance.usermetadata.toJson(),
      'division': _$DivisionEnumMap[instance.division]!,
      'sets': instance.sets.map((e) => e.toJson()).toList(),
      'verificationImg': instance.verificationImg,
      'lockedIn': instance.lockedIn,
    };

const _$DivisionEnumMap = {
  Division.mpo: 'mpo',
  Division.mp40: 'mp40',
  Division.mp50: 'mp50',
  Division.ma1: 'ma1',
  Division.ma2: 'ma2',
  Division.ma3: 'ma3',
  Division.ma4: 'ma4',
  Division.ma5: 'ma5',
  Division.fpo: 'fpo',
  Division.fa1: 'fa1',
  Division.fa2: 'fa2',
  Division.fa3: 'fa3',
  Division.junior: 'junior',
  Division.mixed: 'mixed',
};
