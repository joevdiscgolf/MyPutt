import 'package:json_annotation/json_annotation.dart';
import 'package:myputt/data/types/challenges/putting_challenge.dart';
import 'package:myputt/data/types/putting_set.dart';
import 'package:myputt/data/types/challenges/challenge_structure_item.dart';
import 'package:myputt/data/types/myputt_user.dart';

import '../../../utils/constants.dart';
import '../../../utils/utils.dart';
import '../putting_session.dart';

part 'storage_putting_challenge.g.dart';

@JsonSerializable(explicitToJson: true, anyMap: true)
class StoragePuttingChallenge {
  StoragePuttingChallenge(
      {required this.status,
      required this.creationTimeStamp,
      required this.id,
      required this.challengerUser,
      this.recipientUser,
      required this.challengeStructure,
      required this.challengerSets,
      required this.recipientSets});

  String status;
  final int creationTimeStamp;
  final String id;
  final MyPuttUser challengerUser;
  final MyPuttUser? recipientUser;
  final List<ChallengeStructureItem> challengeStructure;
  final List<PuttingSet> challengerSets;
  final List<PuttingSet> recipientSets;

  factory StoragePuttingChallenge.fromPuttingChallenge(
      PuttingChallenge challenge, MyPuttUser currentUser) {
    return StoragePuttingChallenge(
        status: challenge.status,
        creationTimeStamp: challenge.creationTimeStamp,
        id: challenge.id,
        challengerUser: challenge.challengerUser.uid == currentUser.uid
            ? currentUser
            : challenge.opponentUser,
        recipientUser: challenge.recipientUser.uid == currentUser.uid
            ? currentUser
            : challenge.challengerUser,
        challengeStructure: challenge.challengeStructure,
        challengerSets: challenge.challengerUser.uid == currentUser.uid
            ? challenge.currentUserSets
            : challenge.opponentSets,
        recipientSets: challenge.recipientUser.uid == currentUser.uid
            ? challenge.currentUserSets
            : challenge.opponentSets);
  }

  factory StoragePuttingChallenge.fromSession(
      PuttingSession session, MyPuttUser currentUser,
      {MyPuttUser? opponentUser}) {
    final now = DateTime.now().millisecondsSinceEpoch;
    return StoragePuttingChallenge(
      status: ChallengeStatus.pending,
      creationTimeStamp: now,
      id: currentUser.uid + '~' + now.toString(),
      challengeStructure: challengeStructureFromSession(session),
      recipientSets: [],
      challengerSets: session.sets,
      challengerUser: currentUser,
      recipientUser: opponentUser,
    );
  }

  factory StoragePuttingChallenge.fromJson(Map<String, dynamic> json) =>
      _$StoragePuttingChallengeFromJson(json);

  Map<String, dynamic> toJson() => _$StoragePuttingChallengeToJson(this);
}
