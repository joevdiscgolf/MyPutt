import 'package:json_annotation/json_annotation.dart';

import '../../utils/constants.dart';
import 'package:myputt/data/types/putting_set.dart';

part 'putting_challenge.g.dart';

@JsonSerializable(explicitToJson: true, anyMap: true)
class PuttingChallenge {
  PuttingChallenge(
      {required this.status,
      required this.creationTimeStamp,
      required this.id,
      required this.challengerUid,
      required this.recipientUid,
      required this.challengeStructureDistances,
      required this.challengerSets,
      required this.recipientSets});

  ChallengeStatus status;
  final int creationTimeStamp;
  final String id;
  final String challengerUid;
  final String recipientUid;
  final List<int> challengeStructureDistances;
  final List<PuttingSet> challengerSets;
  final List<PuttingSet> recipientSets;

  factory PuttingChallenge.fromJson(Map<String, dynamic> json) =>
      _$PuttingChallengeFromJson(json);

  Map<String, dynamic> toJson() => _$PuttingChallengeToJson(this);
}
