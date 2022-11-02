import 'package:flutter/material.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:myputt/screens/settings/components/confirm_delete_user_panel.dart';
import 'package:myputt/screens/settings/components/settings_row.dart';
import 'package:myputt/screens/settings/components/settings_screen_app_bar.dart';
import 'package:myputt/utils/colors.dart';
import 'package:myputt/utils/panel_helpers.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const SettingsScreenAppBar(),
      body: _mainBody(context),
    );
  }

  Widget _mainBody(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SettingsRow(
            icon: const Icon(FlutterRemix.delete_bin_line,
                color: MyPuttColors.red),
            title: 'Delete account',
            subtitle: 'Permanently delete your account and all its data.',
            onPressed: () {
              displayBottomSheet(
                context,
                const ConfirmDeleteUserPanel(),
              );
            },
          )
        ],
      ),
    );
  }
}
