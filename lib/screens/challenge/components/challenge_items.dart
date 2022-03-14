import 'dart:math';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';
import 'package:intl/intl.dart';
import 'package:myputt/data/types/challenges/putting_challenge.dart';
import 'package:myputt/screens/challenge/challenge_record/challenge_record_screen.dart';
import 'package:myputt/utils/colors.dart';
import 'package:myputt/utils/calculators.dart';
import 'package:myputt/utils/constants.dart';
import 'package:myputt/components/dialogs/confirm_dialog.dart';
import 'package:myputt/cubits/challenges_cubit.dart';
import 'package:myputt/screens/challenge/summary/challenge_summary_screen.dart';
import 'package:myputt/components/misc/default_profile_circle.dart';

class BasicChallengeItem extends StatefulWidget {
  const BasicChallengeItem({Key? key, required this.challenge})
      : super(key: key);

  final PuttingChallenge challenge;

  @override
  State<BasicChallengeItem> createState() => _BasicChallengeItemState();
}

class _BasicChallengeItemState extends State<BasicChallengeItem> {
  late final int difference;
  late final String titleText;
  late final int currentUserPuttsMade;
  late final int currentUserPuttsAttempted;
  late final int opponentPuttsMade;
  late final int opponentPuttsAttempted;
  late final Color color;
  late final bool activeChallenge;

