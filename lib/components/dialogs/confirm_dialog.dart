import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:myputt/components/buttons/my_putt_button.dart';
import 'package:myputt/utils/colors.dart';

class ConfirmDialog extends StatefulWidget {
  const ConfirmDialog({
    Key? key,
    required this.title,
    this.subtitle,
    this.message,
    required this.icon,
    required this.actionPressed,
    required this.buttonlabel,
    required this.buttonColor,
  }) : super(key: key);

  final String title;
  final String? subtitle;
  final String? message;
  final Widget icon;
  final Function actionPressed;
  final String buttonlabel;
  final Color buttonColor;

  @override
  _ConfirmDialogState createState() => _ConfirmDialogState();
}

class _ConfirmDialogState extends State<ConfirmDialog> {
  String? _dialogErrorText;

  @override
  Widget build(BuildContext context) {
    return Dialog(
        insetPadding: const EdgeInsets.symmetric(horizontal: 24),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        child: Container(
            padding:
                const EdgeInsets.only(top: 24, bottom: 16, left: 24, right: 24),
            width: double.infinity,
            child: _mainBody(context)));
  }

  Widget _mainBody(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          AutoSizeText(
            widget.title,
            style: Theme.of(context)
                .textTheme
                .headline6
                ?.copyWith(color: MyPuttColors.darkGray, fontSize: 32),
            textAlign: TextAlign.center,
            maxLines: 1,
          ),
          const SizedBox(height: 16),
          widget.icon,
          const SizedBox(height: 16),
          if (widget.message != null) ...[
            AutoSizeText(
              widget.message!,
              style: Theme.of(context)
                  .textTheme
                  .headline6
                  ?.copyWith(color: MyPuttColors.gray[400], fontSize: 16),
              textAlign: TextAlign.center,
            ),
          ],
          Text(_dialogErrorText ?? ''),
          const SizedBox(height: 16),
          MyPuttButton(
            padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 8),
            title: widget.buttonlabel,
            textSize: 18,
            height: 40,
            borderColor: widget.buttonColor,
            backgroundColor: MyPuttColors.white,
            textColor: widget.buttonColor,
            shadowColor: MyPuttColors.gray[300]!,
            onPressed: () {
              widget.actionPressed();
              Navigator.pop(context);
            },
          ),
          MyPuttButton(
              width: 100,
              height: 40,
              title: 'Cancel',
              textSize: 12,
              textColor: Colors.grey[600]!,
              backgroundColor: Colors.transparent,
              onPressed: () {
                Navigator.pop(context);
              }),
        ],
      ),
    );
  }
}
