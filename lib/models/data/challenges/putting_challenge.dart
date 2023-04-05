import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:myputt/models/data/users/myputt_user.dart';
import 'package:myputt/models/data/challenges/storage_putting_challenge.dart';
import 'package:myputt/models/data/challenges/challenge_structure_item.dart';
import 'package:myputt/models/data/sessions/putting_set.dart';
part 'putting_challenge.g.dart';

@JsonSerializable(explicitToJson: true, anyMap: true)
class PuttingChallenge extends Equatable {
  const PuttingChallenge({
    required this.status,
    required this.creationTimeStamp,
    required this.id,
    this.opponentUser,
    required this.currentUser,
    required this.challengerUser,
    required this.recipientUser,
    required this.challengeStructure,
    required this.opponentSets,
    required this.currentUserSets,
    this.completionTimeStamp,
    this.isSynced,
    this.isDeleted,
    this.currentUserSetsUpdatedAt,
    this.opponentSetsUpdatedAt,
    this.challengerSetsUpdatedAt,
    this.recipientSetsUpdatedAt,
  });

  final String status;
  final int creationTimeStamp;
  final int? completionTimeStamp;
  final String id;
  final MyPuttUser? opponentUser;
  final MyPuttUser currentUser;
  final MyPuttUser challengerUser;
  final MyPuttUser? recipientUser;
  final List<ChallengeStructureItem> challengeStructure;
  final List<PuttingSet> opponentSets;
  final List<PuttingSet> currentUserSets;
  final bool? isSynced;
  final bool? isDeleted;
  final String? currentUserSetsUpdatedAt;
  final String? opponentSetsUpdatedAt;
  final String? challengerSetsUpdatedAt;
  final String? recipientSetsUpdatedAt;

  factory PuttingChallenge.fromStorageChallenge(
    StoragePuttingChallenge storageChallenge,
    MyPuttUser currentUser,
  ) {
    final bool currentUserIsChallenger =
        storageChallenge.challengerUser.uid == currentUser.uid;

    MyPuttUser? recipientUser = storageChallenge.recipientUser;
    late final MyPuttUser? opponentUser;
    late final List<PuttingSet> opponentSets;
    late final List<PuttingSet> currentUserSets;
    late final String? currentUserSetsUpdatedAt;
    late final String? opponentSetsUpdatedAt;

    // current user is challenger, opponent is recipient
    if (currentUserIsChallenger) {
      currentUserSets = storageChallenge.challengerSets;
      currentUserSetsUpdatedAt = storageChallenge.challengerSetsUpdatedAt;

      opponentUser = storageChallenge.recipientUser;
      opponentSets = storageChallenge.recipientSets;
      opponentSetsUpdatedAt = storageChallenge.recipientSetsUpdatedAt;
    } else {
      // current user is recipient, opponent is challenger.
      currentUserSets = storageChallenge.recipientSets;
      currentUserSetsUpdatedAt = storageChallenge.recipientSetsUpdatedAt;
      recipientUser ??= currentUser;

      opponentUser = storageChallenge.challengerUser;
      opponentSets = storageChallenge.challengerSets;
      opponentSetsUpdatedAt = storageChallenge.challengerSetsUpdatedAt;
    }

    return PuttingChallenge(
      status: storageChallenge.status,
      creationTimeStamp: storageChallenge.creationTimeStamp,
      id: storageChallenge.id,
      currentUser: currentUser,
      opponentUser: opponentUser,
      opponentSets: opponentSets,
      currentUserSets: currentUserSets,
      challengerUser: storageChallenge.challengerUser,
      recipientUser: recipientUser,
      isDeleted: storageChallenge.isDeleted,
      isSynced: storageChallenge.isSynced,
      challengeStructure: storageChallenge.challengeStructure,
      completionTimeStamp: storageChallenge.completionTimeStamp,
      currentUserSetsUpdatedAt: currentUserSetsUpdatedAt,
      opponentSetsUpdatedAt: opponentSetsUpdatedAt,
      challengerSetsUpdatedAt: storageChallenge.challengerSetsUpdatedAt,
      recipientSetsUpdatedAt: storageChallenge.recipientSetsUpdatedAt,
    );
  }

  PuttingChallenge copyWith({
    String? status,
    int? creationTimeStamp,
    int? completionTimeStamp,
    String? id,
    MyPuttUser? opponentUser,
    MyPuttUser? currentUser,
    MyPuttUser? challengerUser,
    MyPuttUser? recipientUser,
    List<ChallengeStructureItem>? challengeStructure,
    List<PuttingSet>? opponentSets,
    List<PuttingSet>? currentUserSets,
    bool? isSynced,
    bool? isDeleted,
    String? currentUserSetsUpdatedAt,
    String? opponentSetsUpdatedAt,
    String? challengerSetsUpdatedAt,
    String? recipientSetsUpdatedAt,
  }) {
    return PuttingChallenge(
      status: status ?? this.status,
      creationTimeStamp: creationTimeStamp ?? this.creationTimeStamp,
      id: id ?? this.id,
      currentUser: currentUser ?? this.currentUser,
      opponentUser: opponentUser ?? this.opponentUser,
      opponentSets: opponentSets ?? this.opponentSets,
      currentUserSets: currentUserSets ?? this.currentUserSets,
      challengerUser: challengerUser ?? this.currentUser,
      recipientUser: recipientUser ?? this.recipientUser,
      isDeleted: isDeleted ?? this.isDeleted,
      isSynced: isSynced ?? this.isSynced,
      challengeStructure: challengeStructure ?? this.challengeStructure,
      completionTimeStamp: completionTimeStamp ?? this.completionTimeStamp,
      currentUserSetsUpdatedAt:
          currentUserSetsUpdatedAt ?? this.currentUserSetsUpdatedAt,
      opponentSetsUpdatedAt:
          opponentSetsUpdatedAt ?? this.opponentSetsUpdatedAt,
      challengerSetsUpdatedAt:
          challengerSetsUpdatedAt ?? this.currentUserSetsUpdatedAt,
      recipientSetsUpdatedAt:
          recipientSetsUpdatedAt ?? this.recipientSetsUpdatedAt,
    );
  }

  factory PuttingChallenge.fromJson(Map<String, dynamic> json) =>
      _$PuttingChallengeFromJson(json);

  Map<String, dynamic> toJson() => _$PuttingChallengeToJson(this);

  @override
  List<Object?> get props => [id];
}
