import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';
import 'package:myputt/components/misc/circular_icon_container.dart';
import 'package:myputt/models/data/challenges/generated_challenge_item.dart';
import 'package:myputt/screens/challenge/components/dialogs/components/structure_description_row.dart';
import 'package:myputt/utils/calculators.dart';
import 'package:myputt/utils/colors.dart';
import 'package:myputt/utils/constants.dart';
import 'package:myputt/utils/enums.dart';

class PresetListItem extends StatelessWidget {
  const PresetListItem({
    Key? key,
    required this.presetType,
    required this.presetInstructions,
    required this.onTap,
    required this.selected,
  }) : super(key: key);

  final ChallengePreset presetType;
  final List<GeneratedChallengeInstruction> presetInstructions;
  final bool selected;
  final Function onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      decoration: BoxDecoration(
        color: selected ? MyPuttColors.gray[300] : MyPuttColors.gray[50],
        boxShadow: [
          BoxShadow(
              offset: const Offset(0, 2),
              blurRadius: 2,
              color: MyPuttColors.gray[400]!)
        ],
      ),
      child: ExpandableTheme(
        data: const ExpandableThemeData(
          iconPadding: EdgeInsets.only(left: 8, right: 24),
          headerAlignment: ExpandablePanelHeaderAlignment.center,
          alignment: Alignment.center,
          iconSize: 20,
          iconColor: MyPuttColors.darkGray,
        ),
        child: ExpandableNotifier(
          initialExpanded: false,
          child: ExpandablePanel(
            header: _mainRow(context),
            collapsed: const SizedBox(height: 0),
            expanded: Container(
                margin: const EdgeInsets.only(top: 4),
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                color: MyPuttColors.white,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: _expandedColumnChildren(context))),
          ),
        ),
      ),
    );
  }

  Widget _mainRow(BuildContext context) {
    return Bounceable(
      onTap: () {
        Vibrate.feedback(FeedbackType.light);
        onTap(presetType);
      },
      child: Container(
        padding: const EdgeInsets.only(left: 20, top: 8, bottom: 8),
        alignment: Alignment.center,
        child: Row(
          children: [
            const CircularIconContainer(
              icon: Icon(
                FlutterRemix.calendar_check_fill,
                color: MyPuttColors.blue,
              ),
              size: 60,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(challengePresetToText[presetType]!,
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge
                      ?.copyWith(fontSize: 12, color: MyPuttColors.darkGray)),
            )
          ],
        ),
      ),
    );
  }

  List<Widget> _expandedColumnChildren(BuildContext context) {
    List<Widget> children = [];
    children.addAll(presetInstructions.map((instruction) =>
        StructureDescriptionRow(generatedChallengeInstruction: instruction)));
    children.addAll([
      const SizedBox(height: 8),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularIconContainer(
              size: 48,
              icon: Image(
                height: 48,
                width: 48,
                image: AssetImage(blueFrisbeeIconSrc),
              )),
          const SizedBox(width: 12),
          Text(
              '${totalAttemptsFromPresetInstructions(presetInstructions)} total',
              style: Theme.of(context)
                  .textTheme
                  .titleLarge
                  ?.copyWith(fontSize: 14, color: MyPuttColors.darkGray)),
        ],
      ),
      const SizedBox(height: 8),
    ]);
    return children;
  }
}
