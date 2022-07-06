import 'package:flutter/material.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';
import 'package:myputt/utils/colors.dart';

class ChallengeRecordAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  const ChallengeRecordAppBar({Key? key}) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(40);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      shadowColor: Colors.transparent,
      leading: IconButton(
        onPressed: () {
          Vibrate.feedback(FeedbackType.light);
          Navigator.pop(context);
        },
        icon: const Icon(
          FlutterRemix.arrow_left_s_line,
          color: MyPuttColors.darkGray,
        ),
      ),
    );
  }
}
