import 'package:json_annotation/json_annotation.dart';
import 'package:myputt/data/types/events/event_enums.dart';
import 'package:myputt/data/types/events/event_player_data.dart';

part 'event_endpoints.g.dart';

@JsonSerializable(explicitToJson: true, anyMap: true)
class GetEventStandingsRequest {
  GetEventStandingsRequest({required this.eventId, required this.division});
  final String eventId;
  final Division? division;

  factory GetEventStandingsRequest.fromJson(Map<String, dynamic> json) =>
      _$GetEventStandingsRequestFromJson(json);

  Map<String, dynamic> toJson() => _$GetEventStandingsRequestToJson(this);
}

@JsonSerializable(explicitToJson: true, anyMap: true)
class GetEventStandingsResponse {
  GetEventStandingsResponse({this.eventStandings});
  final List<EventPlayerData>? eventStandings;

  factory GetEventStandingsResponse.fromJson(Map<String, dynamic> json) =>
      _$GetEventStandingsResponseFromJson(json);

  Map<String, dynamic> toJson() => _$GetEventStandingsResponseToJson(this);
}
