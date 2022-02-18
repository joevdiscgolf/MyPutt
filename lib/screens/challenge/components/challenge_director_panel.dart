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
            child: IntrinsicHeight(
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
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
                      const SizedBox(width: 10),
                      VerticalDivider(
                        width: 5,
                        color: Colors.grey[400]!,
                        thickness: 1,
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
                                    end: state
                                        .currentChallenge
                                        .challengeStructure[state
                                            .currentChallenge
                                            .currentUserSets
                                            .length]
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
                      VerticalDivider(
                        thickness: 2,
                        color: Colors.grey[800],
                      ),
                      Flexible(
                        flex: 2,
                        child: Column(
                          children: [
                            Center(
                              child: Text(
                                state.currentChallenge.opponentUser.displayName,
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
                                _textAnimation(totalMadeFromSubset(
                                        state.currentChallenge.opponentSets,
                                        state.currentChallenge.currentUserSets
                                            .length)
                                    .toDouble()),
                                Text(
                                  '/',
                                  style: Theme.of(context).textTheme.bodyLarge,
                                ),
                                _textAnimation(totalAttemptsFromSubset(
                                        state.currentChallenge.opponentSets,
                                        state.currentChallenge.currentUserSets
                                            .length)
                                    .toDouble()),
                              ],
                            ),
                            Row(
                              children: [
                                _textAnimation(totalMadeFromSets(
                                        state.currentChallenge.currentUserSets)
                                    .toDouble()),
                                Text(
                                  '/',
                                  style: Theme.of(context).textTheme.bodyLarge,
                                ),
                                _textAnimation(totalAttemptsFromSets(
                                        state.currentChallenge.currentUserSets)
                                    .toDouble())
                              ],
                            ),
                          ],
                        ),
                      ),
                      Flexible(
                        flex: 1,
                        child: Column(
                          children: [
                            TweenAnimationBuilder<double>(
                              tween: Tween<double>(
                                begin: 0.0,
                                end: puttsMadeDifference.toDouble(),
                              ),
                              duration: const Duration(milliseconds: 300),
                              builder: (context, value, _) => Text(
                                '${puttsMadeDifference > 0 ? '+' : ''}${value.toInt()}',
                                style: TextStyle(
                                  color: puttsMadeDifference >= 0
                                      ? ThemeColors.green
                                      : Colors.red,
                                ),
                              ),
                            ),
                            Icon(
                              puttsMadeDifference >= 0
                                  ? FlutterRemix.arrow_up_line
                                  : FlutterRemix.arrow_down_line,
                              color: puttsMadeDifference >= 0
                                  ? ThemeColors.green
                                  : Colors.red,
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 10),
                  Center(
                    child: Builder(builder: (context) {
                      final TextStyle? style =
                          Theme.of(context).textTheme.headline6;
                      final difference = totalMadeFromSets(
                              state.currentChallenge.currentUserSets) -
                          totalMadeFromSubset(
                              state.currentChallenge.opponentSets,
                              state.currentChallenge.currentUserSets.length);
                      if (difference > 0) {
                        return Text(
                            "You're ahead by $difference ${difference == 1 ? 'putt' : 'putts'}",
                            style: style);
                      } else if (difference < 0) {
                        return Text(
                          "You're behind behind by ${difference.abs()} ${difference == -1 ? 'putt' : 'putts'}",
                          style: style,
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
            child: IntrinsicHeight(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
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
                  const SizedBox(width: 10),
                  VerticalDivider(
                    width: 5,
                    color: Colors.grey[400]!,
                    thickness: 1,
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
                                    .challengeStructure[state.currentChallenge
                                            .currentUserSets.length -
                                        1]
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
                                end: state
                                    .currentChallenge
                                    .challengeStructure[state.currentChallenge
                                            .currentUserSets.length -
                                        1]
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
                  VerticalDivider(
                    thickness: 2,
                    color: Colors.grey[800],
                  ),
                  Flexible(
                    flex: 2,
                    child: Column(
                      children: [
                        Center(
                          child: Text(
                            state.currentChallenge.opponentUser.displayName,
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
                            _textAnimation(totalMadeFromSubset(
                                    state.currentChallenge.opponentSets,
                                    state.currentChallenge.currentUserSets
                                        .length)
                                .toDouble()),
                            Text(
                              '/',
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                            _textAnimation(totalAttemptsFromSubset(
                                    state.currentChallenge.opponentSets,
                                    state.currentChallenge.currentUserSets
                                        .length)
                                .toDouble()),
                          ],
                        ),
                        Row(
                          children: [
                            _textAnimation(totalMadeFromSets(
                                    state.currentChallenge.currentUserSets)
                                .toDouble()),
                            Text(
                              '/',
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                            _textAnimation(totalAttemptsFromSets(
                                    state.currentChallenge.currentUserSets)
                                .toDouble())
                          ],
                        ),
                      ],
                    ),
                  ),
                  Flexible(
                    flex: 1,
                    child: Column(
                      children: [
                        TweenAnimationBuilder<double>(
                          tween: Tween<double>(
                            begin: 0.0,
                            end: puttsMadeDifference.toDouble(),
                          ),
                          duration: const Duration(milliseconds: 300),
                          builder: (context, value, _) => Text(
                            '${puttsMadeDifference > 0 ? '+' : ''}${value.toInt()}',
                            style: TextStyle(
                              color: puttsMadeDifference >= 0
                                  ? ThemeColors.green
                                  : Colors.red,
                            ),
                          ),
                        ),
                        Icon(
                          puttsMadeDifference >= 0
                              ? FlutterRemix.arrow_up_line
                              : FlutterRemix.arrow_down_line,
                          color: puttsMadeDifference >= 0
                              ? ThemeColors.green
                              : Colors.red,
                        ),
                      ],
                    ),
                  )
                ],
              ),
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
        '${value.toInt().toString()}',
        style: Theme.of(context).textTheme.bodyLarge,
      ),
    );
  }
}
