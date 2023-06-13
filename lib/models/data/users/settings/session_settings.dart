import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'session_settings.g.dart';

@JsonSerializable(explicitToJson: true, anyMap: true)
class SessionSettings extends Equatable {
  const SessionSettings({
    this.preferredDistance,
    this.preferredPuttsPickerLength,
  });
  final int? preferredDistance;
  final int? preferredPuttsPickerLength;

  factory SessionSettings.fromJson(Map<String, dynamic> json) =>
      _$SessionSettingsFromJson(json);

  Map<String, dynamic> toJson() => _$SessionSettingsToJson(this);

  @override
  List<Object?> get props => [preferredDistance, preferredPuttsPickerLength];
}
