import 'package:flutter/material.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:myputt/utils/colors.dart';

class EventUndoButton extends StatelessWidget {
  const EventUndoButton({Key? key, required this.onPressed}) : super(key: key);

  final Function onPressed;

  @override
  Widget build(BuildContext context) {
    return Bounceable(
      onTap: () => onPressed(),
      child: Container(
        decoration: BoxDecoration(
            color: Colors.transparent, borderRadius: BorderRadius.circular(48)),
        child: const Center(
          child: Icon(
            FlutterRemix.arrow_go_back_line,
            color: MyPuttColors.darkGray,
          ),
        ),
      ),
    );
  }
}
