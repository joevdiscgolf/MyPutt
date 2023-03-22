import 'package:myputt/models/data/challenges/challenge_structure_item.dart';
import 'package:myputt/models/data/challenges/generated_challenge_item.dart';
import 'package:myputt/models/data/challenges/putting_challenge.dart';
import 'package:myputt/models/data/sessions/putting_session.dart';
import 'package:collection/collection.dart';
import 'package:myputt/utils/calculators.dart';
import 'package:myputt/utils/constants.dart';
import 'package:myputt/utils/enums.dart';

class ChallengeHelpers {
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
      List<GeneratedChallengeInstruction> instructions) {
    List<ChallengeStructureItem> items = [];
    for (var instruction in instructions) {
      items = [
        for (var i = 0; i < instruction.setCount; i++)
          ChallengeStructureItem(
              distance: instruction.distance, setLength: instruction.setLength)
      ];
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

  static List<PuttingChallenge> updatedActiveChallenges(
    List<PuttingChallenge> localChallenges,
    List<PuttingChallenge> cloudChallenges,
  ) {
    final List<String> cloudActiveChallengeIds = cloudChallenges
        .where((challenge) => challenge.status == ChallengeStatus.active)
        .map((challenge) => challenge.id)
        .toList();

    final List<PuttingChallenge> localIntersectionChallenges = localChallenges
        .where((challenge) => cloudActiveChallengeIds.contains(challenge.id))
        .toList();

    final List<String> intersectionChallengeIds =
        localIntersectionChallenges.map((challenge) => challenge.id).toList();

    final List<PuttingChallenge> cloudIntersectionChallenges = cloudChallenges
        .where((challenge) => intersectionChallengeIds.contains(challenge.id))
        .toList();

    return localIntersectionChallenges.where((localIntersectingChallenge) {
      return !ChallengeHelpers.challengeSetsUpdated(
        localIntersectingChallenge,
        localIntersectingChallenge,
      );
    }).toList();
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
    List<PuttingChallenge> localChallenges,
    List<PuttingChallenge> cloudChallenges,
  ) {
    final List<String> localChallengeIds =
        localChallenges.map((challenge) => challenge.id).toList();

    // include the local unsynced challenges
    // include cloud challenges if the cloud challenge is not stored locally and the device Id does not match
    // if the device id does match, that means the challenge has been deleted locally but not in the cloud yet
    return [
      ...localChallenges,
      ...cloudChallenges.where(
        (cloudChallenge) => !localChallengeIds.contains(cloudChallenge.id),
      )
    ];
  }

  static List<PuttingChallenge> getNewChallenges(
    List<PuttingChallenge> localChallenges,
    List<PuttingChallenge> cloudChallenges,
  ) {
    final List<String> localChallengeIds = List.from(
      localChallenges.map((challenge) => challenge.id),
    );

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

    final List<PuttingChallenge> syncedLocalChallenges = localChallenges
        .where((localChallenge) => localChallenge.isSynced == true)
        .toList();

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
}
