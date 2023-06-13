import 'package:flutter/material.dart';
import 'package:myputt/utils/colors.dart';

class AnimatedCircularProgressIndicator extends StatefulWidget {
  const AnimatedCircularProgressIndicator(
      {Key? key,
      required this.size,
      required this.strokeWidth,
      required this.duration,
      required this.decimal,
      this.strokeColor = MyPuttColors.lightGreen,
      this.showText = true})
      : super(key: key);

  final double size;
  final double strokeWidth;
  final Color strokeColor;
  final Duration duration;
  final double decimal;
  final bool showText;

  @override
  State<AnimatedCircularProgressIndicator> createState() =>
      _AnimatedCircularProgressIndicatorState();
}

class _AnimatedCircularProgressIndicatorState
    extends State<AnimatedCircularProgressIndicator>
    with SingleTickerProviderStateMixin {
  late final AnimationController animationController;
  late final Animation<double> animation;

  @override
  void initState() {
    animationController =
        AnimationController(vsync: this, duration: widget.duration);
    final CurvedAnimation curvedAnimation = CurvedAnimation(
        parent: animationController, curve: Curves.easeInOutQuad);

    animation =
        Tween<double>(begin: 0, end: widget.decimal).animate(curvedAnimation);

    animationController.forward();

    super.initState();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: Stack(
        children: <Widget>[
          SizedBox(
              width: widget.size,
              height: widget.size,
              child: AnimatedBuilder(
                animation: animation,
                builder: (BuildContext context, Widget? child) =>
                    CircularProgressIndicator(
                  color: widget.strokeColor,
                  backgroundColor: Colors.grey[200],
                  value: animation.value,
                  strokeWidth: 5,
                ),
              )),
          if (widget.showText)
            Center(
                child: AnimatedBuilder(
                    animation: animation,
                    builder: (BuildContext context, Widget? child) =>
                        (Text('${(animation.value * 100).round()} %'))))
        ],
      ),
    );
  }
}
