import 'package:json_annotation/json_annotation.dart';

part 'generated_challenge_item.g.dart';

@JsonSerializable(explicitToJson: true, anyMap: true)
class GeneratedChallengeInstruction {
  GeneratedChallengeInstruction({
    required this.distance,
    required this.setCount,
    required this.setLength,
  });
  final int distance;
  final int setCount;
  final int setLength;

  factory GeneratedChallengeInstruction.fromJson(Map<String, dynamic> json) =>
      _$GeneratedChallengeInstructionFromJson(json);

  Map<String, dynamic> toJson() => _$GeneratedChallengeInstructionToJson(this);
}
