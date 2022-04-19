import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myputt/components/misc/frisbee_circle_icon.dart';
import 'package:myputt/cubits/challenges_cubit.dart';
import 'package:myputt/data/types/challenges/putting_challenge.dart';
import 'package:myputt/data/types/users/myputt_user.dart';
import 'package:myputt/locator.dart';
import 'package:myputt/repositories/user_repository.dart';
import 'package:myputt/screens/challenge/challenge_record/components/animated_arrows.dart';
import 'package:myputt/screens/challenge/components/challenge_set_row.dart';
import 'package:myputt/utils/calculators.dart';
import 'package:myputt/utils/colors.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

class ChallengeProgressPanel extends StatelessWidget {
  ChallengeProgressPanel({Key? key}) : super(key: key);

  final UserRepository _userRepository = locator.get<UserRepository>();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChallengesCubit, ChallengesState>(
      builder: (context, state) {
        if (state is! ChallengesErrorState && state.currentChallenge != null) {
          final PuttingChallenge challenge = state.currentChallenge!;
          final bool challengeComplete = challenge.currentUserSets.length ==
              challenge.challengeStructure.length;

          final int distance = challengeComplete
              ? challenge
                  .challengeStructure[challenge.currentUserSets.length - 1]
                  .distance
              : challenge.challengeStructure[challenge.currentUserSets.length]
                  .distance;
          final int setLength = challengeComplete
              ? challenge
                  .challengeStructure[challenge.currentUserSets.length - 1]
                  .setLength
              : challenge.challengeStructure[challenge.currentUserSets.length]
                  .setLength;
          final int setNumber =
              (state is CurrentUserComplete || state is BothUsersComplete)
                  ? challenge.currentUserSets.length
                  : challenge.currentUserSets.length + 1;
          final int difference = getDifferenceFromChallenge(challenge);

          final int currentUserPuttsMade = challenge.currentUserSets.isNotEmpty
              ? challenge.currentUserSets.last.puttsMade.toInt()
              : 0;
          final int? opponentPuttsMade = challenge.opponentSets.isNotEmpty &&
                  challenge.opponentSets.length >
                      challenge.currentUserSets.length
              ? challenge
                  .opponentSets[challenge.currentUserSets.length -
                      (challengeComplete ? 1 : 0)]
                  .puttsMade
                  .toInt()
              : null;

          return Column(
            children: [
              _setNumberContainer(
                  context, setNumber, challenge.challengeStructure.length),
              Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                color: MyPuttColors.white,
                child: Column(
                  children: [
                    _versusRow(
                        context, challenge.currentUser, challenge.opponentUser),
                    const SizedBox(
                      height: 12,
                    ),
                    ChallengeSetRow(
                      currentUserMade: currentUserPuttsMade,
                      opponentMade: opponentPuttsMade,
                      setLength: setLength,
                      distance: distance,
                    ),
                  ],
                ),
              ),
              _instructionsPanel(context, distance, setLength),
              const SizedBox(
                height: 8,
              ),
              _percentCompleteIndicator(
                context,
                totalAttemptsFromSets(challenge.currentUserSets).toDouble() /
                    totalAttemptsFromStructure(challenge.challengeStructure)
                        .toDouble(),
                (totalAttemptsFromSubset(challenge.currentUserSets,
                            challenge.currentUserSets.length)
                        .toDouble()) /
                    totalAttemptsFromStructure(challenge.challengeStructure)
                        .toDouble(),
              ),
              const SizedBox(
                height: 8,
              ),
              _puttsDifferenceText(context, difference),
            ],
          );
        } else {
          return Container();
        }
      },
    );
  }

  Widget _setNumberContainer(BuildContext context, int setNumber, int maxSets) {
    return Container(
      margin: const EdgeInsets.only(bottom: 4),
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      decoration: BoxDecoration(color: MyPuttColors.gray[50], boxShadow: [
        BoxShadow(
            offset: const Offset(0, 2),
            color: MyPuttColors.gray[400]!,
            blurRadius: 2)
      ]),
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Set $setNumber / $maxSets',
              style: Theme.of(context)
                  .textTheme
                  .headline6
                  ?.copyWith(fontSize: 16, color: MyPuttColors.darkGray),
            ),
          ],
        ),
      ),
    );
  }

  Widget _versusRow(
      BuildContext context, MyPuttUser currentUser, MyPuttUser? opponentUser) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Expanded(
          child: Column(
            children: [
              FrisbeeCircleIcon(
                frisbeeAvatar: _userRepository.currentUser?.frisbeeAvatar,
                size: 60,
              ),
              const SizedBox(
                height: 8,
              ),
              AutoSizeText(
                currentUser.displayName,
                style: Theme.of(context)
                    .textTheme
                    .headline6
                    ?.copyWith(fontSize: 20, color: MyPuttColors.gray),
                textAlign: TextAlign.center,
                maxLines: 1,
              ),
            ],
          ),
        ),
        Expanded(
          child: AutoSizeText(
            'VS',
            style: Theme.of(context)
                .textTheme
                .headline6
                ?.copyWith(fontSize: 20, color: MyPuttColors.blue),
            textAlign: TextAlign.center,
            maxLines: 1,
          ),
        ),
        Expanded(
          child: Column(
            children: [
              FrisbeeCircleIcon(
                frisbeeAvatar: opponentUser?.frisbeeAvatar,
                size: 60,
              ),
              const SizedBox(
                height: 8,
              ),
              AutoSizeText(
                opponentUser?.displayName ?? 'Unknown',
                style: Theme.of(context)
                    .textTheme
                    .headline6
                    ?.copyWith(fontSize: 20, color: MyPuttColors.gray),
                textAlign: TextAlign.center,
                maxLines: 1,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _percentCompleteIndicator(
      BuildContext context, double begin, double end) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TweenAnimationBuilder<double>(
          curve: Curves.easeOutQuad,
          tween: Tween<double>(
            begin: begin,
            end: end,
          ),
          duration: const Duration(milliseconds: 400),
          builder: (context, value, _) => Row(
                children: [
                  Flexible(
                    flex: 5,
                    child: LinearPercentIndicator(
                      lineHeight: 8,
                      percent: value,
                      progressColor: MyPuttColors.gray[400],
                      backgroundColor: Colors.grey[200],
                      barRadius: const Radius.circular(2),
                    ),
                  ),
                  Flexible(
                    flex: 1,
                    child: Center(
                      child: Text(
                        '${(value * 100).toInt()} %',
                        style: Theme.of(context)
                            .textTheme
                            .headline6
                            ?.copyWith(fontSize: 12, color: MyPuttColors.gray),
                      ),
                    ),
                  )
                ],
              )),
    );
  }

  Widget _instructionsPanel(BuildContext context, int distance, int setLength) {
    return Container(
      decoration: BoxDecoration(color: MyPuttColors.gray[50], boxShadow: [
        BoxShadow(
            offset: const Offset(0, 2),
            color: MyPuttColors.gray[400]!,
            blurRadius: 2)
      ]),
      padding: const EdgeInsets.all(10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            '$distance ft',
            style: Theme.of(context)
                .textTheme
                .headline6
                ?.copyWith(fontSize: 24, fontWeight: FontWeight.w600),
          ),
          const AnimatedArrows(),
          Text(
            '$setLength putts',
            style: Theme.of(context)
                .textTheme
                .headline6
                ?.copyWith(fontSize: 24, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }

  Widget _puttsDifferenceText(BuildContext context, int puttsMadeDifference) {
    return Builder(builder: (context) {
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
                    ?.copyWith(color: MyPuttColors.blue)),
            Text(puttsMadeDifference == 1 ? 'putt' : 'putts', style: style),
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
                    ?.copyWith(color: MyPuttColors.red)),
            Text(puttsMadeDifference == -1 ? 'putt' : 'putts', style: style),
          ],
        );
      } else {
        return Text(
          'All tied up',
          style: style,
        );
      }
    });
  }
}
