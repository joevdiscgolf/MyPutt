import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';
import 'package:myputt/cubits/record/record_cubit.dart';
import 'package:myputt/utils/colors.dart';

class QuantityRow extends StatelessWidget {
  const QuantityRow({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        children: [
          Expanded(
            child: Text(
              'Quantity',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: MyPuttColors.gray[400],
                    fontWeight: FontWeight.w600,
                  ),
            ),
          ),
          const QuantitySelector(),
        ],
      ),
    );
  }
}

class QuantitySelector extends StatelessWidget {
  const QuantitySelector({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 32,
      decoration: BoxDecoration(
        color: MyPuttColors.gray[50]!,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: MyPuttColors.black.withOpacity(0.1),
            offset: const Offset(0, 2),
            blurRadius: 2,
            spreadRadius: 0,
          )
        ],
      ),
      child: IntrinsicHeight(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const AdjustQuantityButton(increment: false),
            VerticalDivider(
              width: 1,
              color: MyPuttColors.gray[100]!,
              thickness: 1,
            ),
            SizedBox(
              width: 32,
              child: BlocBuilder<RecordCubit, RecordState>(
                builder: (context, state) {
                  return AutoSizeText(
                    '${state.setLength}',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: MyPuttColors.darkGray,
                        ),
                    maxLines: 1,
                    textAlign: TextAlign.center,
                  );
                },
              ),
            ),
            VerticalDivider(
              width: 1,
              color: MyPuttColors.gray[200]!,
              thickness: 1,
            ),
            const AdjustQuantityButton(increment: true),
          ],
        ),
      ),
    );
  }
}

class AdjustQuantityButton extends StatefulWidget {
  const AdjustQuantityButton({Key? key, required this.increment})
      : super(key: key);

  final bool increment;

  @override
  State<AdjustQuantityButton> createState() => _AdjustQuantityButtonState();
}

class _AdjustQuantityButtonState extends State<AdjustQuantityButton> {
  static const double _iconSize = 20;
  static const double _borderRadius = 8;
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Vibrate.feedback(FeedbackType.light);
        BlocProvider.of<RecordCubit>(context)
            .incrementSetLength(widget.increment);
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
      child: Container(
        height: 32,
        width: 32,
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
    );
  }
}
