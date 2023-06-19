import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:myputt/components/dialogs/confirm_dialog.dart';
import 'package:myputt/locator.dart';
import 'package:myputt/models/data/challenges/putting_challenge.dart';
import 'package:myputt/repositories/challenges_repository.dart';
import 'package:myputt/utils/colors.dart';

class DeleteChallengeButton extends StatelessWidget {
  const DeleteChallengeButton({Key? key, required this.challenge})
      : super(key: key);

  final PuttingChallenge challenge;

  @override
  Widget build(BuildContext context) {
    return Bounceable(
      onTap: () {
        showDialog(
          context: context,
          builder: (context) {
            return ConfirmDialog(
              title: 'Delete challenge',
              icon: const Icon(
                FlutterRemix.close_line,
                size: 40,
                color: MyPuttColors.red,
              ),
              actionPressed: () {
                if (kDebugMode) {
                  locator
                      .get<ChallengesRepository>()
                      .debugDeleteChallenge(challenge);
                }
              },
              buttonlabel: 'Delete',
              buttonColor: MyPuttColors.red,
            );
          },
        );
      },
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: MyPuttColors.gray[400]!),
          color: MyPuttColors.white,
        ),
        height: 32,
        alignment: Alignment.center,
        child: const Icon(
          FlutterRemix.close_line,
          color: Colors.red,
        ),
      ),
    );
  }
}
