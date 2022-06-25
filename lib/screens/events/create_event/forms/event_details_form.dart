import 'package:flutter/material.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:myputt/components/buttons/my_putt_button.dart';
import 'package:myputt/components/panels/info_panel.dart';
import 'package:myputt/models/data/challenges/generated_challenge_item.dart';
import 'package:myputt/models/data/events/event_enums.dart';
import 'package:myputt/screens/events/create_event/components/panels/create_challenge_structure_panel.dart';
import 'package:myputt/screens/events/create_event/components/panels/select_divisions_panel.dart';
import 'package:myputt/screens/events/create_event/components/selector_row.dart';
import 'package:myputt/utils/colors.dart';
import 'package:myputt/utils/panel_helpers.dart';

class EventDetailsForm extends StatelessWidget {
  const EventDetailsForm({
    Key? key,
    required this.selectedDivisions,
    required this.signatureVerification,
    required this.instructions,
    required this.onDivisionSelected,
    required this.updateSignatureVerification,
    required this.updateChallengeInstructions,
  }) : super(key: key);

  final List<Division> selectedDivisions;
  final bool signatureVerification;
  final List<GeneratedChallengeInstruction> instructions;
  final Function(List<Division>) onDivisionSelected;
  final Function(bool) updateSignatureVerification;
  final Function(List<GeneratedChallengeInstruction>)
      updateChallengeInstructions;

  static String routeName = '/enter_details';

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 24, right: 24, bottom: 16),
      child: Form(
        child: _mainBody(context),
      ),
    );
  }

  Widget _mainBody(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _signatureVerificationHeader(context),
              const SizedBox(height: 16),
              _signatureVerificationRow(context),
              const SizedBox(height: 32),
              SelectorRow(
                icon: const Icon(FlutterRemix.user_add_line),
                text:
                    'Select divisions ${selectedDivisions.isNotEmpty ? '(${selectedDivisions.length})' : '(required)'}',
                onPressed: () => displayBottomSheet(
                  context,
                  SelectDivisionsPanel(
                    initialDivisions: selectedDivisions,
                    onDivisionSelected: (List<Division> divisions) =>
                        onDivisionSelected(divisions),
                  ),
                ),
              ),
              const SizedBox(height: 32),
              SelectorRow(
                icon: const Icon(FlutterRemix.stack_line),
                text: instructions.isEmpty
                    ? 'Enter event layout (required)'
                    : 'Event layout (${instructions.length})',
                onPressed: () => displayBottomSheet(
                  context,
                  CreateChallengeStructurePanel(
                      initialInstructions: instructions,
                      updateInstructions:
                          (List<GeneratedChallengeInstruction> instructions) =>
                              updateChallengeInstructions(instructions)),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _signatureVerificationHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Expanded(
          child: Text(
            'Signature verification\n(recommended)',
            style: Theme.of(context).textTheme.headline6?.copyWith(
                  color: MyPuttColors.darkGray,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
          ),
        ),
        IconButton(
            onPressed: () => displayBottomSheet(
                context,
                const InfoPanel(
                    headerText: 'Signature verification',
                    bodyText:
                        'Forces participants to record the signature of a fellow competitor to validate their results and ensure the integrity of the competition.')),
            icon: const Icon(FlutterRemix.information_line))
      ],
    );
  }

  Widget _signatureVerificationRow(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: MyPuttButton(
            title: 'No',
            onPressed: () => updateSignatureVerification(false),
            borderRadius: 4,
            color:
                signatureVerification ? Colors.transparent : MyPuttColors.blue,
            textColor: signatureVerification ? Colors.blue : Colors.white,
            borderColor:
                signatureVerification ? MyPuttColors.blue : Colors.transparent,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: MyPuttButton(
            title: 'Yes',
            onPressed: () => updateSignatureVerification(true),
            borderRadius: 4,
            color:
                signatureVerification ? MyPuttColors.blue : Colors.transparent,
            textColor:
                signatureVerification ? MyPuttColors.white : MyPuttColors.blue,
            borderColor:
                signatureVerification ? Colors.transparent : MyPuttColors.blue,
          ),
        )
      ],
    );
  }
}
