import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:intl/intl.dart';
import 'package:myputt/data/types/challenges/putting_challenge.dart';
import 'package:myputt/theme/theme_data.dart';
import 'package:myputt/utils/calculators.dart';

import '../../../components/confirm_dialog.dart';
import '../../../cubits/challenges_cubit.dart';
import '../challenge_record_screen.dart';
import '../challenge_summary_screen.dart';

class ActiveChallengeItem extends StatelessWidget {
  const ActiveChallengeItem(
      {Key? key, required this.challenge, required this.accept})
      : super(key: key);

  final PuttingChallenge challenge;
  final Function accept;

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.symmetric(vertical: 5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(width: 1, color: Colors.grey[400]!),
        ),
        padding: const EdgeInsets.all(8),
        child: Column(
          children: [
            IntrinsicHeight(
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                  const SizedBox(width: 10),
                  Flexible(
                    flex: 3,
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(challenge.opponentUser.displayName,
                              style: Theme.of(context).textTheme.bodySmall),
                          Text(
                              DateFormat.yMMMMd('en_US')
                                  .format(DateTime.fromMillisecondsSinceEpoch(
                                      challenge.creationTimeStamp))
                                  .toString(),
                              style: Theme.of(context).textTheme.bodySmall),
                          Text(
                              DateFormat.jm().format(
                                  DateTime.fromMillisecondsSinceEpoch(
                                      challenge.creationTimeStamp)),
                              style: Theme.of(context).textTheme.bodySmall),
                        ]),
                  ),
                  VerticalDivider(
                    thickness: 1,
                    color: Colors.grey[400]!,
                  ),
                  Flexible(
                    flex: 2,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('You'),
                        Text(
                            '${totalMadeFromSets(challenge.currentUserSets)}/${totalAttemptsFromSets(challenge.currentUserSets)}'),
                      ],
                    ),
                  ),
                  VerticalDivider(
                    thickness: 1,
                    color: Colors.grey[400]!,
                  ),
                  Flexible(
                    flex: 2,
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text('You'),
                          Text(
                            '${totalMadeFromSubset(challenge.opponentSets, challenge.currentUserSets.length)}/${totalAttemptsFromSubset(challenge.opponentSets, challenge.currentUserSets.length)}',
                          ),
                        ]),
                  ),
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          primary: Colors.transparent,
                          shadowColor: Colors.transparent),
                      onPressed: () {
                        BlocProvider.of<ChallengesCubit>(context)
                            .openChallenge(challenge);
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (BuildContext context) =>
                                BlocProvider.value(
                                    value: BlocProvider.of<ChallengesCubit>(
                                        context),
                                    child: const ChallengeRecordScreen())));
                      },
                      child: Center(
                        child: Icon(
                          FlutterRemix.play_mini_line,
                          color: ThemeColors.green,
                        ),
                      ))
                ])),
          ],
        ));
  }
}

class PendingChallengeItem extends StatelessWidget {
  const PendingChallengeItem(
      {Key? key, required this.challenge, required this.accept})
      : super(key: key);

  final PuttingChallenge challenge;
  final Function accept;

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.symmetric(vertical: 5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(width: 1, color: Colors.grey[400]!),
        ),
        padding: const EdgeInsets.all(8),
        child: IntrinsicHeight(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const SizedBox(width: 10),
              Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                Text(challenge.opponentUser.displayName,
                    style: Theme.of(context).textTheme.bodyLarge),
                Text(
                    DateFormat.yMMMMd('en_US')
                        .format(DateTime.fromMillisecondsSinceEpoch(
                            challenge.creationTimeStamp))
                        .toString(),
                    style: Theme.of(context).textTheme.bodyLarge),
                Text(
                    DateFormat.jm().format(DateTime.fromMillisecondsSinceEpoch(
                        challenge.creationTimeStamp)),
                    style: Theme.of(context).textTheme.bodyLarge),
              ]),
              VerticalDivider(
                thickness: 1,
                color: Colors.grey[400]!,
              ),
              Align(
                alignment: Alignment.centerRight,
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        primary: ThemeColors.green,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(48),
                        ),
                        enableFeedback: true),
                    onPressed: () {
                      accept();
                    },
                    child: const Center(
                      child: Text('Accept'),
                    )),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: Row(
                  children: [
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            primary: Colors.red,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(48),
                            ),
                            enableFeedback: true),
                        onPressed: () {
                          showDialog(
                              context: context,
                              builder: (context) => ConfirmDialog(
                                    title: 'Decline Challenge',
                                    actionPressed: () {
                                      BlocProvider.of<ChallengesCubit>(context)
                                          .declineChallenge(challenge);
                                    },
                                    confirmColor: Colors.red,
                                    buttonlabel: 'Decline',
                                  ));
                        },
                        child: const Center(child: Text('Decline'))),
                  ],
                ),
              )
            ],
          ),
        ));
  }
}

class CompletedChallengeItem extends StatelessWidget {
  const CompletedChallengeItem({Key? key, required this.challenge})
      : super(key: key);

  final PuttingChallenge challenge;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (BuildContext context) =>
                ChallengeSummaryScreen(challenge: challenge)));
      },
      child: Builder(builder: (context) {
        Color? color;
        if (totalMadeFromSets(challenge.currentUserSets) >
            totalMadeFromSets(challenge.opponentSets)) {
          color = Colors.green[100];
        } else if (totalMadeFromSets(challenge.currentUserSets) <
            totalMadeFromSets(challenge.opponentSets)) {
          color = Colors.red[100];
        } else {
          color = Colors.grey[200];
        }
        return Container(
            margin: const EdgeInsets.symmetric(vertical: 5),
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(width: 1, color: Colors.grey[400]!),
            ),
            padding: const EdgeInsets.all(8),
            child: IntrinsicHeight(
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                  const SizedBox(width: 10),
                  Flexible(
                    flex: 3,
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(challenge.opponentUser.displayName,
                              style: Theme.of(context).textTheme.bodySmall),
                          Text(
                              DateFormat.yMMMMd('en_US')
                                  .format(DateTime.fromMillisecondsSinceEpoch(
                                      challenge.creationTimeStamp))
                                  .toString(),
                              style: Theme.of(context).textTheme.bodySmall),
                          Text(
                              DateFormat.jm().format(
                                  DateTime.fromMillisecondsSinceEpoch(
                                      challenge.creationTimeStamp)),
                              style: Theme.of(context).textTheme.bodySmall),
                        ]),
                  ),
                  VerticalDivider(
                    thickness: 1,
                    color: Colors.grey[400]!,
                  ),
                  Flexible(
                    flex: 2,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('You'),
                        Text(
                            '${totalMadeFromSets(challenge.currentUserSets)}/${totalAttemptsFromSets(challenge.currentUserSets)}'),
                      ],
                    ),
                  ),
                  VerticalDivider(
                    thickness: 1,
                    color: Colors.grey[400]!,
                  ),
                  Flexible(
                    flex: 2,
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(challenge.opponentUser.displayName),
                          Text(
                              '${totalMadeFromSets(challenge.opponentSets)}/${totalAttemptsFromSets(challenge.opponentSets)}')
                        ]),
                  ),
                ])));
      }),
    );
  }
}
