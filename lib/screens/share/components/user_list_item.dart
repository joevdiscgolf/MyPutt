import 'package:flutter/material.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:myputt/components/misc/frisbee_circle_icon.dart';
import 'package:myputt/models/data/sessions/putting_session.dart';
import 'package:myputt/models/data/users/myputt_user.dart';
import 'package:myputt/utils/colors.dart';

class UserListItem extends StatelessWidget {
  const UserListItem(
      {Key? key,
      required this.user,
      required this.session,
      required this.onTap})
      : super(key: key);

  final PuttingSession? session;
  final MyPuttUser user;
  final Function onTap;

  @override
  Widget build(BuildContext context) {
    return Bounceable(
      onTap: () => onTap(),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(color: MyPuttColors.gray[50], boxShadow: [
          BoxShadow(
              offset: const Offset(0, 2),
              blurRadius: 2,
              color: MyPuttColors.gray[400]!)
        ]),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Flexible(
              flex: 4,
              child: FrisbeeCircleIcon(
                size: 60,
                frisbeeAvatar: user.frisbeeAvatar,
              ),
            ),
            Flexible(
                flex: 9,
                child: Column(
                  children: [
                    Text(
                      'Username',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: MyPuttColors.darkGray,
                          fontWeight: FontWeight.bold,
                          fontSize: 16),
                    ),
                    const SizedBox(height: 4),
                    FittedBox(
                        child: Text(user.username,
                            style: Theme.of(context)
                                .textTheme
                                .bodyLarge
                                ?.copyWith(
                                    color: MyPuttColors.darkGray,
                                    fontSize: 12))),
                  ],
                )),
            Flexible(
                flex: 9,
                child: Column(
                  children: [
                    Text(
                      'Display name',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: MyPuttColors.darkGray,
                          fontWeight: FontWeight.bold,
                          fontSize: 16),
                    ),
                    const SizedBox(height: 4),
                    FittedBox(
                        child: Text(user.displayName,
                            style: Theme.of(context)
                                .textTheme
                                .bodyLarge
                                ?.copyWith(
                                    color: MyPuttColors.darkGray,
                                    fontSize: 12))),
                  ],
                )),
            const Flexible(
                flex: 3, child: Icon(FlutterRemix.arrow_right_s_line))
          ],
        ),
      ),
    );
  }
}
