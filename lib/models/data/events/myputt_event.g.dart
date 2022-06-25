// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'myputt_event.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MyPuttEvent _$MyPuttEventFromJson(Map json) => MyPuttEvent(
      eventId: json['eventId'] as String,
      clubId: json['clubId'] as String?,
      code: json['code'] as int,
      name: json['name'] as String,
      description: json['description'] as String?,
      eventCustomizationData: EventCustomizationData.fromJson(
          Map<String, dynamic>.from(json['eventCustomizationData'] as Map)),
      eventType: _$enumDecode(_$EventTypeEnumMap, json['eventType']),
      startTimestamp: json['startTimestamp'] as int,
      endTimestamp: json['endTimestamp'] as int,
      completionTimestamp: json['completionTimestamp'] as int?,
      status: _$enumDecode(_$EventStatusEnumMap, json['status']),
      bannerImgUrl: json['bannerImgUrl'] as String? ??
          'https://www.discgolfpark.com/wp-content/uploads/2018/04/simon_putt.jpg',
      participantCount: json['participantCount'] as int,
      creator: MyPuttUserMetadata.fromJson(
          Map<String, dynamic>.from(json['creator'] as Map)),
      creatorUid: json['creatorUid'] as String,
      admins: (json['admins'] as List<dynamic>)
          .map((e) =>
              MyPuttUserMetadata.fromJson(Map<String, dynamic>.from(e as Map)))
          .toList(),
      adminUids:
          (json['adminUids'] as List<dynamic>).map((e) => e as String).toList(),
    );

Map<String, dynamic> _$MyPuttEventToJson(MyPuttEvent instance) =>
    <String, dynamic>{
      'eventId': instance.eventId,
      'clubId': instance.clubId,
      'code': instance.code,
      'name': instance.name,
      'description': instance.description,
      'eventCustomizationData': instance.eventCustomizationData.toJson(),
      'eventType': _$EventTypeEnumMap[instance.eventType],
      'startTimestamp': instance.startTimestamp,
      'endTimestamp': instance.endTimestamp,
      'status': _$EventStatusEnumMap[instance.status],
      'completionTimestamp': instance.completionTimestamp,
      'bannerImgUrl': instance.bannerImgUrl,
      'participantCount': instance.participantCount,
      'creator': instance.creator.toJson(),
      'creatorUid': instance.creatorUid,
      'admins': instance.admins.map((e) => e.toJson()).toList(),
      'adminUids': instance.adminUids,
    };

K _$enumDecode<K, V>(
  Map<K, V> enumValues,
  Object? source, {
  K? unknownValue,
}) {
  if (source == null) {
    throw ArgumentError(
      'A value must be provided. Supported values: '
      '${enumValues.values.join(', ')}',
    );
  }

  return enumValues.entries.singleWhere(
    (e) => e.value == source,
    orElse: () {
      if (unknownValue == null) {
        throw ArgumentError(
          '`$source` is not one of the supported values: '
          '${enumValues.values.join(', ')}',
        );
      }
      return MapEntry(unknownValue, enumValues.values.first);
    },
  ).key;
}

const _$EventTypeEnumMap = {
  EventType.club: 'club',
  EventType.tournament: 'tournament',
};

const _$EventStatusEnumMap = {
  EventStatus.upcoming: 'upcoming',
  EventStatus.active: 'active',
  EventStatus.complete: 'complete',
};

EventCustomizationData _$EventCustomizationDataFromJson(Map json) =>
    EventCustomizationData(
      challengeStructure: (json['challengeStructure'] as List<dynamic>)
          .map((e) => ChallengeStructureItem.fromJson(
              Map<String, dynamic>.from(e as Map)))
          .toList(),
      divisions: (json['divisions'] as List<dynamic>)
          .map((e) => _$enumDecode(_$DivisionEnumMap, e))
          .toList(),
      verificationRequired: json['verificationRequired'] as bool,
    );

Map<String, dynamic> _$EventCustomizationDataToJson(
        EventCustomizationData instance) =>
    <String, dynamic>{
      'challengeStructure':
          instance.challengeStructure.map((e) => e.toJson()).toList(),
      'divisions': instance.divisions.map((e) => _$DivisionEnumMap[e]).toList(),
      'verificationRequired': instance.verificationRequired,
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
