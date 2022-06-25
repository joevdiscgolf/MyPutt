import 'package:json_annotation/json_annotation.dart';
import 'package:myputt/models/data/users/frisbee_avatar.dart';
import 'package:myputt/models/data/users/settings/user_settings.dart';

part 'myputt_user.g.dart';

@JsonSerializable(explicitToJson: true, anyMap: true)
class MyPuttUser {
  MyPuttUser({
    required this.username,
    required this.keywords,
    required this.displayName,
    required this.uid,
    this.pdgaNum,
    this.pdgaRating,
    this.frisbeeAvatar,
    this.userSettings,
    this.eventIds,
    this.isAdmin,
    this.trebuchets,
  });
  final String username;
  final List<String> keywords;
  final String displayName;
  final String uid;
  int? pdgaNum;
  int? pdgaRating;
  FrisbeeAvatar? frisbeeAvatar;
  UserSettings? userSettings;
  final List<String>? eventIds;
  final bool? isAdmin;
  final List<String>? trebuchets;

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
    this.pdgaRating,
    this.frisbeeAvatar,
  });
  final String username;
  final String displayName;
  final String uid;
  int? pdgaNum;
  int? pdgaRating;
  FrisbeeAvatar? frisbeeAvatar;

  factory MyPuttUserMetadata.fromJson(Map<String, dynamic> json) =>
      _$MyPuttUserMetadataFromJson(json);

  Map<String, dynamic> toJson() => _$MyPuttUserMetadataToJson(this);
}
