import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:myputt/components/previous_sets_list.dart';
import 'package:myputt/data/types/challenges/putting_challenge.dart';

import '../../utils/calculators.dart';

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
            SummaryPanel(
              challenge: widget.challenge,
            ),
            TabBar(tabs: [
              Tab(
                child: Center(
                    child: Text(
                  widget.challenge.currentUser.displayName,
                  style: Theme.of(context).textTheme.headline6,
                )),
              ),
              Tab(
                child: Center(
                    child: Text(
                  widget.challenge.opponentUser.displayName,
                  style: Theme.of(context).textTheme.headline6,
                )),
              )
            ]),
            Expanded(
                child: TabBarView(children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          decoration:
                              BoxDecoration(border: Border.all(width: 2)),
                          child: Text(
                              '${totalMadeFromSets(widget.challenge.currentUserSets)}/${totalAttemptsFromSets(widget.challenge.currentUserSets)}'),
                        ),
                      ),
                    ],
                  ),
                  Expanded(
                    child: PreviousSetsList(
                        deletable: false,
                        deleteSet: () {},
                        sets: widget.challenge.currentUserSets,
                        static: true),
                  ),
                ],
              ),
              Column(children: [
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(border: Border.all(width: 2)),
                        child: Text(
                            '${totalMadeFromSets(widget.challenge.opponentSets)}/${totalAttemptsFromSets(widget.challenge.opponentSets)}'),
                      ),
                    ),
                  ],
                ),
                Expanded(
                  child: PreviousSetsList(
                      deletable: false,
                      deleteSet: () {},
                      sets: widget.challenge.opponentSets,
                      static: true),
                ),
              ]),
            ]))
          ],
        ),
      ),
    );
  }
}

class SummaryPanel extends StatelessWidget {
  const SummaryPanel({Key? key, required this.challenge}) : super(key: key);

  final PuttingChallenge challenge;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: const BoxDecoration(
              color: Colors.white,
            ),
            child: Column(children: [
              Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      '${DateFormat.yMMMMd('en_US').format(DateTime.fromMillisecondsSinceEpoch(challenge.creationTimeStamp))} ${DateFormat.jm().format(DateTime.fromMillisecondsSinceEpoch(challenge.creationTimeStamp))}',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                  ]),
              const SizedBox(height: 5),
            ]),
          ),
        ),
      ],
    );
  }
}
