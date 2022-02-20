import 'package:json_annotation/json_annotation.dart';

part 'pdga_player_info.g.dart';

@JsonSerializable(explicitToJson: true, anyMap: true)
class PDGAPlayerInfo {
  PDGAPlayerInfo(
      {required this.location,
      required this.classification,
      required this.memberSince,
      required this.rating,
      required this.careerEarnings,
      required this.careerEvents,
      required this.nextEvent,
      required this.careerWins});
  final String location;
  final String classification;
  final String memberSince;
  final int rating;
  final int careerEvents;
  final double careerEarnings;
  final int careerWins;
  final String nextEvent;

  factory PDGAPlayerInfo.fromJson(Map<String, dynamic> json) =>
      _$PDGAPlayerInfoFromJson(json);

  Map<String, dynamic> toJson() => _$PDGAPlayerInfoToJson(this);
}
