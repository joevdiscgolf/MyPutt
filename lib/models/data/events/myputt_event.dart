import 'package:json_annotation/json_annotation.dart';
import 'package:myputt/models/data/challenges/challenge_structure_item.dart';
import 'package:myputt/models/data/users/myputt_user.dart';
import 'event_enums.dart';

part 'myputt_event.g.dart';

@JsonSerializable(explicitToJson: true, anyMap: true)
class MyPuttEvent {
  MyPuttEvent({
    required this.eventId,
    this.clubId,
    required this.code,
    required this.name,
    this.description,
    required this.eventCustomizationData,
    required this.eventType,
    required this.startTimestamp,
    required this.endTimestamp,
    this.completionTimestamp,
    required this.status,
    this.bannerImgUrl =
        'https://www.discgolfpark.com/wp-content/uploads/2018/04/simon_putt.jpg',
    required this.participantCount,
    required this.creator,
    required this.creatorUid,
    required this.admins,
    required this.adminUids,
  });

  final String eventId;
  final String? clubId;
  final int code;
  final String name;
  final String? description;
  final EventCustomizationData eventCustomizationData;
  final EventType eventType;
  final int startTimestamp;
  final int endTimestamp;
  final EventStatus status;
  final int? completionTimestamp;
  final String? bannerImgUrl;
  final int participantCount;
  final MyPuttUserMetadata creator;
  final String creatorUid;
  final List<MyPuttUserMetadata> admins;
  final List<String> adminUids;

  factory MyPuttEvent.fromJson(Map<String, dynamic> json) =>
      _$MyPuttEventFromJson(json);

  Map<String, dynamic> toJson() => _$MyPuttEventToJson(this);
}

@JsonSerializable(explicitToJson: true, anyMap: true)
class EventCustomizationData {
  EventCustomizationData({
    required this.challengeStructure,
    required this.divisions,
    required this.verificationRequired,
  });
  final List<ChallengeStructureItem> challengeStructure;
  final List<Division> divisions;
  final bool verificationRequired;

  factory EventCustomizationData.fromJson(Map<String, dynamic> json) =>
      _$EventCustomizationDataFromJson(json);

  Map<String, dynamic> toJson() => _$EventCustomizationDataToJson(this);
}
