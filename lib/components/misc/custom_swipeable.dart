import 'package:flutter/material.dart';

class CustomSwipeable extends StatefulWidget {
  const CustomSwipeable({Key? key, required this.child, this.onSwipe})
      : super(key: key);

  final Widget child;
  final Function? onSwipe;

  @override
  State<CustomSwipeable> createState() => _CustomSwipeableState();
}

class _CustomSwipeableState extends State<CustomSwipeable> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTapDown: (TapDownDetails details) {
          // setState(() {
          //   _dragOffset = details.localPosition;
          // });
        },
        onHorizontalDragStart: (DragStartDetails dragEndDetails) {
          _onDragStart(dragEndDetails);
        },
        onHorizontalDragUpdate: (DragUpdateDetails dragUpdateDetails) {
          _onDragUpdate(dragUpdateDetails);
        },
        onHorizontalDragEnd: (DragEndDetails dragEndDetails) {
          _onDragEnd(dragEndDetails);
        },
        child: widget.child);
  }

  void _onDragStart(DragStartDetails dragStartDetails) {
    // setState(() {
    //   _dragStartOffset = dragStartDetails.localPosition;
    //   _dragOffset = dragStartDetails.localPosition;
    // });
  }

  void _onDragUpdate(DragUpdateDetails dragUpdateDetails) {
    // setState(() {
    //   _dragOffset = dragUpdateDetails.localPosition;
    // });
  }

  void _onDragEnd(DragEndDetails dragEndDetails) {}
}
