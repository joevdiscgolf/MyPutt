import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:intl/intl.dart';
import 'package:myputt/data/types/challenges/putting_challenge.dart';
import 'package:myputt/utils/colors.dart';
import 'package:myputt/utils/calculators.dart';
import 'package:myputt/utils/constants.dart';
import 'package:myputt/components/dialogs/confirm_dialog.dart';
import 'package:myputt/cubits/challenges_cubit.dart';
import 'package:myputt/screens/challenge/challenge_record/challenge_record_screen.dart';
import 'package:myputt/screens/challenge/summary/challenge_summary_screen.dart';
import 'package:myputt/components/misc/default_profile_circle.dart';

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
        final int currentUserPuttsMade =
            totalMadeFromSets(challenge.currentUserSets);
        final int opponentPuttsMade = totalMadeFromSets(challenge.opponentSets);
        String resultText;
        final int difference = totalMadeFromSets(challenge.currentUserSets) -
            totalMadeFromSets(challenge.opponentSets);
        if (difference > 0) {
          resultText = "VICTORY";
        } else if (difference < 0) {
          resultText = "DEFEAT";
        } else {
          resultText = "DRAW";
        }
        return Container(
            margin: const EdgeInsets.all(5),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              border: Border.all(
                  width: 1,
                  color: difference == 0
                      ? Colors.white
                      : (difference > 0)
                          ? MyPuttColors.lightBlue
                          : Colors.red),
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
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Builder(builder: (context) {
                          if (resultText == 'DRAW') {
                            return Text(resultText,
                                style: Theme.of(context)
                                    .textTheme
                                    .headline5
                                    ?.copyWith(
                                  color: Colors.white,
                                  shadows: [
                                    const Shadow(
                                        color: Colors.black,
                                        offset: (Offset(0.3, 0.3))),
                                    const Shadow(
                                        color: Colors.black,
                                        offset: (Offset(-0.3, 0.3))),
                                    const Shadow(
                                        color: Colors.black,
                                        offset: (Offset(0.3, -0.3))),
                                    const Shadow(
                                        color: Colors.black,
                                        offset: (Offset(-0.3, -0.3)))
                                  ],
                                ));
                          } else {
                            return Text(resultText,
                                style: Theme.of(context)
                                    .textTheme
                                    .headline5
                                    ?.copyWith(
                                        color: difference == 0
                                            ? Colors.white
                                            : (difference > 0)
                                                ? MyPuttColors.lightBlue
                                                : Colors.red));
                          }
                        }),
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
                                height: 24,
                                width: 24,
                                child: Image(image: redFrisbeeIcon))
                          ],
                        ),
                      ),
                      const Spacer()
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: Colors.white,
                  ),
                  child: IntrinsicHeight(
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
                                    Text(
                                      challenge.currentUser.displayName,
                                      style: Theme.of(context)
                                          .textTheme
                                          .headline6
                                          ?.copyWith(
                                              color: MyPuttColors.lightBlue),
                                    ),
                                    Text(
                                        '${totalMadeFromSets(challenge.currentUserSets)}/${totalAttemptsFromSets(challenge.currentUserSets)}'),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          VerticalDivider(
                            color: Colors.grey[400]!,
                            thickness: 2,
                          ),
                          Expanded(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        challenge.opponentUser?.displayName ??
                                            'Unknown',
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline6
                                            ?.copyWith(color: Colors.red),
                                      ),
                                      Text(
                                          '${totalMadeFromSets(challenge.opponentSets)}/${totalAttemptsFromSets(challenge.opponentSets)}')
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
                                '${DateFormat.yMMMMd('en_US').format(DateTime.fromMillisecondsSinceEpoch(challenge.creationTimeStamp))}, ${DateFormat.jm().format(DateTime.fromMillisecondsSinceEpoch(challenge.creationTimeStamp))}',
                                style: Theme.of(context).textTheme.bodySmall),
                            const Spacer(),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            )));
      }),
    );
  }
}

class ActiveChallengeItem extends StatelessWidget {
  const ActiveChallengeItem({Key? key, required this.challenge})
      : super(key: key);

  final PuttingChallenge challenge;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        BlocProvider.of<ChallengesCubit>(context).openChallenge(challenge);
        Navigator.of(context).push(MaterialPageRoute(
            builder: (BuildContext context) => BlocProvider.value(
                value: BlocProvider.of<ChallengesCubit>(context),
                child: ChallengeRecordScreen(
                  challengeId: challenge.id,
                ))));
      },
      child: Builder(builder: (context) {
        final int currentUserPuttsMade =
            totalMadeFromSets(challenge.currentUserSets);
        final int opponentPuttsMade = totalMadeFromSets(challenge.opponentSets);
        return Container(
            margin: const EdgeInsets.all(5),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              border: Border.all(width: 1, color: MyPuttColors.lightGreen),
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
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Text('ACTIVE',
                            style: Theme.of(context)
                                .textTheme
                                .headline5
                                ?.copyWith(color: MyPuttColors.lightGreen)),
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
                            Text('$currentUserPuttsMade  -  $opponentPuttsMade',
                                style: Theme.of(context)
                                    .textTheme
                                    .headline6
                                    ?.copyWith(color: Colors.white)),
                            const SizedBox(
                                height: 24,
                                width: 24,
                                child: Image(image: redFrisbeeIcon))
                          ],
                        ),
                      ),
                      Expanded(
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
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: Colors.white,
                  ),
                  child: IntrinsicHeight(
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
                                    Text(
                                      challenge.currentUser.displayName,
                                      style: Theme.of(context)
                                          .textTheme
                                          .headline6
                                          ?.copyWith(
                                              color: MyPuttColors.lightBlue),
                                    ),
                                    Text(
                                        '${totalMadeFromSets(challenge.currentUserSets)}/${totalAttemptsFromSets(challenge.currentUserSets)}'),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          VerticalDivider(
                            color: Colors.grey[400]!,
                            thickness: 2,
                          ),
                          Expanded(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        (challenge.opponentUser?.displayName ??
                                            'Unknown'),
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline6
                                            ?.copyWith(color: Colors.red),
                                      ),
                                      Text(
                                          '${totalMadeFromSets(challenge.opponentSets)}/${totalAttemptsFromSets(challenge.opponentSets)}')
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
                                '${DateFormat.yMMMMd('en_US').format(DateTime.fromMillisecondsSinceEpoch(challenge.creationTimeStamp))}, ${DateFormat.jm().format(DateTime.fromMillisecondsSinceEpoch(challenge.creationTimeStamp))}',
                                style: Theme.of(context).textTheme.bodySmall),
                            const Spacer(),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            )));
      }),
    );
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
