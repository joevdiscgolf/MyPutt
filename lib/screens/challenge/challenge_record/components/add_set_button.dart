import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:flutter/services.dart';
import 'package:mixpanel_flutter/mixpanel_flutter.dart';
import 'package:myputt/components/buttons/my_putt_button.dart';
import 'package:myputt/cubits/challenges/challenges_cubit.dart';
import 'package:myputt/locator.dart';
import 'package:myputt/models/data/sessions/putting_set.dart';
import 'package:myputt/screens/challenge/challenge_record/components/dialogs/finish_challenge_dialog.dart';
import 'package:myputt/utils/colors.dart';

class AddSetButton extends StatelessWidget {
  const AddSetButton({
    Key? key,
    required this.state,
    required this.focusedIndex,
    required this.endChallenge,
  }) : super(key: key);

  final ChallengesState state;
  final int focusedIndex;
  final Function endChallenge;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: MyPuttButton(
        title: _titleFromState(),
        onPressed: _functionFromState(context),
        backgroundColor: _colorFromState(),
        iconData: _iconDataFromState(),
        iconColor: MyPuttColors.white,
        width: double.infinity,
      ),
    );
  }

  Function _functionFromState(BuildContext context) {
    if (state is! CurrentChallengeState) {
      return () {};
    }
    final CurrentChallengeState currentChallengeState =
        state as CurrentChallengeState;

    switch (currentChallengeState.challengeStage) {
      case ChallengeStage.bothUsersComplete:
        return () {
          HapticFeedback.lightImpact();
          locator.get<Mixpanel>().track(
                'Challenge Record Screen Finish Challenge Button Pressed',
              );
          showDialog(
            context: context,
            builder: (dialogContext) => BlocProvider.value(
              value: BlocProvider.of<ChallengesCubit>(context),
              child: FinishChallengeDialog(onComplete: endChallenge),
            ),
          );
        };
      case ChallengeStage.currentUserComplete:
        return () {
          HapticFeedback.lightImpact();
        };
      default:
        return () {
          HapticFeedback.lightImpact();
          locator.get<Mixpanel>().track(
                'Challenge Record Screen Add Set Button Pressed',
              );
          if (currentChallengeState.currentChallenge.currentUserSets.length <
              currentChallengeState
                  .currentChallenge.challengeStructure.length) {
            BlocProvider.of<ChallengesCubit>(context).addSet(
              PuttingSet(
                timeStamp: DateTime.now().millisecondsSinceEpoch,
                distance: currentChallengeState
                    .currentChallenge
                    .challengeStructure[currentChallengeState
                        .currentChallenge.currentUserSets.length]
                    .distance,
                puttsAttempted: currentChallengeState
                    .currentChallenge
                    .challengeStructure[currentChallengeState
                        .currentChallenge.currentUserSets.length]
                    .setLength,
                puttsMade: focusedIndex,
              ),
            );
          }
        };
    }
  }

  String _titleFromState() {
    if (state is CurrentChallengeState) {
      switch ((state as CurrentChallengeState).challengeStage) {
        case ChallengeStage.bothUsersComplete:
          return 'Finish challenge';
        case ChallengeStage.currentUserComplete:
          return 'Waiting for ${(state as CurrentChallengeState).currentChallenge.opponentUser?.displayName ?? 'Unknown'}...';
        default:
          break;
      }
    }
    return 'Add set';
  }

  Color _colorFromState() {
    if (state is CurrentChallengeState &&
        (state as CurrentChallengeState).challengeStage ==
            ChallengeStage.bothUsersComplete) {
      return MyPuttColors.forestGreen;
    } else {
      return MyPuttColors.blue;
    }
  }

  IconData _iconDataFromState() {
    if (state is CurrentChallengeState) {
      switch ((state as CurrentChallengeState).challengeStage) {
        case ChallengeStage.bothUsersComplete:
          return FlutterRemix.check_line;
        case ChallengeStage.currentUserComplete:
          return FlutterRemix.time_line;
        default:
          break;
      }
    }
    return FlutterRemix.add_line;
  }
}
