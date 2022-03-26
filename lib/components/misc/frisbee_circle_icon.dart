import 'package:flutter/material.dart';
import 'package:myputt/data/types/users/frisbee_avatar.dart';
import 'package:myputt/utils/colors.dart';
import 'package:myputt/utils/constants.dart';

class FrisbeeCircleIcon extends StatelessWidget {
  const FrisbeeCircleIcon(
      {Key? key, this.frisbeeAvatar, this.size = 32, this.iconSize = 40})
      : super(key: key);

  final FrisbeeAvatar? frisbeeAvatar;
  final double size;
  final double iconSize;

  @override
  Widget build(BuildContext context) {
    final Color backgroundColor = frisbeeAvatar?.backgroundColorHex != null
        ? HexColor(frisbeeAvatar!.backgroundColorHex)
        : MyPuttColors.blue;
    final String frisbeeImgSrc =
        frisbeeIconColorToSrc[frisbeeAvatar?.frisbeeIconColor] ??
            redFrisbeeIconSrc;
    return Container(
      height: size,
      width: size,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(
            colors: [backgroundColor, MyPuttColors.white],
            end: const Alignment(3, 0),
          )),
      child: Center(
          child: Image(
              height: iconSize,
              width: iconSize,
              image: AssetImage(frisbeeImgSrc))),
    );
  }
}
