import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:intl/intl.dart';
import 'package:myputt/data/types/putting_challenge.dart';
import 'package:myputt/theme/theme_data.dart';

import '../../../components/confirm_dialog.dart';
import '../../../cubits/challenges_cubit.dart';
import '../challenge_record_screen.dart';

class ActiveChallengeItem extends StatelessWidget {
  const ActiveChallengeItem(
      {Key? key, required this.challenge, required this.accept})
      : super(key: key);

  final PuttingChallenge challenge;
  final Function accept;

  @override
  Widget build(BuildContext context) {
    return Container(
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
                          Text(challenge.challengerUid,
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
                      children: const [
                        Text('You'),
                        Text('55/100'),
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
                          Text(challenge.challengerUid),
                          const Text('22/100'),
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
                Text(challenge.challengerUid,
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
  const CompletedChallengeItem(
      {Key? key, required this.challenge, required this.onTap})
      : super(key: key);

  final PuttingChallenge challenge;
  final Function onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap(),
      child: Container(
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
                            Text(challenge.challengerUid,
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
                        children: const [
                          Text('You'),
                          Text('55/100'),
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
                            Text(challenge.challengerUid),
                            const Text('22/100'),
                          ]),
                    ),
                  ])),
            ],
          )),
    );
  }
}
