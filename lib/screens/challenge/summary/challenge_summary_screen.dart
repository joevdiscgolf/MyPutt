import 'package:flutter/material.dart';
import 'package:myputt/components/misc/previous_sets_list.dart';
import 'package:myputt/data/types/challenges/putting_challenge.dart';
import 'package:myputt/utils/colors.dart';
import 'package:myputt/utils/calculators.dart';
import 'package:myputt/components/misc/default_profile_circle.dart';
import 'summary_stats_panel.dart';

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
                      ?.copyWith(color: MyPuttColors.lightBlue),
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
                  widget.challenge.opponentUser?.displayName ??
                      'Unknown'.toUpperCase(),
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
