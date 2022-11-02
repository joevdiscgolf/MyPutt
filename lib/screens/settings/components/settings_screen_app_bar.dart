import 'package:flutter/material.dart';
import 'package:myputt/components/buttons/app_bar_back_button.dart';
import 'package:myputt/utils/colors.dart';
import 'package:myputt/utils/layout_helpers.dart';

class SettingsScreenAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  const SettingsScreenAppBar({Key? key}) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(64);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: hasTopPadding(context) ? 48 : 24),
      child: Row(
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.only(left: 8),
              alignment: Alignment.centerLeft,
              child: const AppBarBackButton(),
            ),
          ),
          Text(
            'Settings',
            style: Theme.of(context)
                .textTheme
                .headline6
                ?.copyWith(fontSize: 28, color: MyPuttColors.blue),
          ),
          Expanded(child: Container()),
        ],
      ),
    );
  }
}
