import 'dart:math';

import 'package:myputt/locator.dart';
import 'package:myputt/models/data/challenges/challenge_structure_item.dart';
import 'package:myputt/models/data/challenges/generated_challenge_item.dart';
import 'package:myputt/models/data/challenges/putting_challenge.dart';
import 'package:myputt/models/data/sessions/putting_session.dart';
import 'package:collection/collection.dart';
import 'package:myputt/models/data/users/myputt_user.dart';
import 'package:myputt/repositories/presets_repository.dart';
import 'package:myputt/utils/calculators.dart';
import 'package:myputt/utils/constants.dart';
import 'package:myputt/utils/enums.dart';

abstract class ChallengeHelpers {
  static bool currentUserSetsComplete(PuttingChallenge challenge) {
    return challenge.currentUserSets.length ==
        challenge.challengeStructure.length;
  }

  static bool isDuplicateChallenge(
    List<PuttingSession> sessions,
    PuttingChallenge challenge,
  ) {
    final PuttingSession? match = sessions.firstWhereOrNull(
      (session) => session.id == challenge.id,
    );
    return match != null;
  }

  static int getChallengeStructureIndex(
    int challengeStructureLength,
    int currentUserSetsLength,
  ) {
    return min(challengeStructureLength - 1, currentUserSetsLength);
  }

  static int getCurrentDistanceRequired(PuttingChallenge challenge) {
    final int challengeStructureIndex = min(
      challenge.challengeStructure.length - 1,
      challenge.currentUserSets.length,
    );

    return challenge.challengeStructure[challengeStructureIndex].distance;
  }

  static bool challengeSetsUpdated(
    PuttingChallenge previousChallenge,
    PuttingChallenge currentChallenge,
  ) {
    final bool opponentSetsEqual =
        previousChallenge.opponentSets == currentChallenge.opponentSets;
    final bool currentSetsEqual =
        previousChallenge.currentUserSets == currentChallenge.currentUserSets;
    return !(opponentSetsEqual && currentSetsEqual);
  }

  static List<PuttingChallenge> filterDuplicateChallenges(
      List<PuttingSession> sessions, List<PuttingChallenge> challenges) {
    return challenges
        .where((challenge) => !isDuplicateChallenge(sessions, challenge))
        .toList();
  }

  static List<ChallengeStructureItem> challengeStructureFromSession(
      PuttingSession session) {
    return session.sets
        .map((set) => ChallengeStructureItem(
            distance: set.distance.toInt(),
            setLength: set.puttsAttempted.toInt()))
        .toList();
  }

  static List<ChallengeStructureItem> challengeStructureFromInstructions(
    List<GeneratedChallengeInstruction> instructions,
  ) {
    List<ChallengeStructureItem> items = [];

    for (var instruction in instructions) {
      for (var i = 0; i < instruction.setCount; i++) {
        items.add(
          ChallengeStructureItem(
            distance: instruction.distance,
            setLength: instruction.setLength,
          ),
        );
      }
    }
    return items;
  }

  static ChallengeResult resultFromChallenge(PuttingChallenge challenge) {
    final int differenceInPuttsMade = getDifferenceFromChallenge(challenge);

    if (differenceInPuttsMade > 0) {
      return ChallengeResult.win;
    } else if (differenceInPuttsMade < 0) {
      return ChallengeResult.loss;
    } else {
      return ChallengeResult.draw;
    }
  }

