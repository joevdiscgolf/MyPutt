import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';
import 'package:mixpanel_flutter/mixpanel_flutter.dart';
import 'package:myputt/locator.dart';
import 'package:myputt/models/data/challenges/putting_challenge.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myputt/screens/challenge/components/challenge_list_row.dart';
import 'package:myputt/utils/calculators.dart';
import 'package:myputt/utils/colors.dart';
import 'package:myputt/utils/constants.dart';
import 'package:myputt/utils/enums.dart';
import 'package:myputt/cubits/challenges_cubit.dart';
import 'package:myputt/screens/challenge/challenge_record/challenge_record_screen.dart';

class ChallengesList extends StatelessWidget {
  const ChallengesList(
      {Key? key, required this.category, required this.challenges})
      : super(key: key);

  final ChallengeCategory category;
  final List<PuttingChallenge> challenges;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      child: CustomScrollView(
        slivers: [
          CupertinoSliverRefreshControl(
            onRefresh: () async {
              Vibrate.feedback(FeedbackType.light);
              locator
                  .get<Mixpanel>()
                  .track('Challenges Screen Pull To Refresh');
              await BlocProvider.of<ChallengesCubit>(context).reload();
            },
          ),
          if (challenges.isEmpty)
            SliverFillRemaining(
              hasScrollBody: false,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    FlutterRemix.sword_fill,
                    color: MyPuttColors.blue,
                    size: 80,
                  ),
                  Text(
                    "No ${challengeCategoryToName[category] ?? ''} challenges yet.",
                    style: Theme.of(context)
                        .textTheme
                        .headline6
                        ?.copyWith(fontWeight: FontWeight.w600),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          if (challenges.isNotEmpty)
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (BuildContext context, int index) {
                  return Column(
                      children: challenges
                          .map(
                            (challenge) => Builder(builder: (context) {
                              if (category == ChallengeCategory.pending) {
                                return ChallengeListRow(
                                  difference: 0,
                                  currentUserPuttsMade: 0,
                                  currentUserPuttsAttempted: 0,
                                  opponentPuttsMade: 0,
                                  opponentPuttsAttempted: 0,
                                  activeChallenge: false,
                                  minLength: 0,
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
                                  challenge: challenge,
                                );
                              } else {
                                final int minLength = min(
                                  challenge.currentUserSets.length,
                                  challenge.opponentSets.length,
                                );
                                final bool activeChallenge =
                                    challenge.status == ChallengeStatus.active;
                                int currentUserPuttsMade = totalMadeFromSubset(
                                    challenge.currentUserSets, minLength);
                                final int currentUserPuttsAttempted =
                                    totalAttemptsFromSubset(
                                        challenge.currentUserSets, minLength);
                                final int opponentPuttsMade =
                                    totalMadeFromSubset(
                                        challenge.opponentSets, minLength);
                                final int opponentPuttsAttempted =
                                    totalAttemptsFromSubset(
                                        challenge.opponentSets, minLength);

                                final int difference =
                                    currentUserPuttsMade - opponentPuttsMade;
                                return ChallengeListRow(
                                  minLength: minLength,
                                  activeChallenge: activeChallenge,
                                  currentUserPuttsAttempted:
                                      currentUserPuttsAttempted,
                                  currentUserPuttsMade: currentUserPuttsMade,
                                  opponentPuttsAttempted:
                                      opponentPuttsAttempted,
                                  opponentPuttsMade: opponentPuttsMade,
                                  difference: difference,
                                  challenge: challenge,
                                );
                              }
                            }),
                          )
                          .toList());
                },
                childCount: 1,
              ),
            )
        ],
      ),
    );
  }
}
