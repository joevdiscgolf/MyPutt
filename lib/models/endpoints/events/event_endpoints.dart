import 'package:json_annotation/json_annotation.dart';
import 'package:myputt/models/data/challenges/challenge_structure_item.dart';
import 'package:myputt/models/data/events/event_enums.dart';
import 'package:myputt/models/data/events/event_player_data.dart';
import 'package:myputt/models/data/events/myputt_event.dart';
import 'package:myputt/models/data/sessions/putting_set.dart';

part 'event_endpoints.g.dart';

@JsonSerializable(explicitToJson: true, anyMap: true)
class GetEventRequest {
  const GetEventRequest({required this.eventId});
  final String eventId;

  factory GetEventRequest.fromJson(Map<String, dynamic> json) =>
      _$GetEventRequestFromJson(json);

  Map<String, dynamic> toJson() => _$GetEventRequestToJson(this);
}

@JsonSerializable(explicitToJson: true, anyMap: true)
class GetEventResponse {
  const GetEventResponse({this.event, required this.inEvent});
  final MyPuttEvent? event;
  final bool inEvent;

  factory GetEventResponse.fromJson(Map<String, dynamic> json) =>
      _$GetEventResponseFromJson(json);

  Map<String, dynamic> toJson() => _$GetEventResponseToJson(this);
}

@JsonSerializable(explicitToJson: true, anyMap: true)
class JoinEventRequest {
  const JoinEventRequest({required this.division, required this.eventId});
  final Division division;
  final String eventId;

  factory JoinEventRequest.fromJson(Map<String, dynamic> json) =>
      _$JoinEventRequestFromJson(json);

  Map<String, dynamic> toJson() => _$JoinEventRequestToJson(this);
}

@JsonSerializable(explicitToJson: true, anyMap: true)
class JoinEventWithCodeRequest {
  const JoinEventWithCodeRequest({
    required this.division,
    this.code,
    this.codeRequired,
  });
  final Division division;
  final int? code;
  final bool? codeRequired;

  factory JoinEventWithCodeRequest.fromJson(Map<String, dynamic> json) =>
      _$JoinEventWithCodeRequestFromJson(json);

  Map<String, dynamic> toJson() => _$JoinEventWithCodeRequestToJson(this);
}

@JsonSerializable(explicitToJson: true, anyMap: true)
class JoinEventResponse {
  const JoinEventResponse({required this.success, this.error});
  final bool success;
  final String? error;

  factory JoinEventResponse.fromJson(Map<String, dynamic> json) =>
      _$JoinEventResponseFromJson(json);

  Map<String, dynamic> toJson() => _$JoinEventResponseToJson(this);
}

@JsonSerializable(explicitToJson: true, anyMap: true)
class SearchEventsRequest {
  const SearchEventsRequest({required this.keyword});
  final String keyword;

  factory SearchEventsRequest.fromJson(Map<String, dynamic> json) =>
      _$SearchEventsRequestFromJson(json);

  Map<String, dynamic> toJson() => _$SearchEventsRequestToJson(this);
}

@JsonSerializable(explicitToJson: true, anyMap: true)
class GetEventsResponse {
  const GetEventsResponse({required this.events});
  final List<MyPuttEvent> events;

  factory GetEventsResponse.fromJson(Map<String, dynamic> json) =>
      _$GetEventsResponseFromJson(json);

  Map<String, dynamic> toJson() => _$GetEventsResponseToJson(this);
}

@JsonSerializable(explicitToJson: true, anyMap: true)
class SavePlayerSetsRequest {
  const SavePlayerSetsRequest({
    required this.eventId,
    required this.sets,
    this.lockedIn,
  });
  final String eventId;
  final List<PuttingSet> sets;
  final bool? lockedIn;

  factory SavePlayerSetsRequest.fromJson(Map<String, dynamic> json) =>
      _$SavePlayerSetsRequestFromJson(json);

  Map<String, dynamic> toJson() => _$SavePlayerSetsRequestToJson(this);
}

@JsonSerializable(explicitToJson: true, anyMap: true)
class SavePlayerSetsResponse {
  const SavePlayerSetsResponse({required this.success, this.eventStatus});
  final bool success;
  final EventStatus? eventStatus;

