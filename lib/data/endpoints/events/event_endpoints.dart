import 'package:json_annotation/json_annotation.dart';
import 'package:myputt/data/types/challenges/challenge_structure_item.dart';
import 'package:myputt/data/types/events/event_enums.dart';
import 'package:myputt/data/types/events/event_player_data.dart';
import 'package:myputt/data/types/events/myputt_event.dart';
import 'package:myputt/data/types/sessions/putting_set.dart';

part 'event_endpoints.g.dart';

@JsonSerializable(explicitToJson: true, anyMap: true)
class GetEventRequest {
  GetEventRequest({
    required this.eventId,
    required this.division,
  });
  final String eventId;
  final Division? division;

  factory GetEventRequest.fromJson(Map<String, dynamic> json) =>
      _$GetEventRequestFromJson(json);

  Map<String, dynamic> toJson() => _$GetEventRequestToJson(this);
}

@JsonSerializable(explicitToJson: true, anyMap: true)
class GetEventResponse {
  GetEventResponse({
    required this.inEvent,
    this.eventStandings,
  });
  final bool inEvent;
  final List<EventPlayerData>? eventStandings;

  factory GetEventResponse.fromJson(Map<String, dynamic> json) =>
      _$GetEventResponseFromJson(json);

  Map<String, dynamic> toJson() => _$GetEventResponseToJson(this);
}

@JsonSerializable(explicitToJson: true, anyMap: true)
class JoinEventWithCodeRequest {
  JoinEventWithCodeRequest({
    required this.code,
    required this.division,
  });
  final int code;
  final Division division;

  factory JoinEventWithCodeRequest.fromJson(Map<String, dynamic> json) =>
      _$JoinEventWithCodeRequestFromJson(json);

  Map<String, dynamic> toJson() => _$JoinEventWithCodeRequestToJson(this);
}

@JsonSerializable(explicitToJson: true, anyMap: true)
class JoinEventResponse {
  JoinEventResponse({required this.success});
  final bool success;

  factory JoinEventResponse.fromJson(Map<String, dynamic> json) =>
      _$JoinEventResponseFromJson(json);

  Map<String, dynamic> toJson() => _$JoinEventResponseToJson(this);
}

@JsonSerializable(explicitToJson: true, anyMap: true)
class SearchEventsRequest {
  SearchEventsRequest({required this.keyword});
  final String keyword;

  factory SearchEventsRequest.fromJson(Map<String, dynamic> json) =>
      _$SearchEventsRequestFromJson(json);

  Map<String, dynamic> toJson() => _$SearchEventsRequestToJson(this);
}

@JsonSerializable(explicitToJson: true, anyMap: true)
class SearchEventsResponse {
  SearchEventsResponse({required this.events});
  final List<MyPuttEvent> events;

  factory SearchEventsResponse.fromJson(Map<String, dynamic> json) =>
      _$SearchEventsResponseFromJson(json);

  Map<String, dynamic> toJson() => _$SearchEventsResponseToJson(this);
}

@JsonSerializable(explicitToJson: true, anyMap: true)
class UpdatePlayerSetsRequest {
  UpdatePlayerSetsRequest(
      {required this.eventId, required this.sets, this.lockedIn});
  final String eventId;
  final List<PuttingSet> sets;
  final bool? lockedIn;

  factory UpdatePlayerSetsRequest.fromJson(Map<String, dynamic> json) =>
      _$UpdatePlayerSetsRequestFromJson(json);

  Map<String, dynamic> toJson() => _$UpdatePlayerSetsRequestToJson(this);
}

@JsonSerializable(explicitToJson: true, anyMap: true)
class UpdatePlayerSetsResponse {
  UpdatePlayerSetsResponse({required this.success});
  final bool success;

  factory UpdatePlayerSetsResponse.fromJson(Map<String, dynamic> json) =>
      _$UpdatePlayerSetsResponseFromJson(json);

  Map<String, dynamic> toJson() => _$UpdatePlayerSetsResponseToJson(this);
}

@JsonSerializable(explicitToJson: true, anyMap: true)
class ExitEventRequest {
  ExitEventRequest({required this.eventId});
  final String eventId;

  factory ExitEventRequest.fromJson(Map<String, dynamic> json) =>
      _$ExitEventRequestFromJson(json);

  Map<String, dynamic> toJson() => _$ExitEventRequestToJson(this);
}

@JsonSerializable(explicitToJson: true, anyMap: true)
class ExitEventResponse {
  ExitEventResponse({required this.success});
  final bool success;

  factory ExitEventResponse.fromJson(Map<String, dynamic> json) =>
      _$ExitEventResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ExitEventResponseToJson(this);
}

@JsonSerializable(explicitToJson: true, anyMap: true)
class CreateEventRequest {
  CreateEventRequest({
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
  CreateEventResponse({this.eventId});
  final String? eventId;

  factory CreateEventResponse.fromJson(Map<String, dynamic> json) =>
      _$CreateEventResponseFromJson(json);

  Map<String, dynamic> toJson() => _$CreateEventResponseToJson(this);
}

@JsonSerializable(explicitToJson: true, anyMap: true)
class EventCreateParams {
  EventCreateParams({
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
