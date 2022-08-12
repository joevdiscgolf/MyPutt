import 'package:flutter/material.dart';
import 'package:myputt/utils/colors.dart';
import 'package:myputt/utils/layout_helpers.dart';

class ChallengesScreenAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  const ChallengesScreenAppBar({Key? key}) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(64);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: hasTopPadding(context) ? 48 : 24),
      child: Text(
        'Challenges',
        style: Theme.of(context)
            .textTheme
            .headline6
            ?.copyWith(fontSize: 28, color: MyPuttColors.blue),
        textAlign: TextAlign.center,
      ),
    );
  }
}
