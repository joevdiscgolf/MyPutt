import 'package:flutter/material.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:myputt/components/buttons/my_putt_button.dart';
import 'package:myputt/components/panels/bottom_sheet_panel.dart';
import 'package:myputt/components/panels/panel_header.dart';
import 'package:myputt/data/types/challenges/generated_challenge_item.dart';
import 'package:myputt/screens/auth/components/custom_field.dart';
import 'package:myputt/screens/challenge/components/dialogs/components/structure_description_row.dart';
import 'package:myputt/utils/colors.dart';

class CreateChallengeStructurePanel extends StatefulWidget {
  const CreateChallengeStructurePanel({Key? key}) : super(key: key);

  @override
  State<CreateChallengeStructurePanel> createState() =>
      _CreateChallengeStructurePanelState();
}

class _CreateChallengeStructurePanelState
    extends State<CreateChallengeStructurePanel> {
  List<GeneratedChallengeItem> _generatedChallengeItems = [];

  final TextEditingController _distanceController = TextEditingController();
  final TextEditingController _setLengthController = TextEditingController();
  final TextEditingController _setCountController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BottomSheetPanel(
      child: Column(
        children: [
          const PanelHeader(title: 'Edit structure'),
          const SizedBox(height: 24),
          _descriptionRow(context),
          _inputRow(context),
          ..._generatedChallengeItems
              .map((item) =>
                  StructureDescriptionRow(generatedChallengeItem: item))
              .toList(),
          const SizedBox(height: 12),
          MyPuttButton(
            title: 'Add',
            onPressed: () {},
            iconData: FlutterRemix.add_line,
            width: MediaQuery.of(context).size.width / 2,
          ),
        ],
      ),
    );
  }

  Widget _descriptionRow(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            'Dist',
            textAlign: TextAlign.center,
            style: Theme.of(context)
                .textTheme
                .headline6
                ?.copyWith(color: MyPuttColors.darkGray),
          ),
        ),
        Expanded(
          child: Text(
            '#Putts',
            textAlign: TextAlign.center,
            style: Theme.of(context)
                .textTheme
                .headline6
                ?.copyWith(color: MyPuttColors.darkGray),
          ),
        ),
        Expanded(
          child: Text(
            '#Sets',
            textAlign: TextAlign.center,
            style: Theme.of(context)
                .textTheme
                .headline6
                ?.copyWith(color: MyPuttColors.darkGray),
          ),
        ),
      ],
    );
  }

  Widget _inputRow(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: CustomField(
            controller: _distanceController,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: CustomField(controller: _setLengthController),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: CustomField(controller: _setCountController),
        ),
      ],
    );
  }
}
