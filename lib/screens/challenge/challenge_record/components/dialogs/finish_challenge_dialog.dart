import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:myputt/components/dialogs/confirm_dialog.dart';
import 'package:myputt/cubits/challenges/challenges_cubit.dart';
import 'package:myputt/utils/colors.dart';

class FinishChallengeDialog extends StatelessWidget {
  const FinishChallengeDialog({Key? key, required this.onComplete})
      : super(key: key);

  final Function onComplete;

  @override
  Widget build(BuildContext context) {
    return ConfirmDialog(
      actionPressed: () async {
        onComplete();
        await BlocProvider.of<ChallengesCubit>(context).finishChallenge();
      },
      buttonlabel: 'Finish',
      title: 'Finish challenge',
      buttonColor: MyPuttColors.forestGreen,
      icon: const Icon(
        FlutterRemix.sword_fill,
        color: MyPuttColors.black,
        size: 80,
      ),
    );
  }
}
