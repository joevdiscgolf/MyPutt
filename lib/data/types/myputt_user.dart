import 'package:json_annotation/json_annotation.dart';

part 'myputt_user.g.dart';

@JsonSerializable(explicitToJson: true, anyMap: true)
class MyPuttUser {
  MyPuttUser(
      {required this.username,
      required this.displayName,
      required this.uid,
      this.pdgaNum});
  final String username;
  final String displayName;
  final String uid;
  final int? pdgaNum;

  factory MyPuttUser.fromJson(Map<String, dynamic> json) =>
      _$MyPuttUserFromJson(json);

  Map<String, dynamic> toJson() => _$MyPuttUserToJson(this);
}
