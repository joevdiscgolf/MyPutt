import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:intl/intl.dart';
import 'package:myputt/components/misc/frisbee_circle_icon.dart';
import 'package:myputt/models/data/challenges/putting_challenge.dart';
import 'package:myputt/locator.dart';
import 'package:myputt/repositories/user_repository.dart';
import 'package:myputt/utils/colors.dart';
import 'package:myputt/utils/calculators.dart';
import 'package:myputt/utils/constants.dart';
import 'package:myputt/utils/string_helpers.dart';

class ChallengeInfoPanel extends StatefulWidget {
  const ChallengeInfoPanel({Key? key, required this.challenge})
      : super(key: key);

  final PuttingChallenge challenge;

  @override
  State<ChallengeInfoPanel> createState() => _ChallengeInfoPanelState();
}

class _ChallengeInfoPanelState extends State<ChallengeInfoPanel> {
  final UserRepository _userRepository = locator.get<UserRepository>();

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
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.only(top: 32),
          decoration: BoxDecoration(
            gradient: LinearGradient(
                transform: const GradientRotation(pi / 2),
                end: const Alignment(0, 0),
                colors: [
                  getColorFromDiff(difference),
                  MyPuttColors.white,
                ]),
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  IconButton(
                    color: Colors.transparent,
                    icon: const Icon(
                      FlutterRemix.arrow_left_s_line,
                      color: Colors.black,
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Flexible(
                      flex: 3,
                      child: Column(
                        children: [
                          Text(
                            getMessageFromDifference(difference),
                            style: Theme.of(context)
                                .textTheme
                                .headline6
                                ?.copyWith(
                                    fontSize: 40,
                                    color: getColorFromDifference(difference)),
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          Text(
                            '${widget.challenge.challengeStructure.length} sets, ${totalAttemptsFromStructure(widget.challenge.challengeStructure)} putts',
                            style: Theme.of(context)
                                .textTheme
                                .headline6
                                ?.copyWith(
                                    fontSize: 16,
                                    color: MyPuttColors.gray[600]),
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(currentUserPuttsMade.toString(),
                                  style: Theme.of(context)
                                      .textTheme
                                      .headline6
                                      ?.copyWith(
                                          fontSize: 20,
                                          color: difference == 0
                                              ? MyPuttColors.darkGray
                                              : MyPuttColors.blue)),
                              const SizedBox(
                                width: 16,
                              ),
                              Text(' : ',
                                  style: Theme.of(context)
                                      .textTheme
                                      .headline6
                                      ?.copyWith(
                                          fontSize: 20,
                                          color: MyPuttColors.gray[400])),
                              const SizedBox(
                                width: 16,
                              ),
                              Text(opponentPuttsMade.toString(),
                                  style: Theme.of(context)
                                      .textTheme
                                      .headline6
                                      ?.copyWith(
                                          fontSize: 20,
                                          color: difference == 0
                                              ? MyPuttColors.gray[400]!
                                              : MyPuttColors.red))
                            ],
                          ),
                        ],
                      ),
                    ),
                    Flexible(
                      flex: 2,
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: _getTrophyFromDifference(context, difference),
                      ),
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        FrisbeeCircleIcon(
                            size: 60,
                            frisbeeAvatar:
                                _userRepository.currentUser?.frisbeeAvatar),
                        const SizedBox(
                          width: 8,
                        ),
                        Text(
                          widget.challenge.currentUser.displayName,
                          style: Theme.of(context)
                              .textTheme
                              .headline6
                              ?.copyWith(
                                  fontSize: 16, color: MyPuttColors.gray[600]),
                        )
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          widget.challenge.opponentUser?.displayName ??
                              'Unknown',
                          style: Theme.of(context)
                              .textTheme
                              .headline6
                              ?.copyWith(
                                  fontSize: 16, color: MyPuttColors.gray[600]),
                        ),
                        const SizedBox(
                          width: 8,
                        ),
                        FrisbeeCircleIcon(
                            size: 60,
                            frisbeeAvatar:
                                widget.challenge.opponentUser?.frisbeeAvatar)
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(color: MyPuttColors.gray[100]!, boxShadow: [
            BoxShadow(
                offset: const Offset(0, 2),
                color: MyPuttColors.gray[400]!,
                blurRadius: 2)
          ]),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Text(
                  '${DateFormat.yMMMMd('en_US').format(DateTime.fromMillisecondsSinceEpoch(widget.challenge.completionTimeStamp ?? widget.challenge.creationTimeStamp))}, ${DateFormat.jm().format(DateTime.fromMillisecondsSinceEpoch(widget.challenge.completionTimeStamp ?? widget.challenge.creationTimeStamp))}',
                  style: Theme.of(context)
                      .textTheme
                      .headline6
                      ?.copyWith(fontSize: 20, color: MyPuttColors.darkGray),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Color getColorFromDiff(int diff) {
    if (diff > 0) {
      return MyPuttColors.blue;
    } else if (diff < 0) {
      return MyPuttColors.red;
    } else {
      return MyPuttColors.gray[500]!;
    }
  }

  Widget _getTrophyFromDifference(BuildContext context, int difference) {
    if (difference > 0) {
      return const Icon(
        FlutterRemix.trophy_fill,
        color: MyPuttColors.blue,
        size: 100,
      );
    } else if (difference < 0) {
      return Transform.rotate(
          angle: 1.3,
          child: const Icon(
            FlutterRemix.trophy_fill,
            color: MyPuttColors.darkRed,
            size: 100,
          ));
    } else {
      return Icon(
        FlutterRemix.trophy_fill,
        color: MyPuttColors.gray[400],
        size: 100,
      );
    }
  }
}
