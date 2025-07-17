import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:flutter/services.dart';
import 'package:mixpanel_flutter/mixpanel_flutter.dart';
import 'package:myputt/cubits/challenges/challenges_cubit.dart';
import 'package:myputt/locator.dart';
import 'package:myputt/utils/colors.dart';

class ChallengeUndoButton extends StatelessWidget {
  const ChallengeUndoButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChallengesCubit, ChallengesState>(
      builder: (context, state) {
        if (state is! CurrentChallengeState) {
          return const SizedBox();
        }

        return Bounceable(
          onTap: () {
            locator.get<Mixpanel>().track(
                  'Challenge Record Screen Undo Button Pressed',
                );
            HapticFeedback.lightImpact();
            if (state.currentChallenge.currentUserSets.isNotEmpty) {
              BlocProvider.of<ChallengesCubit>(context).undo();
            }
          },
          child: Container(
            decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(48)),
            child: const Center(
              child: Icon(
                FlutterRemix.arrow_go_back_line,
                color: MyPuttColors.darkGray,
              ),
            ),
          ),
        );
      },
    );
  }
}
