import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';
import 'package:mixpanel_flutter/mixpanel_flutter.dart';
import 'package:myputt/components/buttons/my_putt_button.dart';
import 'package:myputt/cubits/challenges_cubit.dart';
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
    if (state is BothUsersComplete) {
      return () {
        Vibrate.feedback(FeedbackType.light);
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
    } else if (state is CurrentUserComplete) {
      return () => Vibrate.feedback(FeedbackType.light);
    } else {
      return () {
        Vibrate.feedback(FeedbackType.light);
        locator.get<Mixpanel>().track(
              'Challenge Record Screen Add Set Button Pressed',
            );
        if (state.currentChallenge!.currentUserSets.length <
            state.currentChallenge!.challengeStructure.length) {
          BlocProvider.of<ChallengesCubit>(context).addSet(
            PuttingSet(
              timeStamp: DateTime.now().millisecondsSinceEpoch,
              distance: state
                  .currentChallenge!
                  .challengeStructure[
                      state.currentChallenge!.currentUserSets.length]
                  .distance,
              puttsAttempted: state
                  .currentChallenge!
                  .challengeStructure[
                      state.currentChallenge!.currentUserSets.length]
                  .setLength,
              puttsMade: focusedIndex,
            ),
          );
        }
      };
    }
  }

  String _titleFromState() {
    if (state is BothUsersComplete) {
      return 'Finish challenge';
    } else if (state is CurrentUserComplete) {
      return 'Waiting for ${state.currentChallenge!.opponentUser?.displayName ?? 'Unknown'}...';
    } else {
      return 'Add set';
    }
  }

  Color _colorFromState() {
    if (state is BothUsersComplete) {
      return MyPuttColors.forestGreen;
    }
    return MyPuttColors.blue;
  }

  IconData _iconDataFromState() {
    if (state is BothUsersComplete) {
      return FlutterRemix.check_line;
    } else if (state is CurrentUserComplete) {
      return FlutterRemix.time_line;
    } else {
      return FlutterRemix.add_line;
    }
  }
}
