import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:myputt/models/data/users/settings/session_settings.dart';

part 'user_settings.g.dart';

@JsonSerializable(explicitToJson: true, anyMap: true)
class UserSettings extends Equatable {
  const UserSettings({this.sessionSettings});
  final SessionSettings? sessionSettings;
  factory UserSettings.fromJson(Map<String, dynamic> json) =>
      _$UserSettingsFromJson(json);

  Map<String, dynamic> toJson() => _$UserSettingsToJson(this);

  @override
  List<Object?> get props => [sessionSettings];
}
