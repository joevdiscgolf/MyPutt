import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:myputt/components/misc/circular_icon_container.dart';
import 'package:myputt/utils/colors.dart';
import 'package:myputt/utils/constants.dart';
import 'package:myputt/utils/enums.dart';

class PresetListItem extends StatelessWidget {
  const PresetListItem(
      {Key? key, this.children = const [], required this.preset})
      : super(key: key);

  final ChallengePreset preset;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return ExpandableTheme(
      data: ExpandableThemeData(
        iconPadding: const EdgeInsets.only(left: 8, right: 24),
        headerAlignment: ExpandablePanelHeaderAlignment.center,
        alignment: Alignment.center,
        iconSize: 20,
        iconColor: MyPuttColors.gray[300],
      ),
      child: ExpandableNotifier(
        initialExpanded: false,
        child: ExpandablePanel(
          header: _mainRow(context),
          collapsed: const SizedBox(height: 0),
          expanded: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Column(children: []),
          ),
        ),
      ),
    );
  }

  Widget _mainRow(BuildContext context) {
    return Row(
      children: [
        CircularIconContainer(icon: Icon(FlutterRemix.calendar_check_line)),
        Text('${challengePresetToText[preset]!}')
      ],
    );
  }
}
