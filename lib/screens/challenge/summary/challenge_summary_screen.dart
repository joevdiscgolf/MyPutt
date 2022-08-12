import 'package:flutter/material.dart';
import 'package:mixpanel_flutter/mixpanel_flutter.dart';
import 'package:myputt/locator.dart';
import 'package:myputt/models/data/challenges/putting_challenge.dart';
import 'package:myputt/screens/challenge/summary/challenge_info_panel.dart';
import 'package:myputt/utils/colors.dart';

import 'components/challenge_sets_list.dart';

class ChallengeSummaryScreen extends StatefulWidget {
  const ChallengeSummaryScreen({Key? key, required this.challenge})
      : super(key: key);

  final PuttingChallenge challenge;

  @override
  _ChallengeSummaryScreenState createState() => _ChallengeSummaryScreenState();
}

class _ChallengeSummaryScreenState extends State<ChallengeSummaryScreen> {
  final Mixpanel _mixpanel = locator.get<Mixpanel>();

  @override
  void initState() {
    super.initState();
    _mixpanel.track('Challenge Summary Screen Impression');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyPuttColors.white,
      body: Column(
        children: [
          ChallengeInfoPanel(challenge: widget.challenge),
          Expanded(
            child: ChallengeSetsList(
              challenge: widget.challenge,
            ),
          )
        ],
      ),
    );
  }
}
