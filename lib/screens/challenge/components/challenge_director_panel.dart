import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:myputt/cubits/challenges_cubit.dart';
import 'package:myputt/theme/theme_data.dart';
import 'package:myputt/utils/calculators.dart';

class ChallengeDirectorPanel extends StatelessWidget {
  const ChallengeDirectorPanel({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChallengesCubit, ChallengesState>(
      builder: (context, state) {
        if (state is ChallengeInProgress) {
          final int currentUserPuttsMade =
              totalMadeFromSets(state.currentChallenge.currentUserSets);
          final int opponentPuttsMade = totalMadeFromSubset(
              state.currentChallenge.opponentSets,
              state.currentChallenge.currentUserSets.length);
          final int puttsMadeDifference =
              currentUserPuttsMade - opponentPuttsMade;
          return Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              border: Border.all(
                  color:
                      puttsMadeDifference >= 0 ? ThemeColors.green : Colors.red,
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
                                      style:
                                          Theme.of(context).textTheme.bodyLarge,
                                    ),
                                  ),
                                  Center(
                                    child: Text(
                                      'Putters',
                                      style:
                                          Theme.of(context).textTheme.bodyLarge,
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
                                          end: state
                                              .currentChallenge
                                              .challengeStructure[state
                                                  .currentChallenge
                                                  .currentUserSets
                                                  .length]
                                              .distance
                                              .toDouble()),
                                      duration:
                                          const Duration(milliseconds: 300),
                                      builder: (context, value, _) => Text(
                                        ' ${value.toInt().toString()} ft',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyLarge,
                                      ),
                                    ),
                                  ),
                                  Center(
                                    child: TweenAnimationBuilder<double>(
                                      tween: Tween<double>(
                                          begin: 0.0,
                                          end: state
                                              .currentChallenge
                                              .challengeStructure[state
                                                  .currentChallenge
                                                  .currentUserSets
                                                  .length]
                                              .setLength
                                              .toDouble()),
                                      duration:
                                          const Duration(milliseconds: 300),
                                      builder: (context, value, _) => Text(
                                        ' ${value.toInt().toString()}',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyLarge,
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
                                      state.currentChallenge.opponentUser
                                          .displayName,
                                      style:
                                          Theme.of(context).textTheme.bodyLarge,
                                    ),
                                  ),
                                  Center(
                                    child: Text(
                                      'You',
                                      style:
                                          Theme.of(context).textTheme.bodyLarge,
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
                                      _textAnimation(totalMadeFromSubset(
                                              state.currentChallenge
                                                  .opponentSets,
                                              state.currentChallenge
                                                  .currentUserSets.length)
                                          .toDouble()),
                                      Text(
                                        '/',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyLarge,
                                      ),
                                      _textAnimation(totalAttemptsFromSubset(
                                              state.currentChallenge
                                                  .opponentSets,
                                              state.currentChallenge
                                                  .currentUserSets.length)
                                          .toDouble()),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      _textAnimation(totalMadeFromSets(state
                                              .currentChallenge.currentUserSets)
                                          .toDouble()),
                                      Text(
                                        '/',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyLarge,
                                      ),
                                      _textAnimation(totalAttemptsFromSets(state
                                              .currentChallenge.currentUserSets)
                                          .toDouble())
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
                    final TextStyle? style =
                        Theme.of(context).textTheme.headline6;
                    final difference = totalMadeFromSets(
                            state.currentChallenge.currentUserSets) -
                        totalMadeFromSubset(state.currentChallenge.opponentSets,
                            state.currentChallenge.currentUserSets.length);
                    if (difference > 0) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("You're ahead by ", style: style),
                          Text('$difference ',
                              style: Theme.of(context)
                                  .textTheme
                                  .headline6
                                  ?.copyWith(color: ThemeColors.green)),
                          Text(difference == 1 ? 'putt' : 'putts',
                              style: style),
                        ],
                      );
                    } else if (difference < 0) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("You're behind by ", style: style),
                          Text('${difference.abs()} ',
                              style: Theme.of(context)
                                  .textTheme
                                  .headline6
                                  ?.copyWith(color: Colors.red)),
                          Text(difference == -1 ? 'putt' : 'putts',
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
        if (state is ChallengeComplete) {
          final int currentUserPuttsMade =
              totalMadeFromSets(state.currentChallenge.currentUserSets);
          final int opponentPuttsMade = totalMadeFromSubset(
              state.currentChallenge.opponentSets,
              state.currentChallenge.currentUserSets.length);
          final int puttsMadeDifference =
              currentUserPuttsMade - opponentPuttsMade;
          return Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              border: Border.all(
                  color:
                      puttsMadeDifference >= 0 ? ThemeColors.green : Colors.red,
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
                                    style:
                                        Theme.of(context).textTheme.bodyLarge,
                                  ),
                                ),
                                Center(
                                  child: Text(
                                    'Putters',
                                    style:
                                        Theme.of(context).textTheme.bodyLarge,
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
                                        end: state
                                            .currentChallenge
                                            .challengeStructure[state
                                                    .currentChallenge
                                                    .currentUserSets
                                                    .length -
                                                1]
                                            .distance
                                            .toDouble()),
                                    duration: const Duration(milliseconds: 300),
                                    builder: (context, value, _) => Text(
                                      ' ${value.toInt().toString()} ft',
                                      style:
                                          Theme.of(context).textTheme.bodyLarge,
                                    ),
                                  ),
                                ),
                                Center(
                                  child: TweenAnimationBuilder<double>(
                                    tween: Tween<double>(
                                        begin: 0.0,
                                        end: state
                                            .currentChallenge
                                            .challengeStructure[state
                                                    .currentChallenge
                                                    .currentUserSets
                                                    .length -
                                                1]
                                            .setLength
                                            .toDouble()),
                                    duration: const Duration(milliseconds: 300),
                                    builder: (context, value, _) => Text(
                                      ' ${value.toInt().toString()}',
                                      style:
                                          Theme.of(context).textTheme.bodyLarge,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      )),
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
                                    state.currentChallenge.opponentUser
                                        .displayName,
                                    style:
                                        Theme.of(context).textTheme.bodyLarge,
                                  ),
                                ),
                                Center(
                                  child: Text(
                                    'You',
                                    style:
                                        Theme.of(context).textTheme.bodyLarge,
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
                                    _textAnimation(totalMadeFromSubset(
                                            state.currentChallenge.opponentSets,
                                            state.currentChallenge
                                                .currentUserSets.length)
                                        .toDouble()),
                                    Text(
                                      '/',
                                      style:
                                          Theme.of(context).textTheme.bodyLarge,
                                    ),
                                    _textAnimation(totalAttemptsFromSubset(
                                            state.currentChallenge.opponentSets,
                                            state.currentChallenge
                                                .currentUserSets.length)
                                        .toDouble()),
                                  ],
                                ),
                                Row(
                                  children: [
                                    _textAnimation(totalMadeFromSets(state
                                            .currentChallenge.currentUserSets)
                                        .toDouble()),
                                    Text(
                                      '/',
                                      style:
                                          Theme.of(context).textTheme.bodyLarge,
                                    ),
                                    _textAnimation(totalAttemptsFromSets(state
                                            .currentChallenge.currentUserSets)
                                        .toDouble())
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      )),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                Center(
                  child: Builder(builder: (context) {
                    final TextStyle? style =
                        Theme.of(context).textTheme.headline6;
                    final difference = totalMadeFromSets(
                            state.currentChallenge.currentUserSets) -
                        totalMadeFromSubset(state.currentChallenge.opponentSets,
                            state.currentChallenge.currentUserSets.length);
                    if (difference > 0) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("You're ahead by ", style: style),
                          Text('$difference ',
                              style: Theme.of(context)
                                  .textTheme
                                  .headline6
                                  ?.copyWith(color: ThemeColors.green)),
                          Text(difference == 1 ? 'putt' : 'putts',
                              style: style),
                        ],
                      );
                    } else if (difference < 0) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("You're behind by ", style: style),
                          Text('${difference.abs()} ',
                              style: Theme.of(context)
                                  .textTheme
                                  .headline6
                                  ?.copyWith(color: Colors.red)),
                          Text(difference == -1 ? 'putt' : 'putts',
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
        } else {
          return Container();
        }
      },
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
