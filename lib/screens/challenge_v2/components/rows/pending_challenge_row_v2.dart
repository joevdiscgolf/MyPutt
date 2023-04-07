import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:intl/intl.dart';
import 'package:myputt/components/misc/frisbee_circle_icon.dart';
import 'package:myputt/cubits/challenges/challenges_cubit.dart';
import 'package:myputt/models/data/challenges/putting_challenge.dart';
import 'package:myputt/screens/challenge/challenge_record/challenge_record_screen.dart';
import 'package:myputt/utils/colors.dart';
import 'package:myputt/utils/layout_helpers.dart';

class PendingChallengeRowV2 extends StatelessWidget {
  const PendingChallengeRowV2({Key? key, required this.challenge})
      : super(key: key);

  final PuttingChallenge challenge;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      color: MyPuttColors.white,
      child: Bounceable(
        onTap: () {},
        child: Stack(
          children: [
            Container(
              padding: const EdgeInsets.only(left: 24, top: 24),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                boxShadow: standardBoxShadow(),
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: const AssetImage(
                    'assets/images/winthrop_hole_6_putt.JPG',
                  ),
                  colorFilter: ColorFilter.mode(
                    MyPuttColors.gray[700]!.withOpacity(0.9),
                    BlendMode.srcOver,
                  ),
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.only(right: 24),
                    alignment: Alignment.topRight,
                    child: _acceptButton(context),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 24),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(
                                '${challenge.opponentUser?.displayName}',
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium
                                    ?.copyWith(
                                      color: MyPuttColors.white,
                                      fontWeight: FontWeight.w500,
                                    ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                DateFormat.yMMMd('en_us').format(
                                    (DateTime.fromMillisecondsSinceEpoch(
                                        challenge.creationTimeStamp))),
                                style: Theme.of(context)
                                    .textTheme
                                    .titleSmall
                                    ?.copyWith(color: MyPuttColors.white),
                              )
                            ],
                          ),
                        ),
                      ),
                      _declineButton(context),
                    ],
                  ),
                ],
              ),
            ),
            Transform.translate(
              offset: const Offset(24, -12),
              child: Align(
                alignment: Alignment.topLeft,
                child: FrisbeeCircleIcon(
                  frisbeeAvatar: challenge.opponentUser?.frisbeeAvatar,
                  size: 52,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _acceptButton(BuildContext context) {
    return Bounceable(
      onTap: () {
        BlocProvider.of<ChallengesCubit>(context).openChallenge(challenge);
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (BuildContext context) => BlocProvider.value(
              value: BlocProvider.of<ChallengesCubit>(context),
              child: ChallengeRecordScreen(challenge: challenge),
            ),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: MyPuttColors.blue,
          borderRadius: BorderRadius.circular(40),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 8),
        child: Text(
          'Accept',
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                color: MyPuttColors.white,
                fontWeight: FontWeight.w600,
              ),
        ),
      ),
    );
  }

  Widget _declineButton(BuildContext context) {
    return Bounceable(
      onTap: () {
        BlocProvider.of<ChallengesCubit>(context).declineChallenge(challenge);
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(40),
        ),
        padding:
            const EdgeInsets.only(bottom: 24, right: 24, top: 16, left: 16),
        child: Text(
          'Decline',
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                color: MyPuttColors.white,
                decoration: TextDecoration.underline,
              ),
        ),
      ),
    );
  }
}
/*
  accept: () {
                                    locator.get<Mixpanel>().track(
                                          'Challenges Screen Pending Challenge Accepted',
                                        );
                                    BlocProvider.of<ChallengesCubit>(
                                      context,
                                    ).openChallenge(challenge);
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (BuildContext context) =>
                                            BlocProvider.value(
                                          value:
                                              BlocProvider.of<ChallengesCubit>(
                                                  context),
                                          child: ChallengeRecordScreen(
                                            challenge: challenge,
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                  decline: () {
                                    locator.get<Mixpanel>().track(
                                          'Challenges Screen Pending Challenge Declined',
                                        );
                                    BlocProvider.of<ChallengesCubit>(context)
                                        .declineChallenge(challenge);
                                  },
 */
