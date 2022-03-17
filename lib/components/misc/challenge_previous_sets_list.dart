import 'package:flutter/material.dart';
import 'package:myputt/data/types/putting_set.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myputt/components/misc/putting_set_row.dart';
import 'package:myputt/cubits/challenges_cubit.dart';
import 'package:myputt/screens/challenge/challenge_record/components/challenge_record_set_row.dart';

class ChallengePreviousSetsList extends StatelessWidget {
  const ChallengePreviousSetsList({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChallengesCubit, ChallengesState>(
        builder: (context, state) {
      if (state is! ChallengesErrorState && state.currentChallenge != null) {
        final List<PuttingSet> currentUserSets =
            state.currentChallenge!.currentUserSets;
        final List<PuttingSet> opponentSets =
            state.currentChallenge!.opponentSets;
        final List<Widget> children = List.from(currentUserSets
            .asMap()
            .entries
            .map((entry) {
              return ChallengeRecordSetRow(
                setNumber: entry.key,
                currentUserPuttsMade: entry.value.puttsMade.toInt(),
                opponentPuttsMade: opponentSets.length,
                setLength: entry.value.puttsAttempted.toInt(),
              );
            })
            .toList()
            .reversed);

        print(children);
        return currentUserSets.isEmpty
            ? const Center(child: Text('No sets yet'))
            : ListView(children: children);
      } else {
        return Container();
      }
    });
  }
}
