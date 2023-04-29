import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:myputt/utils/enums.dart';

part 'frisbee_avatar.g.dart';

@JsonSerializable(explicitToJson: true, anyMap: true)
class FrisbeeAvatar extends Equatable {
  const FrisbeeAvatar({
    this.backgroundColorHex = '2196F3',
    this.frisbeeIconColor = FrisbeeIconColor.red,
  });
  final String backgroundColorHex;
  final FrisbeeIconColor frisbeeIconColor;

  factory FrisbeeAvatar.fromJson(Map<String, dynamic> json) =>
      _$FrisbeeAvatarFromJson(json);

  Map<String, dynamic> toJson() => _$FrisbeeAvatarToJson(this);

  @override
  List<Object?> get props => [backgroundColorHex];
}
