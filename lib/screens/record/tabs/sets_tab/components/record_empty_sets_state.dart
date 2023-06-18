import 'package:flutter/material.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:myputt/utils/colors.dart';

class RecordEmptySetsState extends StatelessWidget {
  const RecordEmptySetsState({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(
          FlutterRemix.stack_line,
          color: MyPuttColors.black,
          size: 40,
        ),
        const SizedBox(height: 12),
        Text(
          'No sets yet...',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Text(
          "Your sets will appear here.",
          style: Theme.of(context).textTheme.titleSmall!.copyWith(
                color: MyPuttColors.gray[400],
              ),
          textAlign: TextAlign.center,
        )
      ],
    );
  }
}
