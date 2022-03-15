import 'package:flutter/material.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';

class MyPuttButton extends StatelessWidget {
  const MyPuttButton(
      {Key? key,
      required this.title,
      required this.onPressed,
      this.iconData,
      this.height = 50,
      this.color = Colors.blue,
      this.iconColor = Colors.white,
      this.textColor = Colors.white,
      this.textSize = 16})
      : super(key: key);

  final String title;
  final Function onPressed;
  final IconData? iconData;
  final double height;
  final Color color;
  final Color iconColor;
  final Color textColor;
  final double textSize;

  @override
  Widget build(BuildContext context) {
    return Bounceable(
      onTap: () {
        Vibrate.feedback(FeedbackType.light);
        onPressed();
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          color: color,
        ),
        height: 50,
        child: Center(
            child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (iconData != null) ...[
              Icon(
                iconData,
                color: iconColor,
              ),
              const SizedBox(width: 10)
            ],
            Text(title,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: textColor,
                    fontWeight: FontWeight.w600,
                    fontSize: textSize)),
          ],
        )),
      ),
    );
  }
}
