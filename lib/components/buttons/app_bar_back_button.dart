import 'package:flutter/material.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';
import 'package:myputt/utils/colors.dart';

class AppBarBackButton extends StatelessWidget {
  const AppBarBackButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Bounceable(
      child: Container(
        height: 32,
        width: 32,
        padding: const EdgeInsets.only(right: 2),
        alignment: Alignment.center,
        decoration: BoxDecoration(
            color: MyPuttColors.gray[50]!, shape: BoxShape.circle),
        child: const Center(
          child: Icon(
            FlutterRemix.arrow_left_s_line,
            color: MyPuttColors.black,
            size: 26,
          ),
        ),
      ),
      onTap: () {
        Vibrate.feedback(FeedbackType.light);
        Navigator.of(context).pop();
      },
    );
  }
}
