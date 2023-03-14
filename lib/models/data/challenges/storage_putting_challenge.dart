import 'package:json_annotation/json_annotation.dart';
import 'package:myputt/models/data/challenges/putting_challenge.dart';
import 'package:myputt/models/data/sessions/putting_set.dart';
import 'package:myputt/models/data/challenges/challenge_structure_item.dart';
import 'package:myputt/models/data/users/myputt_user.dart';
import 'package:myputt/utils/challenge_helpers.dart';
import 'package:myputt/utils/constants.dart';
import 'package:myputt/models/data/sessions/putting_session.dart';

part 'storage_putting_challenge.g.dart';

@JsonSerializable(explicitToJson: true, anyMap: true)
class StoragePuttingChallenge {
  StoragePuttingChallenge({
    required this.status,
    required this.creationTimeStamp,
    this.completionTimeStamp,
    required this.id,
    required this.challengerUser,
    this.recipientUser,
    required this.challengeStructure,
    required this.challengerSets,
    required this.recipientSets,
  });

  String status;
  final int creationTimeStamp;
  late final int? completionTimeStamp;
  final String id;
  final MyPuttUser challengerUser;
  final MyPuttUser? recipientUser;
  final List<ChallengeStructureItem> challengeStructure;
  final List<PuttingSet> challengerSets;
  final List<PuttingSet> recipientSets;

  factory StoragePuttingChallenge.fromPuttingChallenge(
      PuttingChallenge challenge, MyPuttUser currentUser) {
    MyPuttUser? recipientUser;
    MyPuttUser challengerUser;
    List<PuttingSet> recipientSets;

    if (challenge.recipientUser == null) {
      recipientUser = null;
      recipientSets = [];
    } else {
      recipientUser = challenge.recipientUser?.uid == currentUser.uid
          ? currentUser
          : challenge.opponentUser;
      recipientSets = challenge.recipientUser?.uid == currentUser.uid
          ? challenge.currentUserSets
          : challenge.opponentSets;
    }

    if (challenge.opponentUser == null) {
      challengerUser = currentUser;
    } else {
      challengerUser = challenge.challengerUser.uid == currentUser.uid
          ? currentUser
          : challenge.opponentUser!;
    }

    return StoragePuttingChallenge(
      status: challenge.status,
      creationTimeStamp: challenge.creationTimeStamp,
      id: challenge.id,
      challengerUser: challengerUser,
      recipientUser: recipientUser,
      challengeStructure: challenge.challengeStructure,
      challengerSets: challenge.challengerUser.uid == currentUser.uid
          ? challenge.currentUserSets
          : challenge.opponentSets,
      recipientSets: recipientSets,
      completionTimeStamp: challenge.completionTimeStamp,
    );
  }

  factory StoragePuttingChallenge.fromSession(
      PuttingSession session, MyPuttUser currentUser,
      {MyPuttUser? opponentUser}) {
    final now = DateTime.now().millisecondsSinceEpoch;
    return StoragePuttingChallenge(
      status: ChallengeStatus.pending,
      creationTimeStamp: now,
      id: session.id,
      challengeStructure:
          ChallengeHelpers.challengeStructureFromSession(session),
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
