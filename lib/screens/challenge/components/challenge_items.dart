import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:intl/intl.dart';
import 'package:myputt/data/types/challenges/putting_challenge.dart';
import 'package:myputt/theme/theme_data.dart';
import 'package:myputt/utils/calculators.dart';
import 'package:myputt/utils/constants.dart';
import 'package:myputt/components/dialogs/confirm_dialog.dart';
import 'package:myputt/cubits/challenges_cubit.dart';
import 'package:myputt/screens/challenge/challenge_record_screen.dart';
import 'package:myputt/screens/challenge/challenge_summary_screen.dart';

class ActiveChallengeItem extends StatelessWidget {
  const ActiveChallengeItem(
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
          border: Border.all(width: 1, color: Colors.grey[300]!),
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
                          ? ThemeColors.lightBlue
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
                                                ? ThemeColors.lightBlue
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
                                      challenge.currentUser.displayName
                                          .toUpperCase(),
                                      style: Theme.of(context)
                                          .textTheme
                                          .headline6
                                          ?.copyWith(
                                              color: ThemeColors.lightBlue),
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
                                        challenge.opponentUser.displayName
                                            .toUpperCase(),
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

class NewActiveChallengeItem extends StatelessWidget {
  const NewActiveChallengeItem({Key? key, required this.challenge})
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
                child: const ChallengeRecordScreen())));
      },
      child: Builder(builder: (context) {
        final int currentUserPuttsMade =
            totalMadeFromSets(challenge.currentUserSets);
        final int opponentPuttsMade = totalMadeFromSubset(
            challenge.opponentSets, challenge.currentUserSets.length);
        return Container(
            margin: const EdgeInsets.all(5),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              border: Border.all(width: 1, color: ThemeColors.green),
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
                                ?.copyWith(color: ThemeColors.green)),
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
                          children: [
                            Icon(
                              FlutterRemix.play_fill,
                              color: ThemeColors.lightBlue,
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
                                      challenge.currentUser.displayName
                                          .toUpperCase(),
                                      style: Theme.of(context)
                                          .textTheme
                                          .headline6
                                          ?.copyWith(
                                              color: ThemeColors.lightBlue),
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
                                        challenge.opponentUser.displayName
                                            .toUpperCase(),
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline6
                                            ?.copyWith(color: Colors.red),
                                      ),
                                      Text(
                                          '${totalMadeFromSubset(challenge.opponentSets, challenge.currentUserSets.length)}/${totalAttemptsFromSubset(challenge.opponentSets, challenge.currentUserSets.length)}')
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

class NewPendingChallengeItem extends StatelessWidget {
  const NewPendingChallengeItem(
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
            border: Border.all(width: 1, color: ThemeColors.lightBlue),
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
                            ?.copyWith(color: ThemeColors.lightBlue)),
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
                color: Colors.white,
                padding: const EdgeInsets.all(8),
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(5)),
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
                              challenge.currentUser.displayName.toUpperCase(),
                              style: Theme.of(context)
                                  .textTheme
                                  .headline6
                                  ?.copyWith(color: ThemeColors.lightBlue),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              challenge.opponentUser.displayName.toUpperCase(),
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
