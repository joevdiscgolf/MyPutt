// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'event_endpoints.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GetEventRequest _$GetEventRequestFromJson(Map json) => GetEventRequest(
      eventId: json['eventId'] as String,
    );

Map<String, dynamic> _$GetEventRequestToJson(GetEventRequest instance) =>
    <String, dynamic>{
      'eventId': instance.eventId,
    };

GetEventResponse _$GetEventResponseFromJson(Map json) => GetEventResponse(
      event: json['event'] == null
          ? null
          : MyPuttEvent.fromJson(
              Map<String, dynamic>.from(json['event'] as Map)),
      inEvent: json['inEvent'] as bool,
    );

Map<String, dynamic> _$GetEventResponseToJson(GetEventResponse instance) =>
    <String, dynamic>{
      'event': instance.event?.toJson(),
      'inEvent': instance.inEvent,
    };

JoinEventRequest _$JoinEventRequestFromJson(Map json) => JoinEventRequest(
      division: $enumDecode(_$DivisionEnumMap, json['division']),
      eventId: json['eventId'] as String,
    );

Map<String, dynamic> _$JoinEventRequestToJson(JoinEventRequest instance) =>
    <String, dynamic>{
      'division': _$DivisionEnumMap[instance.division]!,
      'eventId': instance.eventId,
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

JoinEventWithCodeRequest _$JoinEventWithCodeRequestFromJson(Map json) =>
    JoinEventWithCodeRequest(
      division: $enumDecode(_$DivisionEnumMap, json['division']),
      code: json['code'] as int?,
      codeRequired: json['codeRequired'] as bool?,
    );

Map<String, dynamic> _$JoinEventWithCodeRequestToJson(
        JoinEventWithCodeRequest instance) =>
    <String, dynamic>{
      'division': _$DivisionEnumMap[instance.division]!,
      'code': instance.code,
      'codeRequired': instance.codeRequired,
    };

JoinEventResponse _$JoinEventResponseFromJson(Map json) => JoinEventResponse(
      success: json['success'] as bool,
      error: json['error'] as String?,
    );

Map<String, dynamic> _$JoinEventResponseToJson(JoinEventResponse instance) =>
    <String, dynamic>{
      'success': instance.success,
      'error': instance.error,
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

GetEventsResponse _$GetEventsResponseFromJson(Map json) => GetEventsResponse(
      events: (json['events'] as List<dynamic>)
          .map((e) => MyPuttEvent.fromJson(Map<String, dynamic>.from(e as Map)))
          .toList(),
    );

Map<String, dynamic> _$GetEventsResponseToJson(GetEventsResponse instance) =>
    <String, dynamic>{
      'events': instance.events.map((e) => e.toJson()).toList(),
    };

SavePlayerSetsRequest _$SavePlayerSetsRequestFromJson(Map json) =>
    SavePlayerSetsRequest(
      eventId: json['eventId'] as String,
      sets: (json['sets'] as List<dynamic>)
          .map((e) => PuttingSet.fromJson(Map<String, dynamic>.from(e as Map)))
          .toList(),
      lockedIn: json['lockedIn'] as bool?,
    );

Map<String, dynamic> _$SavePlayerSetsRequestToJson(
        SavePlayerSetsRequest instance) =>
    <String, dynamic>{
      'eventId': instance.eventId,
      'sets': instance.sets.map((e) => e.toJson()).toList(),
      'lockedIn': instance.lockedIn,
    };

SavePlayerSetsResponse _$SavePlayerSetsResponseFromJson(Map json) =>
    SavePlayerSetsResponse(
      success: json['success'] as bool,
      eventStatus:
          $enumDecodeNullable(_$EventStatusEnumMap, json['eventStatus']),
    );

Map<String, dynamic> _$SavePlayerSetsResponseToJson(
        SavePlayerSetsResponse instance) =>
    <String, dynamic>{
      'success': instance.success,
      'eventStatus': _$EventStatusEnumMap[instance.eventStatus],
    };

const _$EventStatusEnumMap = {
  EventStatus.upcoming: 'upcoming',
  EventStatus.active: 'active',
  EventStatus.complete: 'complete',
};

GetEventPlayerDataRequest _$GetEventPlayerDataRequestFromJson(Map json) =>
    GetEventPlayerDataRequest(
      eventId: json['eventId'] as String,
    );

Map<String, dynamic> _$GetEventPlayerDataRequestToJson(
        GetEventPlayerDataRequest instance) =>
    <String, dynamic>{
      'eventId': instance.eventId,
    };

GetEventPlayerDataResponse _$GetEventPlayerDataResponseFromJson(Map json) =>
    GetEventPlayerDataResponse(
      eventPlayerData: json['eventPlayerData'] == null
          ? null
          : EventPlayerData.fromJson(
              Map<String, dynamic>.from(json['eventPlayerData'] as Map)),
    );

Map<String, dynamic> _$GetEventPlayerDataResponseToJson(
        GetEventPlayerDataResponse instance) =>
    <String, dynamic>{
      'eventPlayerData': instance.eventPlayerData?.toJson(),
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
          .map((e) => $enumDecode(_$DivisionEnumMap, e))
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
      'divisions':
          instance.divisions.map((e) => _$DivisionEnumMap[e]!).toList(),
      'startDate': instance.startDate,
      'endDate': instance.endDate,
      'challengeStructure':
          instance.challengeStructure.map((e) => e.toJson()).toList(),
    };

EndEventRequest _$EndEventRequestFromJson(Map json) => EndEventRequest(
      eventId: json['eventId'] as String,
    );

Map<String, dynamic> _$EndEventRequestToJson(EndEventRequest instance) =>
    <String, dynamic>{
      'eventId': instance.eventId,
    };

EndEventResponse _$EndEventResponseFromJson(Map json) => EndEventResponse(
      success: json['success'] as bool,
    );

Map<String, dynamic> _$EndEventResponseToJson(EndEventResponse instance) =>
    <String, dynamic>{
      'success': instance.success,
    };
