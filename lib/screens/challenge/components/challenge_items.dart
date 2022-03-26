import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';
import 'package:intl/intl.dart';
import 'package:myputt/components/buttons/my_putt_button.dart';
import 'package:myputt/data/types/challenges/putting_challenge.dart';
import 'package:myputt/data/types/users/frisbee_avatar.dart';
import 'package:myputt/locator.dart';
import 'package:myputt/repositories/user_repository.dart';
import 'package:myputt/screens/challenge/challenge_record/challenge_record_screen.dart';
import 'package:myputt/utils/colors.dart';
import 'package:myputt/utils/calculators.dart';
import 'package:myputt/utils/constants.dart';
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
                          _userRepository.currentUser?.frisbeeAvatar),
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
                          widget.challenge.opponentUser?.frisbeeAvatar),
                    ),
                  ],
                ),
              ],
            )));
  }

  Widget _profileColumn(
    BuildContext context,
    String displayName,
    FrisbeeAvatar? frisbeeAvatar,
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
          frisbeeAvatar: frisbeeAvatar,
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
              padding: const EdgeInsets.symmetric(horizontal: 8),
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
              padding: const EdgeInsets.symmetric(horizontal: 8),
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
