import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:mixpanel_flutter/mixpanel_flutter.dart';
import 'package:myputt/components/buttons/my_putt_button.dart';
import 'package:myputt/components/misc/shadow_icon.dart';
import 'package:myputt/locator.dart';
import 'package:myputt/services/firebase_auth_service.dart';
import 'package:myputt/utils/colors.dart';

class ResetPasswordDialog extends StatefulWidget {
  const ResetPasswordDialog({Key? key}) : super(key: key);

  @override
  _ResetPasswordDialogState createState() => _ResetPasswordDialogState();
}

class _ResetPasswordDialogState extends State<ResetPasswordDialog> {
  final FirebaseAuthService _authService = locator.get<FirebaseAuthService>();

  String _email = '';
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
            const EdgeInsets.only(top: 24, bottom: 16, left: 16, right: 16),
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
          const SizedBox(height: 24),
          const ShadowIcon(icon: Icon(FlutterRemix.mail_lock_fill, size: 64)),
          const SizedBox(height: 24),
          _emailField(context),
          const SizedBox(height: 24),
          AutoSizeText(
            'Check spam folder if the email does not appear',
            style: Theme.of(context).textTheme.headline6?.copyWith(
                  color: MyPuttColors.gray[400],
                  fontSize: 12,
                ),
            textAlign: TextAlign.center,
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
            backgroundColor: MyPuttColors.white,
            textColor: MyPuttColors.blue,
            shadowColor: MyPuttColors.gray[300]!,
            onPressed: _onSend,
            buttonState: _buttonState,
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
            },
          ),
        ],
      ),
    );
  }

  Widget _emailField(BuildContext context) {
    return SizedBox(
      width: 260,
      height: 60,
      child: TextFormField(
        keyboardType: TextInputType.emailAddress,
        autocorrect: false,
        maxLines: 1,
        maxLength: 32,
        style: Theme.of(context)
            .textTheme
            .subtitle1!
            .copyWith(fontSize: 18, fontWeight: FontWeight.bold),
        decoration: InputDecoration(
          hintText: 'Email',
          contentPadding:
              const EdgeInsets.only(left: 12, right: 12, top: 20, bottom: 8),
          isDense: true,
          hintStyle: Theme.of(context)
              .textTheme
              .subtitle1!
              .copyWith(color: Colors.grey[400], fontSize: 18),
          enabledBorder: Theme.of(context).inputDecorationTheme.border,
          focusedBorder: Theme.of(context).inputDecorationTheme.border,
          prefixIcon: const Padding(
            padding: EdgeInsets.symmetric(vertical: 18.0),
            child: Icon(
              FlutterRemix.mail_line,
              color: Colors.grey,
              size: 22,
            ),
          ),
          counter: const Offstage(),
        ),
        onChanged: (String email) => setState(() => _email = email),
      ),
    );
  }

  Future<void> _onSend() async {
    locator.get<Mixpanel>().track(
      'Reset Password Dialog Send Button Pressed',
      properties: {'Email': _email},
    );
    setState(() => _buttonState = ButtonState.loading);
    final bool success = await _authService.sendPasswordReset(_email);
    if (!success) {
      setState(() {
        _dialogErrorText = 'Failed to send. Please try again.';
        _buttonState = ButtonState.retry;
      });
      return;
    }
    setState(() => _buttonState = ButtonState.success);
    await Future.delayed(const Duration(milliseconds: 500));
    Navigator.of(context).pop();
  }
}
