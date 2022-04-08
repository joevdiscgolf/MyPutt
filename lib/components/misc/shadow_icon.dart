import 'package:flutter/material.dart';
import 'package:myputt/utils/colors.dart';

class ShadowIcon extends StatelessWidget {
  const ShadowIcon({Key? key, required this.icon}) : super(key: key);

  final Widget icon;

  @override
  Widget build(BuildContext context) {
    return Stack(
        alignment: Alignment.bottomCenter,
        children: [_shadowContainer(context), icon]);
  }

  Widget _shadowContainer(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(0),
      padding: const EdgeInsets.all(0),
      width: 80,
      height: 8,
      decoration: BoxDecoration(
          color: MyPuttColors.gray[200],
          borderRadius: BorderRadius.all(const Radius.elliptical(600, 80))),
    );
  }
}
