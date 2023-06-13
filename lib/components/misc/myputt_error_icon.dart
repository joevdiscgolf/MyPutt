import 'package:flutter/material.dart';
import 'package:myputt/utils/colors.dart';

class MyPuttErrorIcon extends StatelessWidget {
  const MyPuttErrorIcon({Key? key, this.size = 24, this.fontSize = 18})
      : super(key: key);

  final double size;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      height: size,
      width: size,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: MyPuttColors.red,
      ),
      child: Text(
        '!',
        style: TextStyle(
          color: MyPuttColors.white,
          fontSize: fontSize,
          fontWeight: FontWeight.w600,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}
