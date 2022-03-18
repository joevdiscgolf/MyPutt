import 'package:json_annotation/json_annotation.dart';
import 'package:myputt/data/types/users/frisbee_avatar.dart';

part 'myputt_user.g.dart';

@JsonSerializable(explicitToJson: true, anyMap: true)
class MyPuttUser {
  MyPuttUser({
    required this.username,
    required this.keywords,
    required this.displayName,
    required this.uid,
    this.pdgaNum,
    this.frisbeeAvatar,
  });
  final String username;
  final List<String> keywords;
  final String displayName;
  final String uid;
  int? pdgaNum;
  FrisbeeAvatar? frisbeeAvatar;

  factory MyPuttUser.fromJson(Map<String, dynamic> json) =>
      _$MyPuttUserFromJson(json);

  Map<String, dynamic> toJson() => _$MyPuttUserToJson(this);
}
