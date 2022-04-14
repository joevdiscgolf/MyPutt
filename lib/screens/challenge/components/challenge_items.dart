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

class ChallengeItem extends StatelessWidget {
  ChallengeItem({
    Key? key,
    required this.challenge,
    this.accept,
    this.decline,
    required this.minLength,
    required this.difference,
    required this.currentUserPuttsMade,
    required this.currentUserPuttsAttempted,
    required this.opponentPuttsMade,
    required this.opponentPuttsAttempted,
    required this.activeChallenge,
  }) : super(key: key);

  final UserRepository _userRepository = locator.get<UserRepository>();

  final PuttingChallenge challenge;
  final Function? accept;
  final Function? decline;

  final int minLength;
  final int difference;
  final int currentUserPuttsMade;
  final int currentUserPuttsAttempted;
  final int opponentPuttsMade;
  final int opponentPuttsAttempted;
  final bool activeChallenge;

  @override
  Widget build(BuildContext context) {
    return Bounceable(
        onTap: () {
          Vibrate.feedback(FeedbackType.light);
          if (challenge.status == ChallengeStatus.active) {
            BlocProvider.of<ChallengesCubit>(context).openChallenge(challenge);
            Navigator.of(context)
                .push(MaterialPageRoute(
                    builder: (BuildContext context) =>
                        ChallengeRecordScreen(challengeId: challenge.id)))
                .then(
                    (_) => BlocProvider.of<ChallengesCubit>(context).reload());
          } else if (challenge.status == ChallengeStatus.complete) {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (BuildContext context) =>
                    ChallengeSummaryScreen(challenge: challenge)));
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
                if (challenge.status == ChallengeStatus.complete) ...[
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
                          challenge.currentUser.displayName,
                          _userRepository.currentUser?.frisbeeAvatar),
                    ),
                    Flexible(
                        flex: 2,
                        child: _centerColumn(context, challenge.status)),
                    Flexible(
                      flex: 1,
                      child: _profileColumn(
                          context,
                          challenge.opponentUser?.displayName ?? 'Unknown',
                          challenge.opponentUser?.frisbeeAvatar),
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
              '${challenge.challengeStructure.length} sets, ${totalAttemptsFromStructure(challenge.challengeStructure)} putts',
              style: Theme.of(context)
                  .textTheme
                  .headline6
                  ?.copyWith(fontSize: 16, color: MyPuttColors.darkGray),
            ),
            const SizedBox(
              height: 12,
            ),
            MyPuttButton(
              onPressed: () {
                if (accept != null) {
                  accept!();
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
                if (decline != null) {
                  decline!();
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
              '${DateFormat.yMMMMd('en_US').format(DateTime.fromMillisecondsSinceEpoch(challenge.creationTimeStamp))}, ${DateFormat.jm().format(DateTime.fromMillisecondsSinceEpoch(challenge.creationTimeStamp))}',
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
