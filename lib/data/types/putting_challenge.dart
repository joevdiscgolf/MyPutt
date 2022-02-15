import 'package:flutter/material.dart';
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
      required this.challengerUser,
      required this.recipientUser,
      required this.challengeStructureDistances,
      required this.opponentSets,
      required this.currentUserSets});

  String status;
  final int creationTimeStamp;
  final String id;
  final MyPuttUser opponentUser;
  final MyPuttUser currentUser;
  final MyPuttUser challengerUser;
  final MyPuttUser recipientUser;
  final List<int> challengeStructureDistances;
  final List<PuttingSet> opponentSets;
  final List<PuttingSet> currentUserSets;

  factory PuttingChallenge.fromStorageChallenge(
      StoragePuttingChallenge storageChallenge, MyPuttUser currentUser) {
    print(storageChallenge.recipientUser);
    print(storageChallenge.challengerUser);
    return PuttingChallenge(
      status: storageChallenge.status,
      creationTimeStamp: storageChallenge.creationTimeStamp,
      id: storageChallenge.id,
      opponentUser: storageChallenge.challengerUser.uid == currentUser.uid
          ? storageChallenge.recipientUser
          : storageChallenge.challengerUser,
      currentUser: storageChallenge.recipientUser.uid == currentUser.uid
          ? storageChallenge.recipientUser
          : storageChallenge.challengerUser,
      challengeStructureDistances: storageChallenge.challengeStructureDistances,
      opponentSets: storageChallenge.challengerUser.uid == currentUser.uid
          ? storageChallenge.recipientSets
          : storageChallenge.challengerSets,
      currentUserSets: storageChallenge.recipientUser.uid == currentUser.uid
          ? storageChallenge.recipientSets
          : storageChallenge.challengerSets,
      challengerUser: storageChallenge.challengerUser,
      recipientUser: storageChallenge.recipientUser,
    );
  }

  factory PuttingChallenge.fromJson(Map<String, dynamic> json) =>
      _$PuttingChallengeFromJson(json);

  Map<String, dynamic> toJson() => _$PuttingChallengeToJson(this);
}
