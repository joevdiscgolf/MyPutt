import 'package:json_annotation/json_annotation.dart';
import 'package:myputt/data/types/myputt_user.dart';
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
      required this.opponentUser,
      required this.currentUser,
      required this.challengeStructureDistances,
      required this.opponentSets,
      required this.currentUserSets});

  ChallengeStatus status;
  final int creationTimeStamp;
  final String id;
  final MyPuttUser opponentUser;
  final MyPuttUser currentUser;
  final List<int> challengeStructureDistances;
  final List<PuttingSet> opponentSets;
  final List<PuttingSet> currentUserSets;

  factory PuttingChallenge.fromStorageChallenge(
      StoragePuttingChallenge storageChallenge, MyPuttUser currentUser) {
    return PuttingChallenge(
        status: storageChallenge.status,
        creationTimeStamp: storageChallenge.creationTimeStamp,
        id: storageChallenge.id,
        opponentUser: storageChallenge.challengerUser.uid == currentUser.uid
            ? currentUser
            : storageChallenge.recipientUser,
        currentUser: storageChallenge.recipientUser.uid == currentUser.uid
            ? currentUser
            : storageChallenge.challengerUser,
        challengeStructureDistances:
            storageChallenge.challengeStructureDistances,
        opponentSets: storageChallenge.challengerUser.uid == currentUser.uid
            ? storageChallenge.challengerSets
            : storageChallenge.recipientSets,
        currentUserSets: storageChallenge.recipientUser.uid == currentUser.uid
            ? storageChallenge.recipientSets
            : storageChallenge.challengerSets);
  }

  factory PuttingChallenge.fromJson(Map<String, dynamic> json) =>
      _$PuttingChallengeFromJson(json);

  Map<String, dynamic> toJson() => _$PuttingChallengeToJson(this);
}
