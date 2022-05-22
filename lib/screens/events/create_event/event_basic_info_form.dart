import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:myputt/components/buttons/my_putt_button.dart';
import 'package:myputt/screens/auth/enter_details_screen.dart';
import 'package:myputt/screens/events/create_event/components/buttons.dart';
import 'package:myputt/screens/events/create_event/event_details_form.dart';
import 'package:myputt/utils/colors.dart';

import 'components/create_event_header.dart';

class EventBasicInfoForm extends StatefulWidget {
  const EventBasicInfoForm({Key? key}) : super(key: key);

  static String routeName = '/enter_details';

  @override
  State<EventBasicInfoForm> createState() => _EventBasicInfoFormState();
}

class _EventBasicInfoFormState extends State<EventBasicInfoForm> {
  final formKey = GlobalKey<FormState>();
  final TextEditingController _eventNameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  String? _eventName;
  String? _description;

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
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                DetailsTextField(
                    iconData: FlutterRemix.at_line,
                    textEditingController: _eventNameController,
                    hint: 'Name of event',
                    enabled: true,
                    onChanged: () {}),
                const SizedBox(height: 16),
                DetailsTextField(
                    iconData: FlutterRemix.at_line,
                    textEditingController: _descriptionController,
                    hint: 'Description (optional)',
                    enabled: true,
                    onChanged: () {}),
              ],
            ),
          ),
          ContinueButton(
            onPressed: () => Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => const EventDetailsForm())),
          ),
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
}
