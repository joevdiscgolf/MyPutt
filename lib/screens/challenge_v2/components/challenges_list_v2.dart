import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';
import 'package:myputt/cubits/challenges_cubit.dart';
import 'package:myputt/models/data/challenges/putting_challenge.dart';
import 'package:myputt/screens/challenge_v2/components/rows/active_challenge_row_v2.dart';
import 'package:myputt/screens/challenge_v2/components/rows/completed_challenge_row_v2.dart';
import 'package:myputt/screens/challenge_v2/components/rows/pending_challenge_row_v2.dart';
import 'package:myputt/utils/colors.dart';
import 'package:myputt/utils/constants.dart';
import 'package:myputt/utils/enums.dart';
import 'package:myputt/utils/layout_helpers.dart';

class ChallengesListV2 extends StatelessWidget {
  const ChallengesListV2({
    Key? key,
    required this.challenges,
    required this.challengeCategory,
    this.verticalRunSpacing = 24,
  }) : super(key: key);

  final List<PuttingChallenge> challenges;
  final ChallengeCategory challengeCategory;
  final double verticalRunSpacing;

  @override
  Widget build(BuildContext context) {
    final List<Widget> spacedChallengeRows = [
      ...spacedChildren(
        challenges.map(
          (challenge) {
            switch (challengeCategory) {
              case ChallengeCategory.active:
                return ActiveChallengeRowV2(challenge: challenge);
              case ChallengeCategory.complete:
                return CompletedChallengeRowV2(challenge: challenge);
              case ChallengeCategory.pending:
                return PendingChallengeRowV2(challenge: challenge);
            }
          },
        ),
        axis: Axis.vertical,
        spacing: verticalRunSpacing,
      )
    ];
    return CustomScrollView(
      slivers: [
        CupertinoSliverRefreshControl(
          onRefresh: () async {
            Vibrate.feedback(FeedbackType.light);
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
                  "No ${challengeCategoryToName[challengeCategory] ?? ''} challenges yet.",
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge
                      ?.copyWith(fontWeight: FontWeight.w600),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        SliverPadding(
          padding: const EdgeInsets.symmetric(vertical: 32),
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                return spacedChallengeRows[index];
              },
              childCount: spacedChallengeRows.length,
            ),
          ),
        ),
      ],
    );
  }
}
