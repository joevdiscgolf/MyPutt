import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';
import 'package:myputt/cubits/challenges_cubit.dart';
import 'package:myputt/utils/colors.dart';

class UndoButton extends StatelessWidget {
  const UndoButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChallengesCubit, ChallengesState>(
      builder: (context, state) {
        return Bounceable(
            onTap: () {
              Vibrate.feedback(FeedbackType.light);
              if (state.currentChallenge!.currentUserSets.isNotEmpty) {
                BlocProvider.of<ChallengesCubit>(context).undo();
              }
            },
            child: Container(
                decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(48)),
                child: Center(
                  child: Icon(
                    FlutterRemix.arrow_go_back_line,
                    color: MyPuttColors.gray[800],
                  ),
                )));
      },
    );
  }
}
