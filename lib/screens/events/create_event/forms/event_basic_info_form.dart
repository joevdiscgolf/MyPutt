import 'package:flutter/material.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:myputt/screens/auth/enter_details_screen.dart';

class EventBasicInfoForm extends StatelessWidget {
  const EventBasicInfoForm({
    Key? key,
    required this.eventNameController,
    required this.eventDescriptionController,
  }) : super(key: key);

  final TextEditingController eventNameController;
  final TextEditingController eventDescriptionController;

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
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        DetailsTextField(
          iconData: FlutterRemix.at_line,
          hint: 'Event name (required)',
          enabled: true,
          textEditingController: eventNameController,
        ),
        const SizedBox(height: 48),
        DetailsTextField(
          iconData: FlutterRemix.at_line,
          hint: 'Description (optional)',
          enabled: true,
          textEditingController: eventDescriptionController,
        ),
      ],
    );
  }
}
