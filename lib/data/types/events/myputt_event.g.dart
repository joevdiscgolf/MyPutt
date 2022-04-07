// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'myputt_event.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MyPuttEvent _$MyPuttEventFromJson(Map json) => MyPuttEvent(
      id: json['id'] as String,
      code: json['code'] as int,
      name: json['name'] as String,
      challengeStructure: (json['challengeStructure'] as List<dynamic>)
          .map((e) => ChallengeStructureItem.fromJson(
              Map<String, dynamic>.from(e as Map)))
          .toList(),
      divisions: (json['divisions'] as List<dynamic>)
          .map((e) => _$enumDecode(_$DivisionEnumMap, e))
          .toList(),
      eventType: _$enumDecode(_$EventTypeEnumMap, json['eventType']),
      endTimestamp: json['endTimestamp'] as int,
      status: _$enumDecode(_$EventStatusEnumMap, json['status']),
      creationTimestamp: json['creationTimestamp'] as int,
      completionTimestamp: json['completionTimestamp'] as int,
    );

Map<String, dynamic> _$MyPuttEventToJson(MyPuttEvent instance) =>
    <String, dynamic>{
      'id': instance.id,
      'code': instance.code,
      'name': instance.name,
      'challengeStructure':
          instance.challengeStructure.map((e) => e.toJson()).toList(),
      'divisions': instance.divisions.map((e) => _$DivisionEnumMap[e]).toList(),
      'eventType': _$EventTypeEnumMap[instance.eventType],
      'endTimestamp': instance.endTimestamp,
      'status': _$EventStatusEnumMap[instance.status],
      'creationTimestamp': instance.creationTimestamp,
      'completionTimestamp': instance.completionTimestamp,
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
};

const _$EventTypeEnumMap = {
  EventType.club: 'club',
  EventType.tournament: 'tournament',
};

const _$EventStatusEnumMap = {
  EventStatus.upcoming: 'upcoming',
  EventStatus.active: 'active',
  EventStatus.complete: 'complete',
};
