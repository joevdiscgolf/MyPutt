import 'package:flutter/material.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:myputt/components/misc/default_profile_circle.dart';
import 'package:myputt/data/types/putting_session.dart';
import 'package:myputt/data/types/users/myputt_user.dart';
import 'dialogs/send_challenge_dialog.dart';

class UserListItem extends StatelessWidget {
  const UserListItem({Key? key, required this.user, required this.session})
      : super(key: key);

  final PuttingSession session;
  final MyPuttUser user;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        showDialog(
            context: context,
            builder: (context) =>
                SendChallengeDialog(recipientUser: user, session: session));
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            border: Border.all(width: 2, color: Colors.grey[400]!)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            const Flexible(
              flex: 1,
              child: DefaultProfileCircle(),
            ),
            Flexible(
                flex: 2,
                child: Column(
                  children: [
                    Text(
                      'Username',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: Colors.black, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 5),
                    FittedBox(child: Text(user.username)),
                  ],
                )),
            Flexible(
                flex: 2,
                child: Column(
                  children: [
                    Text(
                      'Display name',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: Colors.black, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 5),
                    FittedBox(child: Text(user.displayName)),
                  ],
                )),
            const Flexible(
                flex: 2, child: Icon(FlutterRemix.arrow_right_s_line))
          ],
        ),
      ),
    );
  }
}
