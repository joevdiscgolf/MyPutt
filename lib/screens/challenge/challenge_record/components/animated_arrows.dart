import 'package:flutter/material.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';
import 'package:myputt/utils/colors.dart';

class AnimatedArrows extends StatefulWidget {
  const AnimatedArrows({Key? key}) : super(key: key);

  @override
  State<AnimatedArrows> createState() => _AnimatedArrowsState();
}

class _AnimatedArrowsState extends State<AnimatedArrows>
    with TickerProviderStateMixin {
  late final List<AnimationController> controllers;
  late final List<Animation<double>> animations;

  List<bool> disposed = [false, false, false, false, false];

  final double minSize = 20;
  final double maxSize = 30;

  @override
  void initState() {
    controllers = [
      for (int i = 0; i < 4; i++)
        AnimationController(
            vsync: this,
            duration: const Duration(milliseconds: 750),
            reverseDuration: const Duration(milliseconds: 300))
    ];

    List<CurvedAnimation> curvedAnimations = controllers
        .map((controller) => CurvedAnimation(
            parent: controller,
            curve: Curves.decelerate,
            reverseCurve: Curves.decelerate))
        .toList();

    animations = curvedAnimations
        .asMap()
        .entries
        .map((entry) =>
            Tween<double>(begin: minSize, end: maxSize).animate(entry.value)
              ..addStatusListener((status) {
                if (status == AnimationStatus.completed) {
                  controllers[entry.key].reverse();
                }
                if (status == AnimationStatus.dismissed) {
                  Future.delayed(const Duration(milliseconds: 5000), () {
                    controllers[entry.key].forward();
                  });
                }
              }))
        .toList();

    // startAnimation();

    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    for (int index = 0; index < 4; index++) {
      disposed[index] = true;
      controllers[index].dispose();
    }
    super.dispose();
  }

  void startAnimation() async {
    int index = 0;
    for (AnimationController controller in controllers) {
      await Future.delayed(const Duration(milliseconds: 150), () {
        if (!disposed[index]) {
          controller.forward();
        }
      });
      index += 1;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: 125,
        child: Bounceable(
          onTap: () {
            Vibrate.feedback(FeedbackType.light);
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              for (int i = 0; i < 4; i++)
                AnimatedBuilder(
                  builder: (BuildContext context, Widget? child) {
                    return SizedBox(
                      // width: 25,
                      child: Transform.translate(
                        offset: Offset(animations[i].value - 20, 0),
                        child: const Icon(
                          FlutterRemix.arrow_right_s_line,
                          color: MyPuttColors.lightBlue,
                          // size: animations[i].value,
                        ),
                      ),
                    );
                  },
                  animation: animations[i],
                )
            ],
          ),
        ));
  }
}
