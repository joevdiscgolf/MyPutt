import 'package:flutter/material.dart';
import 'package:myputt/components/misc/putts_made_picker.dart';
import 'package:myputt/cubits/challenges/challenges_cubit.dart';
import 'package:myputt/models/data/challenges/challenge_structure_item.dart';
import 'package:myputt/utils/colors.dart';
import 'package:myputt/utils/set_helpers.dart';
import 'package:scroll_snap_list/scroll_snap_list.dart';

import 'challenge_undo_button.dart';

class PuttsMadeContainer extends StatelessWidget {
  const PuttsMadeContainer({
    Key? key,
    required this.state,
    required this.updatePickerIndex,
    required this.sslKey,
  }) : super(key: key);

  final ChallengesState state;
  final Function(int) updatePickerIndex;
  final GlobalKey<ScrollSnapListState> sslKey;

  @override
  Widget build(BuildContext context) {
    if (state is! CurrentChallengeState) {
      return const SizedBox();
    }

    final CurrentChallengeState currentChallengeState =
        state as CurrentChallengeState;

    final ChallengeStructureItem currentStructureItem =
        SetHelpers.getCurrentChallengeStructureItem(
      currentChallengeState.currentChallenge.challengeStructure,
      currentChallengeState.currentChallenge.currentUserSets,
    );

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      color: MyPuttColors.white,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Putts made',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontSize: 20,
                          color: MyPuttColors.darkGray,
                        ),
                  ),
                ),
                const Align(
                  alignment: Alignment.centerRight,
                  child: ChallengeUndoButton(),
                )
              ],
            ),
          ),
          const SizedBox(height: 16),
          PuttsMadePicker(
            initialIndex: currentStructureItem.setLength.toDouble(),
            length: currentStructureItem.setLength,
            challengeMode: true,
            sslKey: sslKey,
            onUpdate: (int newIndex) => updatePickerIndex(newIndex),
          ),
        ],
      ),
    );
  }
}
