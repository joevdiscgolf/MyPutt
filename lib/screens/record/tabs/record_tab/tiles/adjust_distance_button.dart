import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:flutter/services.dart';
import 'package:myputt/cubits/record/record_cubit.dart';
import 'package:myputt/utils/colors.dart';

class AdjustDistanceButton extends StatefulWidget {
  const AdjustDistanceButton({Key? key, required this.increment})
      : super(key: key);

  final bool increment;

  @override
  State<AdjustDistanceButton> createState() => _AdjustDistanceButtonState();
}

class _AdjustDistanceButtonState extends State<AdjustDistanceButton> {
  static const double _iconSize = 20;
  static const double _borderRadius = 8;
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        BlocProvider.of<RecordCubit>(context)
            .incrementDistance(widget.increment);
      },
      onTapDown: (_) {
        setState(() {
          _isPressed = true;
        });
      },
      onTapUp: (_) {
        setState(() {
          _isPressed = false;
        });
      },
      child: Column(
        children: [
          Expanded(
            child: Container(
              width: 48,
              decoration: BoxDecoration(
                color: _isPressed ? MyPuttColors.blue : Colors.transparent,
                borderRadius: widget.increment
                    ? const BorderRadius.only(
                        topRight: Radius.circular(_borderRadius),
                        bottomRight: Radius.circular(_borderRadius),
                      )
                    : const BorderRadius.only(
                        topLeft: Radius.circular(_borderRadius),
                        bottomLeft: Radius.circular(_borderRadius),
                      ),
              ),
              child: SizedBox(
                height: _iconSize,
                width: _iconSize,
                child: Icon(
                  widget.increment
                      ? FlutterRemix.add_line
                      : FlutterRemix.subtract_line,
                  color: MyPuttColors.darkGray,
                  size: _iconSize,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