  // find challenges where the current user sets are different between the cloud and local.
  // Determine which is source of truth based on currentUserSetsUpdatedAt.
  static List<PuttingChallenge> updatedActiveChallenges(
    List<PuttingChallenge> localChallenges,
    List<PuttingChallenge> cloudChallenges,
  ) {
    final List<PuttingChallenge> mergedActiveChallenges = [];

    final List<PuttingChallenge> cloudActiveChallenges = cloudChallenges
        .where(
            (cloudChallenge) => cloudChallenge.status == ChallengeStatus.active)
        .toList();
    final List<PuttingChallenge> localActiveChallenges = localChallenges
        .where(
            (localChallenge) => localChallenge.status == ChallengeStatus.active)
        .toList();

    // Add matching challenges to mergedChallenges list and determine source of truth challenge.
    for (PuttingChallenge cloudChallenge in cloudActiveChallenges) {
      final PuttingChallenge? matchingLocalChallenge =
          localChallenges.firstWhereOrNull(
        (localChallenge) {
          return localChallenge.id == cloudChallenge.id;
        },
      );

      if (matchingLocalChallenge == null) continue;

      mergedActiveChallenges.add(
        ChallengeHelpers.determineSourceOfTruthChallenge(
          cloudChallenge,
          matchingLocalChallenge,
        ),
      );
    }

    List<String> mergedChallengeIds = mergedActiveChallenges
        .map((mergedChallenge) => mergedChallenge.id)
        .toList();

    // Add local challenges if they have not been already.
    for (PuttingChallenge localChallenge in localActiveChallenges) {
      if (!mergedChallengeIds.contains(localChallenge.id)) {
        mergedActiveChallenges.add(localChallenge);
      }
    }

    return mergedActiveChallenges;
  }

  // SOT challenge = Source of Truth Challenge
  static List<PuttingChallenge> mergeSOTChallenges({
    required final List<PuttingChallenge> sotChallenges,
    required final List<PuttingChallenge> allChallenges,
  }) {
    List<PuttingChallenge> mergedChallenges = [];

    for (PuttingChallenge challenge in allChallenges) {
      final PuttingChallenge? matchingSOTChallenge =
          sotChallenges.firstWhereOrNull(
        (sotChallenge) => sotChallenge.id == challenge.id,
      );
      mergedChallenges.add(matchingSOTChallenge ?? challenge);
    }

    return mergedChallenges;
  }

  static List<PuttingChallenge> setSyncedToTrue(
    List<PuttingChallenge> unsyncedChallenges,
  ) {
    List<PuttingChallenge> syncedChallenges = [];
    for (PuttingChallenge challenge in unsyncedChallenges) {
      final Map<String, dynamic> json = challenge.toJson();
      json['isSynced'] = true;
      syncedChallenges.add(PuttingChallenge.fromJson(json));
    }
    return syncedChallenges;
  }

  static List<PuttingChallenge> mergeCloudChallenges(
    List<PuttingChallenge> unsyncedLocalChallenges,
    List<PuttingChallenge> cloudChallenges,
  ) {
    final List<String> localChallengeIds =
        unsyncedLocalChallenges.map((challenge) => challenge.id).toList();

    // include the local unsynced challenges
    // include cloud challenges if the cloud challenge is not stored locally and the device Id does not match
    // if the device id does match, that means the challenge has been deleted locally but not in the cloud yet
    return [
      ...unsyncedLocalChallenges,
      ...cloudChallenges.where(
        (cloudChallenge) => !localChallengeIds.contains(cloudChallenge.id),
      )
    ];
  }

  // new cloud challenge if not deleted locally.
  static List<PuttingChallenge> getNewCloudChallenges(
    List<PuttingChallenge> localChallenges,
    List<PuttingChallenge> cloudChallenges,
  ) {
    final List<String> localChallengeIds = localChallenges
        .where((challenge) => challenge.isDeleted != true)
        .map((challenge) => challenge.id)
        .toList();

    return cloudChallenges
        .where(
            (cloudChallenge) => !localChallengeIds.contains(cloudChallenge.id))
        .toList();
  }

  static List<PuttingChallenge> getChallengesDeletedInCloud(
    List<PuttingChallenge> localChallenges,
    List<PuttingChallenge> cloudChallenges,
  ) {
    final List<String> cloudChallengeIds =
        cloudChallenges.map((cloudChallenge) => cloudChallenge.id).toList();

    final List<PuttingChallenge> syncedLocalChallenges =
        localChallenges.where((localChallenge) {
      return localChallenge.isSynced == true;
    }).toList();

    // challenge has been deleted in the cloud if the synced local challenge exists, but not the cloud challenge.
    return syncedLocalChallenges
        .where((syncedLocalChallenge) =>
            !cloudChallengeIds.contains(syncedLocalChallenge.id))
        .toList();
  }

