import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:myputt/components/buttons/my_putt_button.dart';
import 'package:myputt/components/panels/info_panel.dart';
import 'package:myputt/data/types/events/event_enums.dart';
import 'package:myputt/screens/events/create_event/components/buttons.dart';
import 'package:myputt/screens/events/create_event/components/create_event_header.dart';
import 'package:myputt/screens/events/create_event/components/dialogs/add_sponsor_dialog.dart';
import 'package:myputt/screens/events/create_event/components/select_divisions_panel.dart';
import 'package:myputt/screens/events/create_event/components/selector_row.dart';
import 'package:myputt/utils/colors.dart';
import 'package:myputt/utils/panel_helpers.dart';

class EventDetailsForm extends StatefulWidget {
  const EventDetailsForm({Key? key}) : super(key: key);

  static String routeName = '/enter_details';

  @override
  State<EventDetailsForm> createState() => _EventDetailsFormState();
}

class _EventDetailsFormState extends State<EventDetailsForm> {
  final formKey = GlobalKey<FormState>();
  final TextEditingController _eventNameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  List<Division> _selectedDivisions = [];
  bool _signatureVerification = true;

  @override
  void dispose() {
    _eventNameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        SystemChannels.textInput.invokeMethod('TextInput.hide');
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          backgroundColor: Colors.white,
          shadowColor: Colors.transparent,
          leading: IconButton(
            color: Colors.transparent,
            icon: const Icon(
              FlutterRemix.arrow_left_s_line,
              color: Colors.black,
            ),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.only(left: 32, right: 32, bottom: 16),
          child: Form(
            key: formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                const CreateEventHeader(),
                const SizedBox(
                  height: 24,
                ),
                _mainBody(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _mainBody(BuildContext context) {
    return Expanded(
      child: Column(
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
                      'Select divisions ${_selectedDivisions.isNotEmpty ? '(${_selectedDivisions.length})' : ''}',
                  onPressed: () => displayBottomSheet(
                    context,
                    SelectDivisionsPanel(
                        initialDivisions: _selectedDivisions,
                        onDivisionSelected: (List<Division> divisions) {
                          setState(() => _selectedDivisions = divisions);
                        }),
                  ),
                ),
                const SizedBox(height: 32),
                SelectorRow(
                  icon: const Icon(FlutterRemix.currency_line),
                  text:
                      'Add sponsor (optional) ${_selectedDivisions.isNotEmpty ? '(${_selectedDivisions.length})' : ''}',
                  onPressed: () => showDialog(
                      context: context,
                      builder: (BuildContext context) =>
                          const AddSponsorDialog()),
                )
              ],
            ),
          ),
          ContinueButton(onPressed: () {}),
          const SizedBox(
            height: 16,
          ),
          const CancelButton(),
          const SizedBox(
            height: 16,
          ),
        ],
      ),
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
            onPressed: () => setState(() => _signatureVerification = false),
            borderRadius: 4,
            color:
                _signatureVerification ? Colors.transparent : MyPuttColors.blue,
            textColor: _signatureVerification ? Colors.blue : Colors.white,
            borderColor:
                _signatureVerification ? MyPuttColors.blue : Colors.transparent,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: MyPuttButton(
            title: 'Yes',
            onPressed: () => setState(() => _signatureVerification = true),
            borderRadius: 4,
            color:
                _signatureVerification ? MyPuttColors.blue : Colors.transparent,
            textColor:
                _signatureVerification ? MyPuttColors.white : MyPuttColors.blue,
            borderColor:
                _signatureVerification ? Colors.transparent : MyPuttColors.blue,
          ),
        )
      ],
    );
  }
}
