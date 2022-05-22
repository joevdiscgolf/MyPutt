import 'package:flutter/material.dart';
import 'package:myputt/utils/colors.dart';

class CreateEventHeader extends StatelessWidget {
  const CreateEventHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Create an event',
          style: Theme.of(context)
              .textTheme
              .headline6
              ?.copyWith(color: MyPuttColors.blue, fontSize: 24),
        ),
        const SizedBox(
          height: 16,
        ),
        Text(
          'Please fill out the information below',
          style: Theme.of(context)
              .textTheme
              .headline6
              ?.copyWith(fontSize: 16, color: MyPuttColors.gray[400]),
        ),
      ],
    );
  }
}
