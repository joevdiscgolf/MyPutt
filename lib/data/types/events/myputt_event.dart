import 'package:json_annotation/json_annotation.dart';
import 'package:myputt/data/types/challenges/challenge_structure_item.dart';

import 'event_enums.dart';

part 'myputt_event.g.dart';

@JsonSerializable(explicitToJson: true, anyMap: true)
class MyPuttEvent {
  MyPuttEvent({
    required this.id,
    required this.code,
    required this.name,
    required this.challengeStructure,
    required this.divisions,
    required this.eventType,
    required this.startTimestamp,
    required this.endTimestamp,
    required this.status,
    required this.completionTimestamp,
  });

  final String id;
  final int code;
  final String name;
  final List<ChallengeStructureItem> challengeStructure;
  final List<Division> divisions;
  final EventType eventType;
  final int startTimestamp;
  final int endTimestamp;
  final EventStatus status;
  final int completionTimestamp;

  factory MyPuttEvent.fromJson(Map<String, dynamic> json) =>
      _$MyPuttEventFromJson(json);

  Map<String, dynamic> toJson() => _$MyPuttEventToJson(this);
}
