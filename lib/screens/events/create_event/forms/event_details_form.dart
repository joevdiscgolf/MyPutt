import 'package:flutter/material.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:myputt/components/buttons/my_putt_button.dart';
import 'package:myputt/components/panels/info_panel.dart';
import 'package:myputt/data/types/events/event_enums.dart';
import 'package:myputt/screens/events/create_event/components/create_event_header.dart';
import 'package:myputt/screens/events/create_event/components/dialogs/add_sponsor_dialog.dart';
import 'package:myputt/screens/events/create_event/components/select_divisions_panel.dart';
import 'package:myputt/screens/events/create_event/components/selector_row.dart';
import 'package:myputt/utils/colors.dart';
import 'package:myputt/utils/panel_helpers.dart';

class EventDetailsForm extends StatelessWidget {
  const EventDetailsForm({
    Key? key,
    required this.selectedDivisions,
    required this.signatureVerification,
    required this.onDivisionSelected,
    required this.updateSignatureVerification,
  }) : super(key: key);

  final List<Division> selectedDivisions;
  final bool signatureVerification;

  final Function(List<Division>) onDivisionSelected;
  final Function(bool) updateSignatureVerification;

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
              signatureVerificationHeader(context),
              const SizedBox(height: 16),
              signatureVerificationRow(context),
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
                          onDivisionSelected(divisions)),
                ),
              ),
              const SizedBox(height: 32),
              SelectorRow(
                icon: const Icon(FlutterRemix.currency_line),
                text: 'Add sponsor (optional)',
                onPressed: () => showDialog(
                  context: context,
                  builder: (BuildContext context) => const AddSponsorDialog(),
                ),
              )
            ],
          ),
        ),
      ],
    );
  }

  Widget signatureVerificationHeader(BuildContext context) {
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

  Widget signatureVerificationRow(BuildContext context) {
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
