import 'package:flutter/material.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:flutter/services.dart';
import 'package:mixpanel_flutter/mixpanel_flutter.dart';
import 'package:myputt/locator.dart';
import 'package:myputt/screens/challenge/components/dialogs/select_preset_dialog.dart';
import 'package:myputt/utils/colors.dart';
import 'package:myputt/utils/layout_helpers.dart';

class NewChallengeButton extends StatelessWidget {
  const NewChallengeButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8, right: 8),
      padding: const EdgeInsets.all(8.0),
      child: Bounceable(
        onTap: () {
          HapticFeedback.lightImpact();
          locator
              .get<Mixpanel>()
              .track('Challenges Screen New Challenge Button Pressed');
          showDialog(
            context: context,
            builder: (BuildContext context) => const SelectPresetDialog(),
          );
        },
        child: Container(
          alignment: Alignment.center,
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: MyPuttColors.gray[800]!,
            boxShadow: standardBoxShadow(),
          ),
          child: const Icon(
            FlutterRemix.add_fill,
            color: MyPuttColors.white,
            size: 32,
          ),
        ),
      ),
    );
  }
}
