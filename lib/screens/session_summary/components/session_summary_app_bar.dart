import 'package:flutter/material.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';
import 'package:myputt/components/buttons/app_bar_back_button.dart';
import 'package:myputt/utils/colors.dart';

class SessionSummaryAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  const SessionSummaryAppBar({Key? key, required this.showDeleteDialog})
      : super(key: key);

  final Function showDeleteDialog;

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
            child: Container(
              alignment: Alignment.centerRight,
              child: Bounceable(
                onTap: () {
                  Vibrate.feedback(FeedbackType.light);
                  showDeleteDialog();
                },
                child: Container(
                  width: 52,
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.all(20),
                  color: Colors.transparent,
                  child: const Icon(
                    FlutterRemix.delete_bin_7_line,
                    size: 16,
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
