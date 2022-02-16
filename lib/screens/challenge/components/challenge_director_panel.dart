import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:myputt/cubits/challenges_cubit.dart';
import 'package:myputt/utils/calculators.dart';

class ChallengeDirectorPanel extends StatelessWidget {
  const ChallengeDirectorPanel({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChallengesCubit, ChallengesState>(
      builder: (context, state) {
        if (state is ChallengeInProgress) {
          return Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.blue, width: 4),
              color: Colors.white,
            ),
            child: IntrinsicHeight(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Flexible(
                    flex: 1,
                    child: Column(
                      children: [
                        Center(
                          child: Text(
                            'Distance',
                            style: Theme.of(context).textTheme.headline6,
                          ),
                        ),
                        Center(
                          child: Text(
                            'Putters',
                            style: Theme.of(context).textTheme.headline6,
                          ),
                        ),
                      ],
                    ),
                  ),
                  VerticalDivider(
                    width: 5,
                    color: Colors.grey[400]!,
                    thickness: 1,
                  ),
                  Flexible(
                    flex: 1,
                    child: Column(
                      children: [
                        Center(
                          child: TweenAnimationBuilder<double>(
                            tween: Tween<double>(
                                begin: 0.0,
                                end: state
                                    .currentChallenge
                                    .challengeStructure[state.currentChallenge
                                        .currentUserSets.length]
                                    .distance
                                    .toDouble()),
                            duration: const Duration(milliseconds: 300),
                            builder: (context, value, _) => Text(
                              ' ${value.toInt().toString()} ft',
                              style: Theme.of(context).textTheme.headline6,
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
                                        .currentUserSets.length]
                                    .setLength
                                    .toDouble()),
                            duration: const Duration(milliseconds: 300),
                            builder: (context, value, _) => Text(
                              ' ${value.toInt().toString()}',
                              style: Theme.of(context).textTheme.headline6,
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
                    flex: 1,
                    child: Column(
                      children: [
                        Center(
                          child: Text(
                            state.currentChallenge.opponentUser.displayName,
                            style: Theme.of(context).textTheme.headline6,
                          ),
                        ),
                        Center(
                          child: Text(
                            state.currentChallenge.currentUser.displayName,
                            style: Theme.of(context).textTheme.headline6,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Flexible(
                    flex: 1,
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
                              style: Theme.of(context).textTheme.headline6,
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
                              style: Theme.of(context).textTheme.headline6,
                            ),
                            _textAnimation(totalAttemptsFromSet(
                                    state.currentChallenge.currentUserSets)
                                .toDouble())
                          ],
                        ),
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      Icon(
                        FlutterRemix.arrow_up_line,
                      ),
                    ],
                  )
                ],
              ),
            ),
          );
        }
        if (state is ChallengeComplete) {
          return Container();
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
        style: Theme.of(context).textTheme.headline6,
      ),
    );
  }
}
