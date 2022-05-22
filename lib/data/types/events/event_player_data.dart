import 'package:json_annotation/json_annotation.dart';
import 'package:myputt/data/types/sessions/putting_set.dart';
import 'package:myputt/data/types/users/myputt_user.dart';
import 'event_enums.dart';

part 'event_player_data.g.dart';

@JsonSerializable(explicitToJson: true, anyMap: true)
class EventPlayerData {
  EventPlayerData(
      {required this.usermetadata,
      required this.division,
      required this.sets,
      this.verificationImg,
      required this.lockedIn});
  final MyPuttUserMetadata usermetadata;
  final Division division;
  final List<PuttingSet> sets;
  final String? verificationImg;
  final bool lockedIn;

  factory EventPlayerData.fromJson(Map<String, dynamic> json) =>
      _$EventPlayerDataFromJson(json);

  Map<String, dynamic> toJson() => _$EventPlayerDataToJson(this);
}
