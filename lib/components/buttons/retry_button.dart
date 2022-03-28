import 'dart:math' as math;
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';
import 'package:myputt/utils/colors.dart';

class RetryButton extends StatefulWidget {
  const RetryButton({Key? key, this.repeat = true, required this.onPressed})
      : super(key: key);

  final bool repeat;
  final Function onPressed;

  @override
  _RetryButtonState createState() => _RetryButtonState();
}

class _RetryButtonState extends State<RetryButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;
  late final Animation<double> _rotation;
  late bool _repeat;

  @override
  void initState() {
    _repeat = widget.repeat;
    _animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1200));

    final CurvedAnimation curvedAnimation =
        CurvedAnimation(parent: _animationController, curve: Curves.decelerate);
    _rotation =
        Tween<double>(begin: 0, end: 2 * math.pi).animate(curvedAnimation)
          ..addStatusListener((status) {
            if (status == AnimationStatus.completed && _repeat) {
              _animationController.forward(from: 0);
            }
          });

    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _repeat = widget.repeat;
    return Bounceable(
      onTap: () {
        Vibrate.feedback(FeedbackType.light);
        _animationController.forward(from: 0);
        widget.onPressed();
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
            color: MyPuttColors.gray[100]!,
            borderRadius: BorderRadius.circular(24)),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedBuilder(
              animation: _rotation,
              builder: (BuildContext context, Widget? child) =>
                  Transform.rotate(
                angle: _rotation.value,
                child: const Icon(
                  FlutterRemix.refresh_line,
                  size: 20,
                  color: MyPuttColors.darkGray,
                ),
              ),
            ),
            const SizedBox(
              width: 8,
            ),
            AutoSizeText('Retry',
                style: Theme.of(context)
                    .textTheme
                    .headline6
                    ?.copyWith(fontSize: 20, color: MyPuttColors.darkGray),
                maxLines: 1)
          ],
        ),
      ),
    );
  }
}
