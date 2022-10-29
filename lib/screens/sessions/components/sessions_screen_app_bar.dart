import 'package:flutter/material.dart';
import 'package:myputt/models/data/sessions/putting_session.dart';
import 'package:myputt/utils/colors.dart';
import 'package:myputt/utils/layout_helpers.dart';

class SessionsScreenAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  const SessionsScreenAppBar({Key? key, required this.allSessions})
      : super(key: key);

  final List<PuttingSession> allSessions;

  @override
  Size get preferredSize => const Size.fromHeight(100);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: hasTopPadding(context) ? 48 : 24),
      child: Column(
        children: [
          Text(
            'Sessions',
            style: Theme.of(context)
                .textTheme
                .headline6
                ?.copyWith(fontSize: 28, color: MyPuttColors.blue),
          ),
          const SizedBox(height: 8),
          Text(
            allSessions.isEmpty
                ? 'No sessions yet'
                : '${allSessions.length} total',
            style: Theme.of(context)
                .textTheme
                .headline6!
                .copyWith(fontSize: 16, color: MyPuttColors.gray[400]),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
