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
    this.challengerSetsUpdatedAt,
    this.recipientSetsUpdatedAt,
    this.isDeleted,
    this.isSynced,
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
  final String? challengerSetsUpdatedAt;
  final String? recipientSetsUpdatedAt;
  final bool? isDeleted;
  final bool? isSynced;

  factory StoragePuttingChallenge.fromPuttingChallenge(
    PuttingChallenge challenge,
    MyPuttUser currentUser,
  ) {
    MyPuttUser? recipientUser;
    late final List<PuttingSet> recipientSets;
    late final MyPuttUser challengerUser;
    late final List<PuttingSet> challengerSets;

    late final String? challengerSetsUpdatedAt;
    late final String? recipientSetsUpdatedAt;

    final bool currentUserIsChallenger =
        challenge.challengerUser.uid == currentUser.uid;

    if (challenge.recipientUser == null) {
      recipientUser = null;
      recipientSets = [];
    } else {
      if (currentUserIsChallenger) {
        challengerUser = challenge.currentUser;
        challengerSets = challenge.currentUserSets;

        recipientUser = challenge.opponentUser;
        recipientSets = challenge.opponentSets;
      } else {
        challengerSets = challenge.opponentSets;
        challengerUser = challenge.opponentUser!;
        recipientUser = challenge.currentUser;
        recipientSets = challenge.currentUserSets;
      }
    }

    return StoragePuttingChallenge(
      status: challenge.status,
      creationTimeStamp: challenge.creationTimeStamp,
      id: challenge.id,
      challengeStructure: challenge.challengeStructure,
      challengerUser: challengerUser,
      recipientUser: recipientUser,
      challengerSets: challengerSets,
      recipientSets: recipientSets,
      completionTimeStamp: challenge.completionTimeStamp,
      isSynced: challenge.isSynced,
      isDeleted: challenge.isDeleted,
      challengerSetsUpdatedAt: challenge.challengerSetsUpdatedAt,
      recipientSetsUpdatedAt: challenge.recipientSetsUpdatedAt,
    );
  }

  factory StoragePuttingChallenge.fromSession(
    PuttingSession session,
    MyPuttUser currentUser, {
    MyPuttUser? opponentUser,
  }) {
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
