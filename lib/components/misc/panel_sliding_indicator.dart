import 'package:flutter/material.dart';
import 'package:myputt/utils/colors.dart';

class PanelSlidingIndicator extends StatelessWidget {
  const PanelSlidingIndicator({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 36,
      height: 4,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(100)),
        color: MyPuttColors.gray[200],
      ),
    );
  }
}
