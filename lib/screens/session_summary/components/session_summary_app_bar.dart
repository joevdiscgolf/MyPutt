import 'package:flutter/material.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:flutter/services.dart';
import 'package:mixpanel_flutter/mixpanel_flutter.dart';
import 'package:myputt/components/buttons/app_bar_back_button.dart';
import 'package:myputt/locator.dart';
import 'package:myputt/utils/colors.dart';
import 'package:myputt/utils/layout_helpers.dart';

class SessionSummaryAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  const SessionSummaryAppBar({
    Key? key,
    required this.showDeleteDialog,
    required this.onShareChallenge,
  }) : super(key: key);

  final Function showDeleteDialog;
  final Function onShareChallenge;

  @override
  Size get preferredSize => const Size.fromHeight(56);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: MediaQuery.of(context).viewPadding.top),
      child: Row(
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.only(left: 16),
              alignment: Alignment.centerLeft,
              child: const AppBarBackButton(),
            ),
          ),
          Text(
            'Session',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontSize: 20,
                  color: MyPuttColors.blue,
                  fontWeight: FontWeight.bold,
                ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(right: 24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  _circleIconButton(
                    context,
                    FlutterRemix.sword_line,
                    onPressed: () {
                      HapticFeedback.lightImpact();
                      locator
                          .get<Mixpanel>()
                          .track('Session Row Challenge Button Pressed');
                      onShareChallenge();
                    },
                  ),
                  const SizedBox(width: 12),
                  _circleIconButton(
                    context,
                    FlutterRemix.delete_bin_7_line,
                    onPressed: () {
                      HapticFeedback.lightImpact();
                      showDeleteDialog();
                    },
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _circleIconButton(
    BuildContext context,
    IconData iconData, {
    required Function onPressed,
  }) {
    return Bounceable(
      onTap: () {
        onPressed();
      },
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: MyPuttColors.white,
          boxShadow: standardBoxShadow(),
          shape: BoxShape.circle,
        ),
        child: Container(
          padding: const EdgeInsets.all(8),
          color: Colors.transparent,
          child: Icon(iconData, size: 20),
        ),
      ),
    );
  }
}
