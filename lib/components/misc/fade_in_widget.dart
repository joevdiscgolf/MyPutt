import 'package:flutter/material.dart';

class FadeInWidget extends StatefulWidget {
  const FadeInWidget({Key? key, required this.child, required this.duration})
      : super(key: key);

  final Duration duration;
  final Widget child;

  @override
  _FadeInWidgetState createState() => _FadeInWidgetState();
}

class _FadeInWidgetState extends State<FadeInWidget>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;
  late final Animation<double> _opacity;

  @override
  void initState() {
    _animationController =
        AnimationController(vsync: this, duration: widget.duration);

    _opacity = Tween<double>(begin: 0, end: 1).animate(_animationController);
    _animationController.forward();
    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      builder: (BuildContext context, Widget? child) =>
          Opacity(opacity: _opacity.value, child: widget.child),
      animation: _opacity,
    );
  }
}
