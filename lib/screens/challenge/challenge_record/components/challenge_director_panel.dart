import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myputt/cubits/challenges_cubit.dart';
import 'package:myputt/data/types/challenges/putting_challenge.dart';
import 'package:myputt/theme/theme_data.dart';
import 'package:myputt/utils/calculators.dart';

class ChallengeDirectorPanel extends StatelessWidget {
  const ChallengeDirectorPanel({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChallengesCubit, ChallengesState>(
      builder: (context, state) {
        if (state is! ChallengesErrorState && state.currentChallenge != null) {
          return _mainBody(context, state.currentChallenge!);
        } else {
          return Container(
            child: Center(child: Text('Something went wrong')),
          );
        }
      },
    );
  }

  Widget _mainBody(BuildContext context, PuttingChallenge currentChallenge) {
    final int puttsMadeDifference =
        getDifferenceFromChallenge(currentChallenge);
    final int currentUserPuttsMade = getPuttsMadeFromChallenge(
        currentChallenge.currentUser.uid, currentChallenge);
    final int currentUserPuttsAttempted = getPuttsAttemptedFromChallenge(
        currentChallenge.currentUser.uid, currentChallenge);
    final int opponentPuttsMade = getPuttsMadeFromChallenge(
        currentChallenge.opponentUser?.uid ?? '', currentChallenge);
    final int opponentPuttsAttempted = getPuttsAttemptedFromChallenge(
        currentChallenge.opponentUser?.uid ?? '', currentChallenge);
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        border: Border.all(
            color: puttsMadeDifference >= 0 ? ThemeColors.green : Colors.red,
            width: 4),
        color: Colors.white,
      ),
      child: Column(
        children: [
          IntrinsicHeight(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Flexible(
                        flex: 2,
                        child: Column(
                          children: [
                            Center(
                              child: Text(
                                'Distance',
                                style: Theme.of(context).textTheme.bodyLarge,
                              ),
                            ),
                            Center(
                              child: Text(
                                'Putters',
                                style: Theme.of(context).textTheme.bodyLarge,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Flexible(
                        flex: 2,
                        child: Column(
                          children: [
                            Center(
                              child: TweenAnimationBuilder<double>(
                                tween: Tween<double>(
                                    begin: 0.0,
                                    end: currentChallenge
                                        .challengeStructure[currentChallenge
                                            .currentUserSets.length]
                                        .distance
                                        .toDouble()),
                                duration: const Duration(milliseconds: 300),
                                builder: (context, value, _) => Text(
                                  ' ${value.toInt().toString()} ft',
                                  style: Theme.of(context).textTheme.bodyLarge,
                                ),
                              ),
                            ),
                            Center(
                              child: TweenAnimationBuilder<double>(
                                tween: Tween<double>(
                                    begin: 0.0,
                                    end: currentChallenge
                                        .challengeStructure[currentChallenge
                                            .currentUserSets.length]
                                        .setLength
                                        .toDouble()),
                                duration: const Duration(milliseconds: 300),
                                builder: (context, value, _) => Text(
                                  ' ${value.toInt().toString()}',
                                  style: Theme.of(context).textTheme.bodyLarge,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                VerticalDivider(
                  thickness: 2,
                  color: Colors.grey[800],
                ),
                Expanded(
                  child: Row(
                    children: [
                      Flexible(
                        flex: 2,
                        child: Column(
                          children: [
                            Center(
                              child: Text(
                                currentChallenge.opponentUser?.displayName ??
                                    'Unknown',
                                style: Theme.of(context).textTheme.bodyLarge,
                              ),
                            ),
                            Center(
                              child: Text(
                                'You',
                                style: Theme.of(context).textTheme.bodyLarge,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Flexible(
                        flex: 2,
                        child: Column(
                          children: [
                            Row(
                              children: [
                                _textAnimation(opponentPuttsMade.toDouble()),
                                Text(
                                  '/',
                                  style: Theme.of(context).textTheme.bodyLarge,
                                ),
                                _textAnimation(
                                    opponentPuttsAttempted.toDouble()),
                              ],
                            ),
                            Row(
                              children: [
                                _textAnimation(currentUserPuttsMade.toDouble()),
                                Text(
                                  '/',
                                  style: Theme.of(context).textTheme.bodyLarge,
                                ),
                                _textAnimation(
                                    currentUserPuttsAttempted.toDouble())
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
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
                            .headline6
                            ?.copyWith(color: ThemeColors.green)),
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
                            .headline6
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

  Widget _textAnimation(double endValue) {
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(
        begin: 0.0,
        end: endValue,
      ),
      duration: const Duration(milliseconds: 300),
      builder: (context, value, _) => Text(
        value.toInt().toString(),
        style: Theme.of(context).textTheme.bodyLarge,
      ),
    );
  }
}
