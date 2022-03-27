import 'dart:math' as math;
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';
import 'package:myputt/utils/colors.dart';

class SpinnerButton extends StatefulWidget {
  const SpinnerButton(
      {Key? key,
      this.height = 32,
      this.width,
      this.disabled = false,
      this.repeat = true,
      required this.onPressed,
      required this.title,
      this.iconData,
      this.iconColor = MyPuttColors.darkGray,
      this.iconSize = 16,
      this.backgroundColor = MyPuttColors.blue,
      this.shadowColor,
      this.textSize = 14,
      this.textColor = MyPuttColors.darkGray,
      this.padding})
      : super(key: key);

  final double height;
  final double? width;
  final Function onPressed;
  final String title;
  final IconData? iconData;
  final Color iconColor;
  final double iconSize;
  final Color backgroundColor;
  final Color? shadowColor;
  final double textSize;
  final Color textColor;
  final EdgeInsetsGeometry? padding;
  final bool disabled;
  final bool repeat;

  @override
  _SpinnerButtonState createState() => _SpinnerButtonState();
}

class _SpinnerButtonState extends State<SpinnerButton>
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
        if (!widget.disabled) {
          _animationController.forward(from: 0);
          widget.onPressed();
        }
      },
      child: Container(
        height: widget.height,
        width: widget.width,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
            color: widget.backgroundColor,
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
                child: Icon(FlutterRemix.refresh_line,
                    size: widget.iconSize, color: widget.iconColor),
              ),
            ),
            const SizedBox(
              width: 4,
            ),
            AutoSizeText(
              widget.title,
              style: Theme.of(context).textTheme.subtitle1?.copyWith(
                  color: widget.textColor,
                  fontSize: widget.textSize,
                  fontWeight: FontWeight.w500),
            )
          ],
        ),
      ),
    );
  }
}
