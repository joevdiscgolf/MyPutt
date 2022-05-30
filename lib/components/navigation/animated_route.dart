import 'package:flutter/material.dart';

class AnimatedRoute extends PageRouteBuilder {
  final Widget widget;

  AnimatedRoute(this.widget)
      : super(
          pageBuilder: (
            context,
            animation,
            secondaryAnimation,
          ) =>
              widget,
          transitionDuration: const Duration(milliseconds: 200),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            Offset begin = const Offset(0.0, 1.0);
            Offset end = Offset.zero;
            var tween = Tween(begin: begin, end: end);
            Animation<Offset> offsetAnimation = animation.drive(tween);
            return SlideTransition(
              position: offsetAnimation,
              child: child,
            );
          },
        );
}
