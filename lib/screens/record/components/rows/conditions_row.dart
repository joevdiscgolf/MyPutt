import 'package:flutter/material.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';
import 'package:myputt/components/buttons/my_putt_button.dart';
import 'package:myputt/components/misc/circular_icon_container.dart';
import 'package:myputt/utils/colors.dart';

class ConditionsRow extends StatelessWidget {
  const ConditionsRow(
      {Key? key,
      required this.iconData,
      required this.onPressed,
      required this.label})
      : super(key: key);

  final IconData iconData;
  final Function onPressed;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Bounceable(
      onTap: () {
        Vibrate.feedback(FeedbackType.light);
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 2),
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
              icon: Icon(
                iconData,
                color: MyPuttColors.blue,
                size: 32,
              ),
              size: 60,
              padding: 12,
            ),
            const SizedBox(
              width: 16,
            ),
            Text(
              label,
              style: Theme.of(context)
                  .textTheme
                  .headline6
                  ?.copyWith(fontSize: 16, color: MyPuttColors.gray[800]),
            ),
            const Spacer(),
            MyPuttButton(
              title: 'label',
              height: 40,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
              onPressed: () => onPressed(),
            )
          ],
        ),
      ),
    );
  }
}
