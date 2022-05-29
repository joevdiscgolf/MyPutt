// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'event_endpoints.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GetEventRequest _$GetEventRequestFromJson(Map json) => GetEventRequest(
      eventId: json['eventId'] as String,
      division: _$enumDecodeNullable(_$DivisionEnumMap, json['division']),
    );

Map<String, dynamic> _$GetEventRequestToJson(GetEventRequest instance) =>
    <String, dynamic>{
      'eventId': instance.eventId,
      'division': _$DivisionEnumMap[instance.division],
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

K? _$enumDecodeNullable<K, V>(
  Map<K, V> enumValues,
  dynamic source, {
  K? unknownValue,
}) {
  if (source == null) {
    return null;
  }
  return _$enumDecode<K, V>(enumValues, source, unknownValue: unknownValue);
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

GetEventResponse _$GetEventResponseFromJson(Map json) => GetEventResponse(
      inEvent: json['inEvent'] as bool,
      eventStandings: (json['eventStandings'] as List<dynamic>?)
          ?.map((e) =>
              EventPlayerData.fromJson(Map<String, dynamic>.from(e as Map)))
          .toList(),
    );

Map<String, dynamic> _$GetEventResponseToJson(GetEventResponse instance) =>
    <String, dynamic>{
      'inEvent': instance.inEvent,
      'eventStandings':
          instance.eventStandings?.map((e) => e.toJson()).toList(),
    };

JoinEventWithCodeRequest _$JoinEventWithCodeRequestFromJson(Map json) =>
    JoinEventWithCodeRequest(
      code: json['code'] as int,
      division: _$enumDecode(_$DivisionEnumMap, json['division']),
    );

Map<String, dynamic> _$JoinEventWithCodeRequestToJson(
        JoinEventWithCodeRequest instance) =>
    <String, dynamic>{
      'code': instance.code,
      'division': _$DivisionEnumMap[instance.division],
    };

JoinEventResponse _$JoinEventResponseFromJson(Map json) => JoinEventResponse(
      success: json['success'] as bool,
    );

Map<String, dynamic> _$JoinEventResponseToJson(JoinEventResponse instance) =>
    <String, dynamic>{
      'success': instance.success,
    };

SearchEventsRequest _$SearchEventsRequestFromJson(Map json) =>
    SearchEventsRequest(
      keyword: json['keyword'] as String,
    );

Map<String, dynamic> _$SearchEventsRequestToJson(
        SearchEventsRequest instance) =>
    <String, dynamic>{
      'keyword': instance.keyword,
    };

SearchEventsResponse _$SearchEventsResponseFromJson(Map json) =>
    SearchEventsResponse(
      events: (json['events'] as List<dynamic>)
          .map((e) => MyPuttEvent.fromJson(Map<String, dynamic>.from(e as Map)))
          .toList(),
    );

Map<String, dynamic> _$SearchEventsResponseToJson(
        SearchEventsResponse instance) =>
    <String, dynamic>{
      'events': instance.events.map((e) => e.toJson()).toList(),
    };

UpdatePlayerSetsRequest _$UpdatePlayerSetsRequestFromJson(Map json) =>
    UpdatePlayerSetsRequest(
      eventId: json['eventId'] as String,
      sets: (json['sets'] as List<dynamic>)
          .map((e) => PuttingSet.fromJson(Map<String, dynamic>.from(e as Map)))
          .toList(),
      lockedIn: json['lockedIn'] as bool?,
    );

Map<String, dynamic> _$UpdatePlayerSetsRequestToJson(
        UpdatePlayerSetsRequest instance) =>
    <String, dynamic>{
      'eventId': instance.eventId,
      'sets': instance.sets.map((e) => e.toJson()).toList(),
      'lockedIn': instance.lockedIn,
    };

UpdatePlayerSetsResponse _$UpdatePlayerSetsResponseFromJson(Map json) =>
    UpdatePlayerSetsResponse(
      success: json['success'] as bool,
    );

Map<String, dynamic> _$UpdatePlayerSetsResponseToJson(
        UpdatePlayerSetsResponse instance) =>
    <String, dynamic>{
      'success': instance.success,
    };

ExitEventRequest _$ExitEventRequestFromJson(Map json) => ExitEventRequest(
      eventId: json['eventId'] as String,
    );

Map<String, dynamic> _$ExitEventRequestToJson(ExitEventRequest instance) =>
    <String, dynamic>{
      'eventId': instance.eventId,
    };

ExitEventResponse _$ExitEventResponseFromJson(Map json) => ExitEventResponse(
      success: json['success'] as bool,
    );

Map<String, dynamic> _$ExitEventResponseToJson(ExitEventResponse instance) =>
    <String, dynamic>{
      'success': instance.success,
    };

CreateEventRequest _$CreateEventRequestFromJson(Map json) => CreateEventRequest(
      eventCreateParams: EventCreateParams.fromJson(
          Map<String, dynamic>.from(json['eventCreateParams'] as Map)),
      clubId: json['clubId'] as String?,
    );

Map<String, dynamic> _$CreateEventRequestToJson(CreateEventRequest instance) =>
    <String, dynamic>{
      'eventCreateParams': instance.eventCreateParams.toJson(),
      'clubId': instance.clubId,
    };

CreateEventResponse _$CreateEventResponseFromJson(Map json) =>
    CreateEventResponse(
      eventId: json['eventId'] as String?,
    );

Map<String, dynamic> _$CreateEventResponseToJson(
        CreateEventResponse instance) =>
    <String, dynamic>{
      'eventId': instance.eventId,
    };

EventCreateParams _$EventCreateParamsFromJson(Map json) => EventCreateParams(
      name: json['name'] as String,
      description: json['description'] as String?,
      verificationRequired: json['verificationRequired'] as bool,
      divisions: (json['divisions'] as List<dynamic>)
          .map((e) => _$enumDecode(_$DivisionEnumMap, e))
          .toList(),
      startDate: json['startDate'] as String,
      endDate: json['endDate'] as String,
      challengeStructure: (json['challengeStructure'] as List<dynamic>)
          .map((e) => ChallengeStructureItem.fromJson(
              Map<String, dynamic>.from(e as Map)))
          .toList(),
    );

Map<String, dynamic> _$EventCreateParamsToJson(EventCreateParams instance) =>
    <String, dynamic>{
      'name': instance.name,
      'description': instance.description,
      'verificationRequired': instance.verificationRequired,
      'divisions': instance.divisions.map((e) => _$DivisionEnumMap[e]).toList(),
      'startDate': instance.startDate,
      'endDate': instance.endDate,
      'challengeStructure':
          instance.challengeStructure.map((e) => e.toJson()).toList(),
    };
