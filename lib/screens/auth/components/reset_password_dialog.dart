import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:myputt/components/buttons/my_putt_button.dart';
import 'package:myputt/components/misc/shadow_icon.dart';
import 'package:myputt/locator.dart';
import 'package:myputt/services/auth_service.dart';
import 'package:myputt/utils/colors.dart';

class ResetPasswordDialog extends StatefulWidget {
  const ResetPasswordDialog({Key? key, required this.email}) : super(key: key);

  final String email;

  @override
  _ResetPasswordDialogState createState() => _ResetPasswordDialogState();
}

class _ResetPasswordDialogState extends State<ResetPasswordDialog> {
  final AuthService _authService = locator.get<AuthService>();

  String? _dialogErrorText;
  ButtonState _buttonState = ButtonState.normal;

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
        child: _mainBody(context),
      ),
    );
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
            'Reset password',
            style: Theme.of(context)
                .textTheme
                .headline6
                ?.copyWith(color: MyPuttColors.darkGray, fontSize: 32),
            textAlign: TextAlign.center,
            maxLines: 1,
          ),
          const SizedBox(height: 16),
          const SizedBox(height: 16),
          const ShadowIcon(icon: Icon(FlutterRemix.mail_send_fill, size: 80)),
          const SizedBox(height: 32),
          AutoSizeText(
            'Send to ${widget.email}',
            style: Theme.of(context)
                .textTheme
                .headline6
                ?.copyWith(color: MyPuttColors.gray[400], fontSize: 16),
            textAlign: TextAlign.center,
            maxLines: 1,
          ),
          const SizedBox(height: 16),
          Text(_dialogErrorText ?? ''),
          const SizedBox(height: 16),
          MyPuttButton(
            padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 8),
            title: 'Send',
            textSize: 18,
            height: 40,
            borderColor: MyPuttColors.blue,
            color: MyPuttColors.white,
            textColor: MyPuttColors.blue,
            shadowColor: MyPuttColors.gray[300]!,
            onPressed: () async {
              setState(() => _buttonState = ButtonState.loading);
              final bool success =
                  await _authService.sendPasswordReset(widget.email);
              if (!success) {
                setState(() {
                  _dialogErrorText = 'Failed to send. Please try again.';
                  _buttonState = ButtonState.retry;
                });
                return;
              }
              setState(() => _buttonState = ButtonState.normal);
              await Future.delayed(const Duration(minutes: 500));
              Navigator.of(context).pop();
            },
            buttonState: _buttonState,
          ),
          MyPuttButton(
            width: 100,
            height: 40,
            title: 'Cancel',
            textSize: 12,
            textColor: Colors.grey[600]!,
            color: Colors.transparent,
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}
