import 'package:json_annotation/json_annotation.dart';
import 'package:myputt/data/types/putting_challenge.dart';
import 'package:myputt/data/types/putting_set.dart';

import '../../utils/constants.dart';

part 'storage_putting_challenge.g.dart';

@JsonSerializable(explicitToJson: true, anyMap: true)
class StoragePuttingChallenge {
  StoragePuttingChallenge(
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

  factory StoragePuttingChallenge.fromPuttingChallenge(
      PuttingChallenge challenge, String currentUid) {
    return StoragePuttingChallenge(
        status: challenge.status,
        creationTimeStamp: challenge.creationTimeStamp,
        id: challenge.id,
        challengerUid: challenge.opponentUid == currentUid
            ? currentUid
            : challenge.currentUid,
        recipientUid: challenge.currentUid == currentUid
            ? currentUid
            : challenge.opponentUid,
        challengeStructureDistances: challenge.challengeStructureDistances,
        challengerSets: challenge.opponentUid == currentUid
            ? challenge.opponentSets
            : challenge.currentUserSets,
        recipientSets: challenge.currentUid == currentUid
            ? challenge.currentUserSets
            : challenge.opponentSets);
  }

  factory StoragePuttingChallenge.fromJson(Map<String, dynamic> json) =>
      _$StoragePuttingChallengeFromJson(json);

  Map<String, dynamic> toJson() => _$StoragePuttingChallengeToJson(this);
}
