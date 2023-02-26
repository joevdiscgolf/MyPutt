import 'package:flutter/material.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';
import 'package:myputt/utils/colors.dart';

class ShadowCircularIndicator extends StatelessWidget {
  const ShadowCircularIndicator({
    Key? key,
    this.decimal,
    this.size = 90,
    this.animate = false,
  }) : super(key: key);

  final double? decimal;
  final double size;
  final bool animate;

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Bounceable(
        onTap: () {
          Vibrate.feedback(FeedbackType.light);
        },
        child: Container(
          decoration: BoxDecoration(shape: BoxShape.circle, boxShadow: [
            BoxShadow(
                offset: const Offset(0, 4),
                blurRadius: 6,
                color: MyPuttColors.gray[300]!)
          ]),
          child: SizedBox(
              height: size,
              width: size,
              child: Stack(
                children: [
                  Center(
                    child: Container(
                      height: size,
                      width: size,
                      decoration: const BoxDecoration(
                          shape: BoxShape.circle, color: MyPuttColors.white),
                    ),
                  ),
                  Center(
                    child: SizedBox(
                      height: size,
                      width: size,
                      child: /*animate
                          ? */
                          TweenAnimationBuilder<double>(
                        curve: Curves.decelerate,
                        duration: const Duration(milliseconds: 500),
                        tween: Tween<double>(begin: 0, end: decimal ?? 0),
                        builder: (BuildContext context, double value, _) =>
                            CircularProgressIndicator(
                          strokeWidth: 2,
                          value: value,
                          color: MyPuttColors.lightBlue,
                          backgroundColor: MyPuttColors.gray[200],
                        ),
                      ),
                    ),
                  ),
                  Center(
                      child: SizedBox(
                          child: decimal != null
                              ? Text(
                                  '${(decimal! * 100).toStringAsFixed(0)} %',
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleLarge
                                      ?.copyWith(
                                          color: MyPuttColors.gray[400],
                                          fontSize: 12),
                                )
                              : const Text('-- %')))
                ],
              )),
        ),
      ),
    ]);
  }
}