  factory SavePlayerSetsResponse.fromJson(Map<String, dynamic> json) =>
      _$SavePlayerSetsResponseFromJson(json);

  Map<String, dynamic> toJson() => _$SavePlayerSetsResponseToJson(this);
}

@JsonSerializable(explicitToJson: true, anyMap: true)
class GetEventPlayerDataRequest {
  const GetEventPlayerDataRequest({required this.eventId});
  final String eventId;

  factory GetEventPlayerDataRequest.fromJson(Map<String, dynamic> json) =>
      _$GetEventPlayerDataRequestFromJson(json);

  Map<String, dynamic> toJson() => _$GetEventPlayerDataRequestToJson(this);
}

@JsonSerializable(explicitToJson: true, anyMap: true)
class GetEventPlayerDataResponse {
  const GetEventPlayerDataResponse({this.eventPlayerData});
  final EventPlayerData? eventPlayerData;

  factory GetEventPlayerDataResponse.fromJson(Map<String, dynamic> json) =>
      _$GetEventPlayerDataResponseFromJson(json);

  Map<String, dynamic> toJson() => _$GetEventPlayerDataResponseToJson(this);
}

@JsonSerializable(explicitToJson: true, anyMap: true)
class ExitEventRequest {
  const ExitEventRequest({required this.eventId});
  final String eventId;

  factory ExitEventRequest.fromJson(Map<String, dynamic> json) =>
      _$ExitEventRequestFromJson(json);

  Map<String, dynamic> toJson() => _$ExitEventRequestToJson(this);
}

@JsonSerializable(explicitToJson: true, anyMap: true)
class ExitEventResponse {
  const ExitEventResponse({required this.success});
  final bool success;

  factory ExitEventResponse.fromJson(Map<String, dynamic> json) =>
      _$ExitEventResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ExitEventResponseToJson(this);
}

@JsonSerializable(explicitToJson: true, anyMap: true)
class CreateEventRequest {
  const CreateEventRequest({
    required this.eventCreateParams,
    this.clubId,
  });
  final EventCreateParams eventCreateParams;
  final String? clubId;

  factory CreateEventRequest.fromJson(Map<String, dynamic> json) =>
      _$CreateEventRequestFromJson(json);

  Map<String, dynamic> toJson() => _$CreateEventRequestToJson(this);
}

@JsonSerializable(explicitToJson: true, anyMap: true)
class CreateEventResponse {
  const CreateEventResponse({this.eventId});
  final String? eventId;

  factory CreateEventResponse.fromJson(Map<String, dynamic> json) =>
      _$CreateEventResponseFromJson(json);

  Map<String, dynamic> toJson() => _$CreateEventResponseToJson(this);
}

@JsonSerializable(explicitToJson: true, anyMap: true)
class EventCreateParams {
  const EventCreateParams({
    required this.name,
    required this.description,
    required this.verificationRequired,
    required this.divisions,
    required this.startDate,
    required this.endDate,
    required this.challengeStructure,
  });
  final String name;
  final String? description;
  final bool verificationRequired;
  final List<Division> divisions;
  final String startDate;
  final String endDate;
  final List<ChallengeStructureItem> challengeStructure;

  factory EventCreateParams.fromJson(Map<String, dynamic> json) =>
      _$EventCreateParamsFromJson(json);

  Map<String, dynamic> toJson() => _$EventCreateParamsToJson(this);
}

@JsonSerializable(explicitToJson: true, anyMap: true)
class EndEventRequest {
  const EndEventRequest({required this.eventId});
  final String eventId;

  factory EndEventRequest.fromJson(Map<String, dynamic> json) =>
      _$EndEventRequestFromJson(json);

  Map<String, dynamic> toJson() => _$EndEventRequestToJson(this);
}

@JsonSerializable(explicitToJson: true, anyMap: true)
class EndEventResponse {
  const EndEventResponse({required this.success});
  final bool success;

  factory EndEventResponse.fromJson(Map<String, dynamic> json) =>
      _$EndEventResponseFromJson(json);

  Map<String, dynamic> toJson() => _$EndEventResponseToJson(this);
}
