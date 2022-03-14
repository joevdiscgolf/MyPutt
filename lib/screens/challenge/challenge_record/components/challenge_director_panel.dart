import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myputt/cubits/challenges_cubit.dart';
import 'package:myputt/data/types/challenges/putting_challenge.dart';
import 'package:myputt/utils/colors.dart';
import 'package:myputt/utils/calculators.dart';

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
    final int puttsMadeDifference =
        getDifferenceFromChallenge(currentChallenge);
    final int distance = currentChallenge.challengeStructure[index].distance;
    final int setLength = currentChallenge.challengeStructure[index].setLength;
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: const BoxDecoration(
        // border: Border.all(
        //     color: puttsMadeDifference >= 0 ? MyPuttColors.green : Colors.red,
        //     width: 4),
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
          Center(
            child: Builder(builder: (context) {
              final TextStyle? style = Theme.of(context).textTheme.headline6;
              if (puttsMadeDifference > 0) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("You're ahead by ", style: style),
                    Text('$puttsMadeDifference ',
                        style: Theme.of(context)
                            .textTheme
                            .headline5
                            ?.copyWith(color: MyPuttColors.lightGreen)),
                    Text(puttsMadeDifference == 1 ? 'putt' : 'putts',
                        style: style),
                  ],
                );
              } else if (puttsMadeDifference < 0) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("You're behind by ", style: style),
                    Text('${puttsMadeDifference.abs()} ',
                        style: Theme.of(context)
                            .textTheme
                            .headline5
                            ?.copyWith(color: Colors.red)),
                    Text(puttsMadeDifference == -1 ? 'putt' : 'putts',
                        style: style),
                  ],
                );
              } else {
                return Text(
                  'All tied up',
                  style: style,
                );
              }
            }),
          )
        ],
      ),
    );
  }

  // Widget _textAnimation(double endValue) {
  //   return TweenAnimationBuilder<double>(
  //     tween: Tween<double>(
  //       begin: 0.0,
  //       end: endValue,
  //     ),
  //     duration: const Duration(milliseconds: 300),
  //     builder: (context, value, _) => Text(
  //       value.toInt().toString(),
  //       style: Theme.of(context).textTheme.bodyLarge,
  //     ),
  //   );
  // }
}
