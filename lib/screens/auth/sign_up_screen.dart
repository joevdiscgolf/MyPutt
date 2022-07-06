import 'dart:async';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';
import 'package:myputt/components/buttons/my_putt_button.dart';
import 'package:myputt/locator.dart';
import 'package:myputt/components/custom_fields/custom_text_fields.dart';
import 'package:myputt/services/signin_service.dart';
import 'package:myputt/utils/colors.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final SigninService _signinService = locator.get<SigninService>();
  final formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  ButtonState _buttonState = ButtonState.normal;
  Timer? checkUsernameOnStoppedTyping;
  String? displayName;
  String? _email;
  String? _password;
  String? _errorText;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          color: Colors.transparent,
          icon: const Icon(
            FlutterRemix.arrow_left_s_line,
            color: Colors.black,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        backgroundColor: MyPuttColors.white,
        shadowColor: Colors.transparent,
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 40, right: 40, bottom: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _header(context),
            const SizedBox(
              height: 16,
            ),
            Center(child: _mainBody(context)),
          ],
        ),
      ),
    );
  }

  Widget _header(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Sign up',
          style: Theme.of(context)
              .textTheme
              .headline6
              ?.copyWith(color: MyPuttColors.blue, fontSize: 32),
        ),
        const SizedBox(
          height: 4,
        ),
        Text(
          'Please enter your email and password',
          style: Theme.of(context)
              .textTheme
              .headline6
              ?.copyWith(fontSize: 16, color: MyPuttColors.gray[400]),
        ),
      ],
    );
  }

  Widget _mainBody(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        CustomField(
          keyboardType: TextInputType.emailAddress,
          controller: _emailController,
          hint: 'Email',
          iconData: FlutterRemix.mail_line,
          onInput: (String text) => setState(() {
            _email = text;
            _errorText = null;
          }),
          innerPadding:
              const EdgeInsets.only(left: 12, right: 12, top: 20, bottom: 8),
        ),
        CustomField(
          controller: _passwordController,
          hint: 'Password',
          iconData: FlutterRemix.lock_line,
          onInput: (String text) => setState(() {
            _password = text;
            _errorText = null;
          }),
          obscureText: true,
          innerPadding:
              const EdgeInsets.only(left: 12, right: 12, top: 20, bottom: 8),
        ),
        Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(
              height: 16,
            ),
            _signUpButton(context),
            const SizedBox(
              height: 16,
            ),
            if (_errorText != null)
              AutoSizeText(
                _errorText!,
                style: Theme.of(context)
                    .textTheme
                    .headline6
                    ?.copyWith(color: Colors.red),
                maxLines: 1,
              ),
          ],
        )
      ],
    );
  }

  Widget _signUpButton(BuildContext context) {
    return MyPuttButton(
      buttonState: _buttonState,
      disabled: _checkDisabled(),
      title: 'Sign up',
      textSize: 20,
      backgroundColor: MyPuttColors.blue,
      height: 48,
      width: MediaQuery.of(context).size.width,
      onPressed: _signupPressed,
    );
  }

  Future<void> _signupPressed() async {
    setState(() => _errorText = null);
    Vibrate.feedback(FeedbackType.light);
    final String email = _emailController.text;
    final String password = _passwordController.text;
    if (email.isEmpty || password.isEmpty) {
      setState(() {
        _errorText = 'Missing username or password';
      });
      return;
    }
    setState(() => _buttonState = ButtonState.loading);
    final signUpSuccess =
        await _signinService.attemptSignUpWithEmail(email, password);
    if (!signUpSuccess) {
      setState(() {
        _buttonState = ButtonState.retry;
        _errorText = _signinService.errorMessage.isNotEmpty
            ? _signinService.errorMessage
            : 'Something went wrong. Please try again';
      });
    } else {
      setState(() => _buttonState = ButtonState.success);
      int count = 0;
      Navigator.popUntil(context, (route) {
        return count++ == 2;
      });
    }
  }

  bool _checkDisabled() {
    return _password == null ||
        _password!.length < 8 ||
        _email == null ||
        _email!.isEmpty;
  }
}
