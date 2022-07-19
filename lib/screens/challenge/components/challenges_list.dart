import 'dart:math';

import 'package:flutter/material.dart';
import 'package:myputt/models/data/challenges/putting_challenge.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myputt/screens/challenge/components/challenge_list_row.dart';
import 'package:myputt/utils/calculators.dart';
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
      child: RefreshIndicator(
        onRefresh: () => BlocProvider.of<ChallengesCubit>(context).reload(),
        child: challenges.isEmpty
            ? LayoutBuilder(
                builder: (BuildContext context, constraints) => ListView(
                  children: [
                    Container(
                      constraints:
                          BoxConstraints(minHeight: constraints.maxHeight),
                      child: const Center(
                        child: Text('No challenges'),
                      ),
                    )
                  ],
                ),
              )
            : ListView(
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
                              BlocProvider.of<ChallengesCubit>(context)
                                  .openChallenge(challenge);
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      BlocProvider.value(
                                    value: BlocProvider.of<ChallengesCubit>(
                                        context),
                                    child: ChallengeRecordScreen(
                                      challenge: challenge,
                                    ),
                                  ),
                                ),
                              );
                            },
                            decline: () {
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
                          final int opponentPuttsMade = totalMadeFromSubset(
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
                            opponentPuttsAttempted: opponentPuttsAttempted,
                            opponentPuttsMade: opponentPuttsMade,
                            difference: difference,
                            challenge: challenge,
                          );
                        }
                      }),
                    )
                    .toList(),
              ),
      ),
    );
  }
}
