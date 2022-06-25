import 'package:json_annotation/json_annotation.dart';

part 'challenge_structure_item.g.dart';

@JsonSerializable(explicitToJson: true, anyMap: true)
class ChallengeStructureItem {
  ChallengeStructureItem({required this.distance, required this.setLength});
  final int distance;
  final int setLength;

  factory ChallengeStructureItem.fromJson(Map<String, dynamic> json) =>
      _$ChallengeStructureItemFromJson(json);

  Map<String, dynamic> toJson() => _$ChallengeStructureItemToJson(this);
}
