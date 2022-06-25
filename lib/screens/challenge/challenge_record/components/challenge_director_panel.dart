import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myputt/cubits/challenges_cubit.dart';
import 'package:myputt/models/data/challenges/putting_challenge.dart';

import 'animated_arrows.dart';

class ChallengeDirectorPanel extends StatelessWidget {
  const ChallengeDirectorPanel({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChallengesCubit, ChallengesState>(
        builder: (context, state) {
      if (state.currentChallenge != null) {
        if (state is ChallengeInProgress || state is OpponentUserComplete) {
          int index = state.currentChallenge!.currentUserSets.length ==
                  state.currentChallenge!.challengeStructure.length
              ? state.currentChallenge!.currentUserSets.length - 1
              : state.currentChallenge!.currentUserSets.length;
          return _mainBody(context, state.currentChallenge!, index);
        } else {
          return _mainBody(context, state.currentChallenge!,
              state.currentChallenge!.currentUserSets.length - 1);
        }
      } else {
        return const Center(child: Text('Something went wrong'));
      }
    });
  }

  Widget _mainBody(
      BuildContext context, PuttingChallenge currentChallenge, int index) {
    final int distance = currentChallenge.challengeStructure[index].distance;
    final int setLength = currentChallenge.challengeStructure[index].setLength;
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: const BoxDecoration(
        color: Colors.white,
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '$distance ft',
                style: Theme.of(context)
                    .textTheme
                    .headline4
                    ?.copyWith(fontWeight: FontWeight.w600),
              ),
              const AnimatedArrows(),
              Text(
                '$setLength putts',
                style: Theme.of(context)
                    .textTheme
                    .headline5
                    ?.copyWith(fontWeight: FontWeight.w600),
              ),
            ],
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}
