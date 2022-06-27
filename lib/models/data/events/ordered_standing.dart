import 'package:json_annotation/json_annotation.dart';
import 'package:myputt/models/data/events/event_player_data.dart';

part 'ordered_standing.g.dart';

@JsonSerializable(explicitToJson: true, anyMap: true)
class OrderedStanding {
  OrderedStanding({
    required this.eventPlayerData,
    required this.puttsMade,
    required this.position,
  });
  final EventPlayerData eventPlayerData;
  final int puttsMade;
  final String position;

  factory OrderedStanding.fromJson(Map<String, dynamic> json) =>
      _$OrderedStandingFromJson(json);

  Map<String, dynamic> toJson() => _$OrderedStandingToJson(this);
}
