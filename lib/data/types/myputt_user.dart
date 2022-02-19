import 'dart:io' show File;
import 'package:json_annotation/json_annotation.dart';

part 'myputt_user.g.dart';

@JsonSerializable(explicitToJson: true, anyMap: true)
class MyPuttUser {
  MyPuttUser(
      {required this.username,
      required this.keywords,
      required this.displayName,
      required this.uid,
      this.pdgaNum,
      this.profilePicture});
  final String username;
  final List<String> keywords;
  final String displayName;
  final String uid;
  final int? pdgaNum;
  final File? profilePicture;

  factory MyPuttUser.fromJson(Map<String, dynamic> json) =>
      _$MyPuttUserFromJson(json);

  Map<String, dynamic> toJson() => _$MyPuttUserToJson(this);
}
