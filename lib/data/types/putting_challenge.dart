import 'package:json_annotation/json_annotation.dart';

import '../../utils/constants.dart';

part 'putting_challenge.g.dart';

@JsonSerializable(explicitToJson: true, anyMap: true)
class PuttingChallenge {
  PuttingChallenge(
      {required this.status,
      required this.createdAt,
      required this.id,
      required this.challengerUid,
      required this.currentUid,
      required this.challengeStructureDistances,
      required this.challengerSets,
      required this.currentUserSets});
  ChallengeStatus status;
  final int createdAt;
  final String id;
  final String challengerUid;
  final String currentUid;
  final List<int> challengeStructureDistances; // = [10,10,15,15,20,20];
  final List<int> challengerSets; // = [6,6,7,5,4,4];
  final List<int> currentUserSets;

  factory PuttingChallenge.fromJson(Map<String, dynamic> json) =>
      _$PuttingChallengeFromJson(json);

  Map<String, dynamic> toJson() => _$PuttingChallengeToJson(this);
}