  static List<PuttingChallenge> getChallengesDeletedLocally(
    List<PuttingChallenge> localChallenges,
    List<PuttingChallenge> cloudChallenges,
  ) {
    // challenge has been deleted locally if marked as such.
    return localChallenges
        .where((localChallenges) => localChallenges.isDeleted == true)
        .toList();
  }

  static List<PuttingChallenge> removeChallenges(
    List<PuttingChallenge> challengesToRemove,
    List<PuttingChallenge> allChallenges,
  ) {
    final Iterable<String> idsToRemove =
        challengesToRemove.map((challengeToRemove) => challengeToRemove.id);
    return allChallenges
        .where((challenge) => !idsToRemove.contains(challenge.id))
        .toList();
  }

  static PuttingChallenge determineSourceOfTruthChallenge(
    PuttingChallenge cloudChallenge,
    PuttingChallenge localChallenge,
  ) {
    final bool currentUserSetsChanged =
        cloudChallenge.currentUserSets != localChallenge.currentUserSets;

    if (!currentUserSetsChanged) {
      return cloudChallenge;
    }

    if (cloudChallenge.currentUserSetsUpdatedAt != null &&
        localChallenge.currentUserSetsUpdatedAt != null) {
      final int cloudChallengeUpdatedAtMs =
          DateTime.parse(cloudChallenge.currentUserSetsUpdatedAt!)
              .millisecondsSinceEpoch;
      final int localChallengeUpdatedAtMs =
          DateTime.parse(localChallenge.currentUserSetsUpdatedAt!)
              .millisecondsSinceEpoch;

      // local challenge updated more recently
      if (localChallengeUpdatedAtMs > cloudChallengeUpdatedAtMs) {
        // copy the cloud challenge with the current user sets of the local challenge.
        // All other data in the cloud challenge is most up to date.
        return cloudChallenge.copyWith(
          currentUserSets: localChallenge.currentUserSets,
        );
      } else {
        // if cloud challenge updated more recently
        return cloudChallenge;
      }
    } else if (cloudChallenge.currentUserSetsUpdatedAt == null) {
      return cloudChallenge.copyWith(
        currentUserSets: localChallenge.currentUserSets,
      );
    } else {
      return cloudChallenge;
    }
  }

  static PuttingChallenge getChallengeFromPreset(
    ChallengePreset challengePreset,
    MyPuttUser currentUser,
    MyPuttUser recipientUser,
  ) {
    final int timestamp = DateTime.now().millisecondsSinceEpoch;
    final List<ChallengeStructureItem> challengeStructure = locator
        .get<PresetsRepository>()
        .getChallengeStructureByPreset(challengePreset);
    return PuttingChallenge(
      status: ChallengeStatus.active,
      creationTimeStamp: DateTime.now().millisecondsSinceEpoch,
      id: '${currentUser.uid}~$timestamp',
      currentUser: currentUser,
      opponentUser: recipientUser,
      challengerUser: currentUser,
      recipientUser: recipientUser,
      challengeStructure: challengeStructure,
      currentUserSets: const [],
      opponentSets: const [],
    );
  }

  static PuttingChallenge mergeCurrentChallengeWithCloudCopy(
    PuttingChallenge localCurrentChallenge,
    PuttingChallenge cloudCurrentChallenge,
  ) {
    late final String challengeStatus;

    if (localCurrentChallenge.status == ChallengeStatus.active &&
        cloudCurrentChallenge.status == ChallengeStatus.pending) {
      challengeStatus = ChallengeStatus.active;
    } else if (localCurrentChallenge.status == ChallengeStatus.complete &&
        cloudCurrentChallenge.status == ChallengeStatus.active) {
      challengeStatus = ChallengeStatus.complete;
    } else {
      challengeStatus = cloudCurrentChallenge.status;
    }

    return cloudCurrentChallenge.copyWith(
      currentUserSetsUpdatedAt: localCurrentChallenge.currentUserSetsUpdatedAt,
      status: challengeStatus,
      currentUserSets: localCurrentChallenge.currentUserSets,
      currentUser: localCurrentChallenge.currentUser,
    );
  }
}
