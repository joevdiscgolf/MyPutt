import 'package:json_annotation/json_annotation.dart';
import 'package:myputt/data/types/events/event_enums.dart';
import 'package:myputt/data/types/events/event_player_data.dart';
import 'package:myputt/data/types/events/myputt_event.dart';

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
