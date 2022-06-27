import 'package:flutter/material.dart';
import 'package:myputt/models/data/challenges/putting_challenge.dart';
import 'package:myputt/screens/challenge/components/challenge_set_row.dart';

class ChallengeSetsList extends StatelessWidget {
  const ChallengeSetsList({Key? key, required this.challenge})
      : super(key: key);

  final PuttingChallenge challenge;

  @override
  Widget build(BuildContext context) {
    return ListView(
        shrinkWrap: true,
        children: challenge.challengeStructure
            .asMap()
            .entries
            .map((entry) => ChallengeSetRow(
                  currentUserMade:
                      challenge.currentUserSets[entry.key].puttsMade.toInt(),
                  opponentMade:
                      challenge.opponentSets[entry.key].puttsMade.toInt(),
                  setLength: entry.value.setLength,
                  distance: entry.value.distance,
                ))
            .toList());
  }
}
