import 'package:json_annotation/json_annotation.dart';
import 'package:myputt/data/types/storage_putting_challenge.dart';

import '../../utils/constants.dart';
import 'package:myputt/data/types/putting_set.dart';

part 'putting_challenge.g.dart';

@JsonSerializable(explicitToJson: true, anyMap: true)
class PuttingChallenge {
  PuttingChallenge(
      {required this.status,
      required this.creationTimeStamp,
      required this.id,
      required this.opponentUid,
      required this.currentUid,
      required this.challengeStructureDistances,
      required this.opponentSets,
      required this.currentUserSets});

  ChallengeStatus status;
  final int creationTimeStamp;
  final String id;
  final String opponentUid;
  final String currentUid;
  final List<int> challengeStructureDistances;
  final List<PuttingSet> opponentSets;
  final List<PuttingSet> currentUserSets;

  factory PuttingChallenge.fromStorageChallenge(
      StoragePuttingChallenge storageChallenge, String currentUid) {
    return PuttingChallenge(
        status: storageChallenge.status,
        creationTimeStamp: storageChallenge.creationTimeStamp,
        id: storageChallenge.id,
        opponentUid: storageChallenge.challengerUid == currentUid
            ? currentUid
            : storageChallenge.recipientUid,
        currentUid: storageChallenge.recipientUid == currentUid
            ? currentUid
            : storageChallenge.challengerUid,
        challengeStructureDistances:
            storageChallenge.challengeStructureDistances,
        opponentSets: storageChallenge.challengerUid == currentUid
            ? storageChallenge.challengerSets
            : storageChallenge.recipientSets,
        currentUserSets: storageChallenge.recipientUid == currentUid
            ? storageChallenge.recipientSets
            : storageChallenge.challengerSets);
  }

  factory PuttingChallenge.fromJson(Map<String, dynamic> json) =>
      _$PuttingChallengeFromJson(json);

  Map<String, dynamic> toJson() => _$PuttingChallengeToJson(this);
}