  @override
  void initState() {
    activeChallenge = widget.challenge.status == ChallengeStatus.active;
    final int minLength = min(
      widget.challenge.currentUserSets.length,
      widget.challenge.opponentSets.length,
    );
    currentUserPuttsMade =
        totalMadeFromSubset(widget.challenge.currentUserSets, minLength);
    currentUserPuttsAttempted =
        totalAttemptsFromSubset(widget.challenge.currentUserSets, minLength);
    opponentPuttsMade =
        totalMadeFromSubset(widget.challenge.opponentSets, minLength);
    opponentPuttsAttempted =
        totalAttemptsFromSubset(widget.challenge.opponentSets, minLength);

    difference = currentUserPuttsMade - opponentPuttsMade;
    titleText = activeChallenge ? 'Active' : getTitleFromDifference(difference);
    color = activeChallenge
        ? MyPuttColors.lightBlue
        : getColorFromDifference(difference);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Bounceable(
        onTap: () {
          Vibrate.feedback(FeedbackType.light);
          if (activeChallenge) {
            BlocProvider.of<ChallengesCubit>(context)
                .openChallenge(widget.challenge);
            Navigator.of(context).push(MaterialPageRoute(
                builder: (BuildContext context) =>
                    ChallengeRecordScreen(challengeId: widget.challenge.id)));
          } else {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (BuildContext context) =>
                    ChallengeSummaryScreen(challenge: widget.challenge)));
          }
        },
        child: Container(
            margin: const EdgeInsets.all(5),
            decoration: BoxDecoration(
              color: MyPuttColors.white,
              borderRadius: BorderRadius.circular(5),
              border: Border.all(width: 1, color: color),
            ),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: MyPuttColors.white,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Text(titleText,
                            style: Theme.of(context)
                                .textTheme
                                .headline5
                                ?.copyWith(color: color)),
                      ),
                      Row(
                        children: [
                          const SizedBox(
                              height: 24,
                              width: 24,
                              child: Image(image: blueFrisbeeIcon)),
                          Text('$currentUserPuttsMade  -  $opponentPuttsMade',
                              style: Theme.of(context)
                                  .textTheme
                                  .headline6
                                  ?.copyWith(color: MyPuttColors.gray[800])),
                          const SizedBox(
                              height: 24,
                              width: 24,
                              child: Image(image: redFrisbeeIcon))
                        ],
                      ),
                      widget.challenge.status == ChallengeStatus.active
                          ? Expanded(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: const [
                                  Icon(
                                    FlutterRemix.play_fill,
                                    color: MyPuttColors.lightBlue,
                                  ),
                                ],
                              ),
                            )
                          : const Spacer(),
                    ],
                  ),
                ),
                Divider(
                  color: MyPuttColors.gray[100],
                  thickness: 2,
                  height: 4,
                ),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: Colors.white,
                  ),
                  child: Column(
                    children: [
                      Row(children: [
                        Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              const DefaultProfileCircle(),
                              const SizedBox(width: 10),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  AutoSizeText(
                                    widget.challenge.currentUser.displayName,
                                    style: Theme.of(context)
                                        .textTheme
                                        .headline6
                                        ?.copyWith(
                                            color: MyPuttColors.lightBlue),
                                    maxLines: 1,
                                  ),
                                  Text(
                                    '$currentUserPuttsMade/$currentUserPuttsAttempted',
                                    style:
                                        Theme.of(context).textTheme.bodyLarge,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    AutoSizeText(
                                      (widget.challenge.opponentUser
                                              ?.displayName ??
                                          'Unknown'),
                                      style: Theme.of(context)
                                          .textTheme
                                          .headline6
                                          ?.copyWith(color: Colors.red),
                                      maxLines: 1,
                                    ),
                                    Text(
                                      '$opponentPuttsMade/$opponentPuttsAttempted',
                                      style:
                                          Theme.of(context).textTheme.bodyLarge,
                                    )
                                  ]),
                              const SizedBox(
                                width: 10,
                              ),
                              const DefaultProfileCircle(),
                            ],
                          ),
                        ),
                      ]),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                              '${DateFormat.yMMMMd('en_US').format(DateTime.fromMillisecondsSinceEpoch(widget.challenge.creationTimeStamp))}, ${DateFormat.jm().format(DateTime.fromMillisecondsSinceEpoch(widget.challenge.creationTimeStamp))}',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge
                                  ?.copyWith(fontWeight: FontWeight.w600)),
                          const Spacer(),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            )));
  }

  String getTitleFromDifference(int puttsMadeDifference) {
    if (puttsMadeDifference == 0) {
      return 'Draw';
    } else if (puttsMadeDifference > 0) {
      return 'Victory';
    } else {
      return 'Defeat';
    }
  }

  Color getColorFromDifference(int puttsMadeDifference) {
    if (puttsMadeDifference == 0) {
      return MyPuttColors.lightBlue;
    } else if (puttsMadeDifference > 0) {
      return MyPuttColors.lightGreen;
    } else {
      return Colors.red;
    }
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
    return Builder(builder: (context) {
      return Container(
          margin: const EdgeInsets.all(5),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            border: Border.all(width: 1, color: MyPuttColors.lightBlue),
          ),
          child: IntrinsicHeight(
              child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Colors.grey[300]!,
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('PENDING',
                        style: Theme.of(context)
                            .textTheme
                            .headline5
                            ?.copyWith(color: MyPuttColors.lightBlue)),
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                          color: Colors.grey[900],
                          borderRadius: BorderRadius.circular(5)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('${challenge.opponentSets.length} Sets, ',
                              style: Theme.of(context)
                                  .textTheme
                                  .headline6
                                  ?.copyWith(color: Colors.white)),
                          Text(
                              '${totalAttemptsFromSets(challenge.opponentSets)} Putts',
                              style: Theme.of(context)
                                  .textTheme
                                  .headline6
                                  ?.copyWith(color: Colors.white)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(5)),
                child: IntrinsicHeight(
                  child: Column(children: [
                    Row(children: [
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            const DefaultProfileCircle(),
                            const SizedBox(width: 10),
                            Text(
                              challenge.currentUser.displayName,
                              style: Theme.of(context)
                                  .textTheme
                                  .headline6
                                  ?.copyWith(color: MyPuttColors.lightBlue),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              challenge.opponentUser?.displayName ?? 'Unknown',
                              style: Theme.of(context)
                                  .textTheme
                                  .headline6
                                  ?.copyWith(color: Colors.red),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            const DefaultProfileCircle(),
                          ],
                        ),
                      ),
                    ]),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        SizedBox(
                          height: 50,
                          child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  primary: MyPuttColors.lightGreen,
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
                        SizedBox(
                          height: 50,
                          child: ElevatedButton(
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
                                            BlocProvider.of<ChallengesCubit>(
                                                    context)
                                                .declineChallenge(challenge);
                                          },
                                          confirmColor: Colors.red,
                                          buttonlabel: 'Decline',
                                        ));
                              },
                              child: const Center(child: Text('Decline'))),
                        )
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                            '${DateFormat.yMMMMd('en_US').format(DateTime.fromMillisecondsSinceEpoch(challenge.creationTimeStamp))}, ${DateFormat.jm().format(DateTime.fromMillisecondsSinceEpoch(challenge.creationTimeStamp))}',
                            style: Theme.of(context).textTheme.bodySmall),
                        const Spacer(),
                      ],
                    ),
                  ]),
                ),
              )
            ],
          )));
    });
  }
}
