import 'package:flutter/material.dart';
import 'package:myputt/data/types/challenges/putting_challenge.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myputt/screens/challenge/challenge_summary_screen.dart';
import 'package:myputt/screens/challenge/components/challenge_items.dart';
import 'package:myputt/utils/constants.dart';

import '../../../cubits/challenges_cubit.dart';
import '../challenge_record_screen.dart';

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
        child: challenges.isEmpty
            ? const Center(child: Text('No challenges'))
            : ListView(
                shrinkWrap: true,
                children: challenges
                    .map(
                      (challenge) => Builder(builder: (context) {
                        if (category == ChallengeCategory.pending) {
                          return NewPendingChallengeItem(
                            accept: () {
                              BlocProvider.of<ChallengesCubit>(context)
                                  .openChallenge(challenge);
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      BlocProvider.value(
                                          value:
                                              BlocProvider.of<ChallengesCubit>(
                                                  context),
                                          child:
                                              const ChallengeRecordScreen())));
                            },
                            challenge: challenge,
                          );
                        } else if (category == ChallengeCategory.active) {
                          return NewActiveChallengeItem(
                              challenge:
                                  challenge); /*ActiveChallengeItem(
                              accept: () {
                                BlocProvider.of<ChallengesCubit>(context)
                                    .openChallenge(challenge);
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        BlocProvider.value(
                                            value: BlocProvider.of<
                                                ChallengesCubit>(context),
                                            child:
                                                const ChallengeRecordScreen())));
                              },
                              challenge: challenge);*/
                        } else {
                          return CompletedChallengeItem(
                            challenge: challenge,
                          );
                        }
                      }),
                    )
                    .toList(),
              ));
  }
}
