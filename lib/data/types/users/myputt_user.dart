import 'package:json_annotation/json_annotation.dart';
import 'package:myputt/data/types/users/frisbee_avatar.dart';
import 'package:myputt/data/types/users/settings/user_settings.dart';

part 'myputt_user.g.dart';

@JsonSerializable(explicitToJson: true, anyMap: true)
class MyPuttUser {
  MyPuttUser(
      {required this.username,
      required this.keywords,
      required this.displayName,
      required this.uid,
      this.pdgaNum,
      this.frisbeeAvatar,
      this.userSettings,
      this.eventIds});
  final String username;
  final List<String> keywords;
  final String displayName;
  final String uid;
  int? pdgaNum;
  FrisbeeAvatar? frisbeeAvatar;
  UserSettings? userSettings;
  final List<String>? eventIds;

  factory MyPuttUser.fromJson(Map<String, dynamic> json) =>
      _$MyPuttUserFromJson(json);

  Map<String, dynamic> toJson() => _$MyPuttUserToJson(this);
}

@JsonSerializable(explicitToJson: true, anyMap: true)
class MyPuttUserMetadata {
  MyPuttUserMetadata({
    required this.username,
    required this.displayName,
    required this.uid,
    this.pdgaNum,
    this.frisbeeAvatar,
  });
  final String username;
  final String displayName;
  final String uid;
  int? pdgaNum;
  FrisbeeAvatar? frisbeeAvatar;

  factory MyPuttUserMetadata.fromJson(Map<String, dynamic> json) =>
      _$MyPuttUserMetadataFromJson(json);

  Map<String, dynamic> toJson() => _$MyPuttUserMetadataToJson(this);
}
