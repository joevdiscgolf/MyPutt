import 'package:flutter/material.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';
import 'package:myputt/components/misc/circular_icon_container.dart';
import 'package:myputt/utils/colors.dart';

class LifetimeStatRow extends StatelessWidget {
  const LifetimeStatRow(
      {Key? key,
      required this.icon,
      required this.title,
      required this.subtitle})
      : super(key: key);

  final Widget icon;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Bounceable(
      onTap: () {
        Vibrate.feedback(FeedbackType.light);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(color: MyPuttColors.gray[50], boxShadow: [
          BoxShadow(
              offset: const Offset(0, 2),
              blurRadius: 2,
              color: MyPuttColors.gray[400]!)
        ]),
        child: Row(
          children: [
            CircularIconContainer(
              icon: icon,
              size: 60,
              padding: 12,
            ),
            const SizedBox(
              width: 16,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context)
                      .textTheme
                      .headline6
                      ?.copyWith(fontSize: 16, color: MyPuttColors.gray[800]),
                ),
                const SizedBox(
                  height: 4,
                ),
                Text(
                  subtitle,
                  style: Theme.of(context)
                      .textTheme
                      .headline6
                      ?.copyWith(fontSize: 12, color: MyPuttColors.gray[400]),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
