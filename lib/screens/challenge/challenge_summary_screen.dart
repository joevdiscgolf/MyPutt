import 'package:flutter/material.dart';
import 'package:myputt/components/misc/previous_sets_list.dart';
import 'package:myputt/data/types/challenges/putting_challenge.dart';
import 'package:myputt/data/types/putting_set.dart';
import 'package:myputt/theme/theme_data.dart';
import 'package:myputt/utils/calculators.dart';
import 'package:myputt/utils/constants.dart';
import 'package:myputt/components/misc/default_profile_circle.dart';

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
      backgroundColor: Colors.grey[100]!,
      appBar: AppBar(
        title: const Text('Challenge summary'),
      ),
      body: DefaultTabController(
        length: 2,
        child: Column(
          children: [
            ChallengeTitlePanel(
              challenge: widget.challenge,
            ),
            _tabBar(context),
            Expanded(
                child: TabBarView(children: [
              Column(
                children: [
                  Expanded(
                    child: PreviousSetsList(
                        deletable: false,
                        deleteSet: () {},
                        sets: widget.challenge.currentUserSets,
                        static: true),
                  ),
                ],
              ),
              PreviousSetsList(
                  deletable: false,
                  deleteSet: () {},
                  sets: widget.challenge.opponentSets,
                  static: true),
            ]))
          ],
        ),
      ),
    );
  }

  Widget _tabBar(BuildContext context) {
    return TabBar(tabs: [
      Tab(
        child: Row(
          children: [
            const DefaultProfileCircle(),
            const SizedBox(width: 10),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  widget.challenge.currentUser.displayName.toUpperCase(),
                  style: Theme.of(context)
                      .textTheme
                      .headline6
                      ?.copyWith(color: ThemeColors.lightBlue),
                ),
                Text(
                  '${totalMadeFromSets(widget.challenge.currentUserSets)}/${totalAttemptsFromSets(widget.challenge.currentUserSets)}',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ],
            ),
          ],
        ),
      ),
      Tab(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  widget.challenge.opponentUser.displayName.toUpperCase(),
                  style: Theme.of(context)
                      .textTheme
                      .headline6
                      ?.copyWith(color: Colors.red),
                ),
                Text(
                  '${totalMadeFromSets(widget.challenge.opponentSets)}/${totalAttemptsFromSets(widget.challenge.opponentSets)}',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ],
            ),
            const SizedBox(width: 10),
            const DefaultProfileCircle(),
          ],
        ),
      )
    ]);
  }
}

class ChallengeSummaryStatsPanel extends StatelessWidget {
  const ChallengeSummaryStatsPanel({Key? key, required this.sets})
      : super(key: key);

  final List<PuttingSet> sets;

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class ChallengeTitlePanel extends StatelessWidget {
  const ChallengeTitlePanel({Key? key, required this.challenge})
      : super(key: key);

  final PuttingChallenge challenge;

  @override
  Widget build(BuildContext context) {
    final int currentUserPuttsMade =
        totalMadeFromSets(challenge.currentUserSets);
    final int opponentPuttsMade = totalMadeFromSets(challenge.opponentSets);
    String resultText;
    final int difference = totalMadeFromSets(challenge.currentUserSets) -
        totalMadeFromSets(challenge.opponentSets);
    Color borderColor;
    if (difference > 0) {
      resultText = "VICTORY";
      borderColor = ThemeColors.lightBlue;
    } else if (difference < 0) {
      resultText = "DEFEAT";
      borderColor = Colors.red;
    } else {
      resultText = "DRAW";
      borderColor = Colors.grey[600]!;
    }
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
          color: Colors.grey[200]!,
          border: Border.all(width: 2, color: borderColor)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Text(resultText,
                style: Theme.of(context).textTheme.headline5?.copyWith(
                    shadows: [
                      const Shadow(
                          color: Colors.black, offset: (Offset(0.3, 0.3))),
                      const Shadow(
                          color: Colors.black, offset: (Offset(-0.3, 0.3))),
                      const Shadow(
                          color: Colors.black, offset: (Offset(0.3, -0.3))),
                      const Shadow(
                          color: Colors.black, offset: (Offset(-0.3, -0.3)))
                    ],
                    color: difference == 0
                        ? Colors.white
                        : (difference > 0)
                            ? ThemeColors.lightBlue
                            : Colors.red)),
          ),
          Container(
            decoration: BoxDecoration(
                color: Colors.grey[900]!,
                borderRadius: BorderRadius.circular(5)),
            child: Row(
              children: [
                const SizedBox(
                    height: 24,
                    width: 24,
                    child: Image(image: blueFrisbeeIcon)),
                Text('$currentUserPuttsMade - $opponentPuttsMade',
                    style: Theme.of(context)
                        .textTheme
                        .headline6
                        ?.copyWith(color: Colors.white)),
                const SizedBox(
                    height: 24, width: 24, child: Image(image: redFrisbeeIcon))
              ],
            ),
          ),
          const Spacer()
        ],
      ),
    );
  }
}
