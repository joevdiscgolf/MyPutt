import 'package:flutter/material.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';
import 'package:myputt/utils/colors.dart';

class ExitButton extends StatelessWidget {
  const ExitButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Bounceable(
      child: Container(
        height: 32,
        width: 32,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: MyPuttColors.gray[50],
        ),
        child: Icon(
          FlutterRemix.close_line,
          color: MyPuttColors.gray[800]!,
          size: 20,
        ),
      ),
      onTap: () {
        Vibrate.feedback(FeedbackType.light);
        Navigator.of(context).pop();
      },
    );
  }
}
