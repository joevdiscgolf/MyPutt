import 'package:flutter/material.dart';

class MyPuttButton extends StatelessWidget {
  const MyPuttButton(
      {Key? key,
      required this.title,
      required this.onPressed,
      this.iconData,
      this.height = 50,
      this.color = Colors.blue})
      : super(key: key);

  final String title;
  final Function onPressed;
  final IconData? iconData;
  final double height;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: ElevatedButton(
          style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(48)),
              primary: color,
              shadowColor: Colors.transparent,
              enableFeedback: true),
          child: Center(
              child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (iconData != null) ...[
                Icon(iconData),
                const SizedBox(width: 10)
              ],
              Text(title),
            ],
          )),
          onPressed: () => onPressed()),
    );
  }
}
