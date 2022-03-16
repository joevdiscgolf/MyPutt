import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';
import 'package:intl/intl.dart';
import 'package:myputt/components/buttons/my_putt_button.dart';
import 'package:myputt/data/types/challenges/putting_challenge.dart';
import 'package:myputt/screens/challenge/challenge_record/challenge_record_screen.dart';
import 'package:myputt/utils/colors.dart';
import 'package:myputt/utils/calculators.dart';
import 'package:myputt/utils/constants.dart';
import 'package:myputt/components/dialogs/confirm_dialog.dart';
import 'package:myputt/cubits/challenges_cubit.dart';
import 'package:myputt/screens/challenge/summary/challenge_summary_screen.dart';
import 'package:myputt/components/misc/frisbee_circle_icon.dart';
import 'package:myputt/utils/string_helpers.dart';

class ChallengeItem extends StatefulWidget {
  const ChallengeItem({
    Key? key,
    required this.challenge,
    this.accept,
    this.decline,
  }) : super(key: key);

  final PuttingChallenge challenge;
  final Function? accept;
  final Function? decline;

  @override
  _ChallengeItemState createState() => _ChallengeItemState();
}

class _ChallengeItemState extends State<ChallengeItem> {
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

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Bounceable(
        onTap: () {
          Vibrate.feedback(FeedbackType.light);
          if (widget.challenge.status == ChallengeStatus.active) {
            BlocProvider.of<ChallengesCubit>(context)
                .openChallenge(widget.challenge);
            Navigator.of(context).push(MaterialPageRoute(
                builder: (BuildContext context) =>
                    ChallengeRecordScreen(challengeId: widget.challenge.id)));
          } else if (widget.challenge.status == ChallengeStatus.complete) {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (BuildContext context) =>
                    ChallengeSummaryScreen(challenge: widget.challenge)));
          }
        },
        child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            decoration: BoxDecoration(
                color: MyPuttColors.gray[50],
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                      offset: const Offset(0, 2),
                      color: MyPuttColors.gray[400]!,
                      blurRadius: 2)
                ]),
            child: Column(
              children: [
                if (widget.challenge.status == ChallengeStatus.complete) ...[
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          getMessageFromDifference(difference),
                          style: Theme.of(context)
                              .textTheme
                              .headline6
                              ?.copyWith(
                                  fontSize: 20,
                                  color: getColorFromDifference(difference)),
                        ),
                        Text(
                          getMessageFromDifference(-difference),
                          style: Theme.of(context)
                              .textTheme
                              .headline6
                              ?.copyWith(
                                  fontSize: 20,
                                  color: getColorFromDifference(-difference)),
                        ),
                      ]),
                  const SizedBox(
                    height: 8,
                  )
                ],
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      flex: 1,
                      child: _profileColumn(
                          context,
                          widget.challenge.currentUser.displayName,
                          MyPuttColors.red),
                    ),
                    Flexible(
                        flex: 2,
                        child: _centerColumn(context, widget.challenge.status)),
                    Flexible(
                      flex: 1,
                      child: _profileColumn(
                          context,
                          widget.challenge.opponentUser?.displayName ??
                              'Unknown',
                          MyPuttColors.blue),
                    ),
                  ],
                ),
              ],
            )));
  }

  Widget _profileColumn(
    BuildContext context,
    String displayName,
    Color backgroundColor,
  ) {
    return Column(
      children: [
        Text(
          displayName,
          style: Theme.of(context)
              .textTheme
              .headline6
              ?.copyWith(fontSize: 16, color: MyPuttColors.gray[500]),
        ),
        const SizedBox(
          height: 8,
        ),
        FrisbeeCircleIcon(
          size: 72,
          backGroundColor: backgroundColor,
          redIcon: backgroundColor == MyPuttColors.blue,
        ),
      ],
    );
  }

  Widget _centerColumn(BuildContext context, String status) {
    switch (status) {
      case 'pending':
        return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              '${widget.challenge.challengeStructure.length} sets, ${totalAttemptsFromStructure(widget.challenge.challengeStructure)} putts',
              style: Theme.of(context)
                  .textTheme
                  .headline6
                  ?.copyWith(fontSize: 16, color: MyPuttColors.gray[800]),
            ),
            const SizedBox(
              height: 12,
            ),
            MyPuttButton(
              onPressed: () {
                if (widget.accept != null) {
                  widget.accept!();
                }
              },
              title: 'Accept',
              color: MyPuttColors.blue,
              height: 30,
              shadowColor: MyPuttColors.gray[400],
            ),
            const SizedBox(
              height: 12,
            ),
            MyPuttButton(
              onPressed: () {
                if (widget.decline != null) {
                  widget.decline!();
                }
              },
              title: 'Decline',
              color: MyPuttColors.red,
              height: 30,
              shadowColor: MyPuttColors.gray[400],
            ),
          ],
        );
      default:
        return Column(
          children: [
            Text(
              '${DateFormat.yMMMMd('en_US').format(DateTime.fromMillisecondsSinceEpoch(widget.challenge.creationTimeStamp))}, ${DateFormat.jm().format(DateTime.fromMillisecondsSinceEpoch(widget.challenge.creationTimeStamp))}',
              style: Theme.of(context)
                  .textTheme
                  .headline6
                  ?.copyWith(fontSize: 12, color: MyPuttColors.gray[400]),
            ),
            const SizedBox(
              height: 8,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(currentUserPuttsMade.toString(),
                    style: Theme.of(context)
                        .textTheme
                        .headline6
                        ?.copyWith(fontSize: 20, color: MyPuttColors.blue)),
                Text(' : ',
                    style: Theme.of(context).textTheme.headline6?.copyWith(
                        fontSize: 20, color: MyPuttColors.gray[400])),
                Text(opponentPuttsMade.toString(),
                    style: Theme.of(context)
                        .textTheme
                        .headline6
                        ?.copyWith(fontSize: 20, color: MyPuttColors.red))
              ],
            ),
          ],
        );
    }
  }
}
//
// class BasicChallengeItem extends StatefulWidget {
//   const BasicChallengeItem({Key? key, required this.challenge})
//       : super(key: key);
//
//   final PuttingChallenge challenge;
//
//   @override
//   State<BasicChallengeItem> createState() => _BasicChallengeItemState();
// }
//
// class _BasicChallengeItemState extends State<BasicChallengeItem> {
//   late final int difference;
//   late final String titleText;
//   late final int currentUserPuttsMade;
//   late final int currentUserPuttsAttempted;
//   late final int opponentPuttsMade;
//   late final int opponentPuttsAttempted;
//   late final Color color;
//   late final bool activeChallenge;
//
//   @override
//   void initState() {
//     activeChallenge = widget.challenge.status == ChallengeStatus.active;
//     final int minLength = min(
//       widget.challenge.currentUserSets.length,
//       widget.challenge.opponentSets.length,
//     );
//     currentUserPuttsMade =
//         totalMadeFromSubset(widget.challenge.currentUserSets, minLength);
//     currentUserPuttsAttempted =
//         totalAttemptsFromSubset(widget.challenge.currentUserSets, minLength);
//     opponentPuttsMade =
//         totalMadeFromSubset(widget.challenge.opponentSets, minLength);
//     opponentPuttsAttempted =
//         totalAttemptsFromSubset(widget.challenge.opponentSets, minLength);
//
//     difference = currentUserPuttsMade - opponentPuttsMade;
//     titleText = activeChallenge ? 'Active' : getTitleFromDifference(difference);
//     color = activeChallenge
//         ? MyPuttColors.lightBlue
//         : getColorFromDifference(difference);
//
//     super.initState();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Bounceable(
//         onTap: () {
//           Vibrate.feedback(FeedbackType.light);
//           if (activeChallenge) {
//             BlocProvider.of<ChallengesCubit>(context)
//                 .openChallenge(widget.challenge);
//             Navigator.of(context).push(MaterialPageRoute(
//                 builder: (BuildContext context) =>
//                     ChallengeRecordScreen(challengeId: widget.challenge.id)));
//           } else {
//             Navigator.of(context).push(MaterialPageRoute(
//                 builder: (BuildContext context) =>
//                     ChallengeSummaryScreen(challenge: widget.challenge)));
//           }
//         },
//         child: Container(
//             margin: const EdgeInsets.all(4),
//             decoration: BoxDecoration(
//               color: MyPuttColors.gray[50],
//               borderRadius: BorderRadius.circular(16),
//             ),
//             child: Column(
//               children: [
//                 Container(
//                   padding: const EdgeInsets.all(8),
//                   decoration: BoxDecoration(
//                     color: MyPuttColors.white,
//                     borderRadius: BorderRadius.circular(5),
//                   ),
//                   child: Row(
//                     crossAxisAlignment: CrossAxisAlignment.center,
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Expanded(
//                         child: Text(titleText,
//                             style: Theme.of(context)
//                                 .textTheme
//                                 .headline5
//                                 ?.copyWith(color: color)),
//                       ),
//                       Row(
//                         children: [
//                           const SizedBox(
//                               height: 24,
//                               width: 24,
//                               child: Image(image: blueFrisbeeIcon)),
//                           Text('$currentUserPuttsMade  -  $opponentPuttsMade',
//                               style: Theme.of(context)
//                                   .textTheme
//                                   .headline6
//                                   ?.copyWith(color: MyPuttColors.gray[800])),
//                           const SizedBox(
//                               height: 24,
//                               width: 24,
//                               child: Image(image: redFrisbeeIcon))
//                         ],
//                       ),
//                       widget.challenge.status == ChallengeStatus.active
//                           ? Expanded(
//                               child: Row(
//                                 mainAxisAlignment: MainAxisAlignment.end,
//                                 children: const [
//                                   Icon(
//                                     FlutterRemix.play_fill,
//                                     color: MyPuttColors.lightBlue,
//                                   ),
//                                 ],
//                               ),
//                             )
//                           : const Spacer(),
//                     ],
//                   ),
//                 ),
//                 Container(
//                   padding: const EdgeInsets.all(8),
//                   decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(5),
//                     color: Colors.white,
//                   ),
//                   child: Column(
//                     children: [
//                       Row(children: [
//                         Expanded(
//                           child: Row(
//                             mainAxisAlignment: MainAxisAlignment.start,
//                             children: [
//                               const DefaultProfileCircle(),
//                               const SizedBox(width: 10),
//                               Column(
//                                 mainAxisAlignment: MainAxisAlignment.center,
//                                 children: [
//                                   AutoSizeText(
//                                     widget.challenge.currentUser.displayName,
//                                     style: Theme.of(context)
//                                         .textTheme
//                                         .headline6
//                                         ?.copyWith(
//                                             color: MyPuttColors.lightBlue),
//                                     maxLines: 1,
//                                   ),
//                                   Text(
//                                     '$currentUserPuttsMade/$currentUserPuttsAttempted',
//                                     style:
//                                         Theme.of(context).textTheme.bodyLarge,
//                                   ),
//                                 ],
//                               ),
//                             ],
//                           ),
//                         ),
//                         Expanded(
//                           child: Row(
//                             mainAxisAlignment: MainAxisAlignment.end,
//                             children: [
//                               Column(
//                                   crossAxisAlignment: CrossAxisAlignment.center,
//                                   mainAxisAlignment: MainAxisAlignment.center,
//                                   children: [
//                                     AutoSizeText(
//                                       (widget.challenge.opponentUser
//                                               ?.displayName ??
//                                           'Unknown'),
//                                       style: Theme.of(context)
//                                           .textTheme
//                                           .headline6
//                                           ?.copyWith(color: Colors.red),
//                                       maxLines: 1,
//                                     ),
//                                     Text(
//                                       '$opponentPuttsMade/$opponentPuttsAttempted',
//                                       style:
//                                           Theme.of(context).textTheme.bodyLarge,
//                                     )
//                                   ]),
//                               const SizedBox(
//                                 width: 10,
//                               ),
//                               const DefaultProfileCircle(),
//                             ],
//                           ),
//                         ),
//                       ]),
//                       const SizedBox(height: 10),
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.start,
//                         children: [
//                           Text(
//                               '${DateFormat.yMMMMd('en_US').format(DateTime.fromMillisecondsSinceEpoch(widget.challenge.creationTimeStamp))}, ${DateFormat.jm().format(DateTime.fromMillisecondsSinceEpoch(widget.challenge.creationTimeStamp))}',
//                               style: Theme.of(context)
//                                   .textTheme
//                                   .bodyLarge
//                                   ?.copyWith(fontWeight: FontWeight.w600)),
//                           const Spacer(),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             )));
//   }
//
//   String getTitleFromDifference(int puttsMadeDifference) {
//     if (puttsMadeDifference == 0) {
//       return 'Draw';
//     } else if (puttsMadeDifference > 0) {
//       return 'Victory';
//     } else {
//       return 'Defeat';
//     }
//   }
//
//   Color getColorFromDifference(int puttsMadeDifference) {
//     if (puttsMadeDifference == 0) {
//       return MyPuttColors.lightBlue;
//     } else if (puttsMadeDifference > 0) {
//       return MyPuttColors.lightGreen;
//     } else {
//       return Colors.red;
//     }
//   }
// }

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
                            FrisbeeCircleIcon(
                              size: 16,
                              backGroundColor:
                                  MyPuttColors.red.withOpacity(0.2),
                            ),
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
                            FrisbeeCircleIcon(
                              size: 16,
                              backGroundColor:
                                  MyPuttColors.blue.withOpacity(0.2),
                              redIcon: true,
                            ),
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
