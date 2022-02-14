import 'package:json_annotation/json_annotation.dart';
import 'package:myputt/data/types/putting_challenge.dart';
import 'package:myputt/data/types/putting_set.dart';

import '../../utils/constants.dart';
import 'myputt_user.dart';

part 'storage_putting_challenge.g.dart';

@JsonSerializable(explicitToJson: true, anyMap: true)
class StoragePuttingChallenge {
  StoragePuttingChallenge(
      {required this.status,
      required this.creationTimeStamp,
      required this.id,
      required this.challengerUser,
      required this.recipientUser,
      required this.challengeStructureDistances,
      required this.challengerSets,
      required this.recipientSets});

  ChallengeStatus status;
  final int creationTimeStamp;
  final String id;
  final MyPuttUser challengerUser;
  final MyPuttUser recipientUser;
  final List<int> challengeStructureDistances;
  final List<PuttingSet> challengerSets;
  final List<PuttingSet> recipientSets;

  factory StoragePuttingChallenge.fromPuttingChallenge(
      PuttingChallenge challenge, MyPuttUser currentUser) {
    return StoragePuttingChallenge(
        status: challenge.status,
        creationTimeStamp: challenge.creationTimeStamp,
        id: challenge.id,
        challengerUser: challenge.opponentUser.uid == currentUser.uid
            ? currentUser
            : challenge.currentUser,
        recipientUser: challenge.currentUser.uid == currentUser.uid
            ? currentUser
            : challenge.opponentUser,
        challengeStructureDistances: challenge.challengeStructureDistances,
        challengerSets: challenge.opponentUser.uid == currentUser.uid
            ? challenge.opponentSets
            : challenge.currentUserSets,
        recipientSets: challenge.currentUser.uid == currentUser.uid
            ? challenge.currentUserSets
            : challenge.opponentSets);
  }

  factory StoragePuttingChallenge.fromJson(Map<String, dynamic> json) =>
      _$StoragePuttingChallengeFromJson(json);

  Map<String, dynamic> toJson() => _$StoragePuttingChallengeToJson(this);
}
