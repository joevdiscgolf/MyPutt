import 'package:flutter/material.dart';
import 'package:myputt/data/types/challenges/putting_challenge.dart';
import 'package:myputt/screens/challenge/components/challenge_set_row.dart';
import 'package:myputt/screens/challenge/summary/challenge_info_panel.dart';
import 'package:myputt/utils/colors.dart';

class ChallengeSummaryScreen extends StatefulWidget {
  const ChallengeSummaryScreen({Key? key, required this.challenge})
      : super(key: key);

  final PuttingChallenge challenge;

  @override
  _ChallengeSummaryScreenState createState() => _ChallengeSummaryScreenState();
}

class _ChallengeSummaryScreenState extends State<ChallengeSummaryScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyPuttColors.white,
      body: DefaultTabController(
        length: 2,
        child: Column(
          children: [
            ChallengeInfoPanel(
              challenge: widget.challenge,
            ),
            Expanded(
              child: ChallengeSetsList(
                challenge: widget.challenge,
              ),
            )
          ],
        ),
      ),
    );
  }
}

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
