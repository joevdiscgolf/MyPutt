import 'dart:math';
import 'package:flutter/material.dart';
import 'package:another_flushbar/flushbar.dart';
import 'package:myputt/utils/colors.dart';

void showFlushBar(BuildContext context, String message, double maxWidth,
    {Widget? icon}) async {
  Flushbar(
    boxShadows: const [
      BoxShadow(
          color: MyPuttColors.shadowColor,
          offset: Offset(0.0, 6.0), //(x
          blurRadius: 20 // ,y)
          ),
    ],
    maxWidth: maxWidth,
    margin: const EdgeInsets.symmetric(horizontal: 20),
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
    borderRadius: BorderRadius.circular(48),
    backgroundColor: Colors.white,
    isDismissible: true,
    duration: const Duration(seconds: 3),
    animationDuration: const Duration(milliseconds: 400),
    forwardAnimationCurve: const SpringCurve(),
    reverseAnimationCurve: Curves.fastOutSlowIn,
    messageText: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (icon != null) SizedBox(width: 30, child: icon),
          if (icon != null)
            const SizedBox(
              width: 4,
            ),
          Text(
            message,
            style: Theme.of(context).textTheme.subtitle2!.copyWith(
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                ),
          )
        ]),
  ).show(context);
}

class SpringCurve extends Curve {
  const SpringCurve({this.a = 0.25, this.w = 2.5});

  final double a;
  final double w;

  @override
  double transformInternal(double t) {
    return -(pow(e, -t / a)) * cos(t * w) + 1;
  }
}
