import 'package:flutter/material.dart';
import 'package:myputt/utils/colors.dart';

class FrisbeeCircleIcon extends StatelessWidget {
  const FrisbeeCircleIcon(
      {Key? key,
      this.redIcon = false,
      this.backGroundColor = MyPuttColors.red,
      this.size = 32,
      this.iconSize = 40})
      : super(key: key);

  final bool redIcon;
  final Color backGroundColor;
  final double size;
  final double iconSize;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: size,
      width: size,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(
            colors: [backGroundColor, MyPuttColors.white],
            end: const Alignment(3, 0),
          )),
      child: Center(
          child: Image(
              height: iconSize,
              width: iconSize,
              image: AssetImage(redIcon
                  ? 'assets/frisbeeEmojiCutoutRed.png'
                  : 'assets/frisbeeEmojiCutout.png'))),
    );
  }
}
