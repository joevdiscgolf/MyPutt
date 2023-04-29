import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:myputt/models/data/users/frisbee_avatar.dart';
import 'package:myputt/models/data/users/settings/user_settings.dart';

part 'myputt_user.g.dart';

@JsonSerializable(explicitToJson: true, anyMap: true)
class MyPuttUser extends Equatable {
  const MyPuttUser({
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
  final int? pdgaNum;
  final int? pdgaRating;
  final FrisbeeAvatar? frisbeeAvatar;
  final UserSettings? userSettings;
  final List<String>? eventIds;
  final bool? isAdmin;
  final List<String>? trebuchets;

  MyPuttUser copyWith({
    String? username,
    List<String>? keywords,
    String? displayName,
    String? uid,
    int? pdgaNum,
    int? pdgaRating,
    FrisbeeAvatar? frisbeeAvatar,
    UserSettings? userSettings,
    List<String>? eventIds,
    bool? isAdmin,
    List<String>? trebuchets,
  }) {
    return MyPuttUser(
      username: username ?? this.username,
      keywords: keywords ?? this.keywords,
      displayName: displayName ?? this.displayName,
      uid: uid ?? this.uid,
      pdgaNum: pdgaNum ?? this.pdgaNum,
      pdgaRating: pdgaRating ?? this.pdgaRating,
      frisbeeAvatar: frisbeeAvatar ?? this.frisbeeAvatar,
      userSettings: userSettings ?? this.userSettings,
      eventIds: eventIds ?? this.eventIds,
      isAdmin: isAdmin ?? this.isAdmin,
      trebuchets: trebuchets ?? this.trebuchets,
    );
  }

  factory MyPuttUser.fromJson(Map<String, dynamic> json) =>
      _$MyPuttUserFromJson(json);

  Map<String, dynamic> toJson() => _$MyPuttUserToJson(this);

  @override
  List<Object?> get props => [
        username,
        keywords,
        displayName,
        uid,
        pdgaNum,
        pdgaRating,
        frisbeeAvatar,
        userSettings,
        eventIds,
        isAdmin,
        trebuchets,
      ];
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
