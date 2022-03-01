import 'package:json_annotation/json_annotation.dart';

part 'generated_challenge_item.g.dart';

@JsonSerializable(explicitToJson: true, anyMap: true)
class GeneratedChallengeItem {
  GeneratedChallengeItem({required this.distance, required this.numSets});
  final int distance;
  final int numSets;

  factory GeneratedChallengeItem.fromJson(Map<String, dynamic> json) =>
      _$GeneratedChallengeItemFromJson(json);

  Map<String, dynamic> toJson() => _$GeneratedChallengeItemToJson(this);
}
