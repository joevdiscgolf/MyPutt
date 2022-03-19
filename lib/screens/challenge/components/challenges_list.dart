import 'package:flutter/material.dart';
import 'package:myputt/data/types/challenges/putting_challenge.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myputt/screens/challenge/components/challenge_items.dart';
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
        child: RefreshIndicator(
            onRefresh: () => BlocProvider.of<ChallengesCubit>(context).reload(),
            child: challenges.isEmpty
                ? LayoutBuilder(
                    builder: (BuildContext context, constraints) =>
                        ListView(children: [
                      Container(
                          constraints:
                              BoxConstraints(minHeight: constraints.maxHeight),
                          child: const Center(child: Text('No challenges')))
                    ]),
                  )
                : ListView(
                    children: challenges
                        .map(
                          (challenge) => Builder(builder: (context) {
                            if (category == ChallengeCategory.pending) {
                              return ChallengeItem(
                                accept: () {
                                  BlocProvider.of<ChallengesCubit>(context)
                                      .openChallenge(challenge);
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          BlocProvider.value(
                                              value: BlocProvider.of<
                                                  ChallengesCubit>(context),
                                              child: ChallengeRecordScreen(
                                                challengeId: challenge.id,
                                              ))));
                                },
                                decline: () {
                                  BlocProvider.of<ChallengesCubit>(context)
                                      .declineChallenge(challenge);
                                },
                                challenge: challenge,
                              );
                            } else {
                              return ChallengeItem(
                                challenge: challenge,
                              );
                            }
                          }),
                        )
                        .toList(),
                  )));
  }
}
