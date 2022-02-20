import 'package:json_annotation/json_annotation.dart';
import 'package:myputt/data/types/pdga_player_info.dart';

part 'myputt_user.g.dart';

@JsonSerializable(explicitToJson: true, anyMap: true)
class MyPuttUser {
  MyPuttUser({
    required this.username,
    required this.keywords,
    required this.displayName,
    required this.uid,
    this.pdgaNum,
  });
  final String username;
  final List<String> keywords;
  final String displayName;
  final String uid;
  final int? pdgaNum;

  factory MyPuttUser.fromJson(Map<String, dynamic> json) =>
      _$MyPuttUserFromJson(json);

  Map<String, dynamic> toJson() => _$MyPuttUserToJson(this);
}
