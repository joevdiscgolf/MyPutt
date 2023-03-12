import 'package:flutter/material.dart';
import 'package:myputt/utils/constants.dart';
import 'package:myputt/utils/enums.dart';
import 'package:myputt/utils/string_extension.dart';

class ChallengeCategoryV2Tab extends StatelessWidget {
  const ChallengeCategoryV2Tab({Key? key, required this.challengeCategory})
      : super(key: key);

  final ChallengeCategory challengeCategory;

  @override
  Widget build(BuildContext context) {
    return Text(
      (challengeCategoryToName[challengeCategory] ?? '').capitalize(),
      style: Theme.of(context)
          .textTheme
          .titleMedium
          ?.copyWith(fontWeight: FontWeight.w600),
    );
  }
}
