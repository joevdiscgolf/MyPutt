import 'package:json_annotation/json_annotation.dart';
import 'package:myputt/data/types/users/myputt_user.dart';
import 'package:myputt/data/types/challenges/storage_putting_challenge.dart';
import 'package:myputt/data/types/challenges/challenge_structure_item.dart';
import 'package:myputt/data/types/putting_set.dart';
import 'package:myputt/locator.dart';
import 'package:myputt/services/auth_service.dart';
part 'putting_challenge.g.dart';

@JsonSerializable(explicitToJson: true, anyMap: true)
class PuttingChallenge {
  PuttingChallenge({
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
  });

  String status;
  final int creationTimeStamp;
  int? completionTimeStamp;
  final String id;
  final MyPuttUser? opponentUser;
  final MyPuttUser currentUser;
  final MyPuttUser challengerUser;
  final MyPuttUser? recipientUser;
  final List<ChallengeStructureItem> challengeStructure;
  List<PuttingSet> opponentSets;
  final List<PuttingSet> currentUserSets;

  factory PuttingChallenge.fromStorageChallenge(
      StoragePuttingChallenge storageChallenge, MyPuttUser currentUser) {
    final String? currentUid = locator.get<AuthService>().getCurrentUserId();
    MyPuttUser recipientUser;

    // recipient user is only the current user if it's null and the current user is not the challenger.
    if (storageChallenge.recipientUser == null &&
        storageChallenge.challengerUser.uid != currentUid) {
      recipientUser = currentUser;

      return PuttingChallenge(
        status: storageChallenge.status,
        creationTimeStamp: storageChallenge.creationTimeStamp,
        id: storageChallenge.id,
        opponentUser: storageChallenge.challengerUser.uid == currentUser.uid
            ? recipientUser
            : storageChallenge.challengerUser,
        currentUser: recipientUser.uid == currentUser.uid
            ? recipientUser
            : storageChallenge.challengerUser,
        challengeStructure: storageChallenge.challengeStructure,
        opponentSets: storageChallenge.challengerUser.uid == currentUser.uid
            ? storageChallenge.recipientSets
            : storageChallenge.challengerSets,
        currentUserSets: recipientUser.uid == currentUser.uid
            ? storageChallenge.recipientSets
            : storageChallenge.challengerSets,
        challengerUser: storageChallenge.challengerUser,
        recipientUser: recipientUser,
        completionTimeStamp: storageChallenge.completionTimeStamp,
      );
    }
    return PuttingChallenge(
      status: storageChallenge.status,
      creationTimeStamp: storageChallenge.creationTimeStamp,
      id: storageChallenge.id,
      opponentUser: storageChallenge.challengerUser.uid == currentUser.uid
          ? storageChallenge.recipientUser
          : storageChallenge.challengerUser,
      currentUser: storageChallenge.recipientUser!.uid == currentUser.uid
          ? storageChallenge.recipientUser!
          : storageChallenge.challengerUser,
      challengeStructure: storageChallenge.challengeStructure,
      opponentSets: storageChallenge.challengerUser.uid == currentUser.uid
          ? storageChallenge.recipientSets
          : storageChallenge.challengerSets,
      currentUserSets: storageChallenge.recipientUser!.uid == currentUser.uid
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
