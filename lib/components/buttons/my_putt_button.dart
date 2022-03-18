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
      this.width,
      this.color = Colors.blue,
      this.iconColor = Colors.white,
      this.textColor = Colors.white,
      this.textSize = 16,
      this.padding = const EdgeInsets.all(8),
      this.shadowColor})
      : super(key: key);

  final String title;
  final Function onPressed;
  final IconData? iconData;
  final double height;
  final double? width;
  final Color color;
  final Color iconColor;
  final Color textColor;
  final Color? shadowColor;
  final double textSize;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    // print(width);
    return Bounceable(
      onTap: () {
        Vibrate.feedback(FeedbackType.light);
        onPressed();
      },
      child: Container(
        height: height,
        width: width,
        padding: padding,
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
                offset: const Offset(0, 2),
                color: shadowColor ?? Colors.transparent,
                blurRadius: 4)
          ],
          borderRadius: BorderRadius.circular(24),
          color: color,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (iconData != null) ...[
              Icon(
                iconData,
                color: iconColor,
              ),
              const SizedBox(width: 10)
            ],
            Text(title,
                style: Theme.of(context)
                    .textTheme
                    .headline6
                    ?.copyWith(color: textColor, fontSize: textSize)),
          ],
        ),
      ),
    );
  }
}
