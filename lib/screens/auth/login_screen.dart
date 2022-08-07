import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:myputt/components/buttons/my_putt_button.dart';
import 'package:myputt/components/buttons/spinner_button.dart';
import 'package:myputt/locator.dart';
import 'package:myputt/screens/auth/components/reset_password_dialog.dart';
import 'package:myputt/screens/auth/sign_up_screen.dart';
import 'package:myputt/services/myputt_auth_service.dart';
import 'package:myputt/utils/colors.dart';
import 'package:myputt/utils/utils.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key, this.isFirstRun = false}) : super(key: key);

  final bool isFirstRun;

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final MyPuttAuthService _signinService = locator.get<MyPuttAuthService>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  String? _email;
  String? _password;
  String _errorText = '';
  bool _loading = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(
              FlutterRemix.arrow_left_s_line,
              color: MyPuttColors.darkGray,
            ),
            onPressed: () => Navigator.of(context).pop(),
          ),
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
        ),
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.white,
        body: _mainBody(context),
      ),
    );
  }

  Widget _mainBody(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 24),
      child: SizedBox(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            _header(context),
            Column(
              children: [
                _emailField(context),
                _passwordField(context),
                const SizedBox(height: 8),
                _signInButton(context, true),
                const SizedBox(height: 36),
                SizedBox(
                  height: 50,
                  child: Text(
                    _errorText,
                    style: const TextStyle(color: Colors.red),
                  ),
                ),
                Text("Don't have an account?",
                    style: Theme.of(context)
                        .textTheme
                        .headline6
                        ?.copyWith(color: MyPuttColors.gray[400])),
                const SizedBox(
                  height: 16,
                ),
                MyPuttButton(
                  title: 'Sign up',
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (BuildContext context) => const SignUpScreen(),
                      ),
                    );
                  },
                  backgroundColor: Colors.transparent,
                  textColor: MyPuttColors.blue,
                  underline: true,
                ),
                const SizedBox(height: 16),
                MyPuttButton(
                  title: 'Reset password',
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (dialogContext) => const ResetPasswordDialog(),
                    );
                  },
                  backgroundColor: Colors.transparent,
                  textColor: MyPuttColors.blue,
                  underline: true,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _header(BuildContext context) {
    return Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          RichText(
            text: TextSpan(
              style: Theme.of(context).textTheme.headline4,
              children: [
                TextSpan(
                    text: 'My',
                    style: Theme.of(context).textTheme.headline6?.copyWith(
                        color: MyPuttColors.darkBlue,
                        fontWeight: FontWeight.w600,
                        fontSize: 40)),
                TextSpan(
                    text: 'Putt',
                    style: Theme.of(context).textTheme.headline6?.copyWith(
                        color: MyPuttColors.darkGray,
                        fontWeight: FontWeight.w600,
                        fontSize: 40)),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Master your game',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headline5!.copyWith(
                  color: MyPuttColors.gray[400]!,
                  fontWeight: FontWeight.w600,
                ),
          ),
        ]);
  }

  Widget _emailField(BuildContext context) {
    return SizedBox(
      width: 260,
      height: 60,
      child: TextFormField(
        keyboardType: TextInputType.emailAddress,
        controller: _emailController,
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
        onChanged: (String? value) => setState(() {
          _errorText = '';
          _email = value;
        }),
      ),
    );
  }

  Widget _passwordField(BuildContext context) {
    return SizedBox(
      width: 260,
      height: 60,
      child: TextFormField(
        obscureText: true,
        controller: _passwordController,
        autocorrect: false,
        maxLines: 1,
        maxLength: 32,
        style: Theme.of(context)
            .textTheme
            .subtitle1!
            .copyWith(fontSize: 18, fontWeight: FontWeight.bold),
        decoration: InputDecoration(
          hintText: 'Password',
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
              FlutterRemix.lock_line,
              color: Colors.grey,
              size: 22,
            ),
          ),
          counter: const Offstage(),
        ),
        onChanged: (String? value) => setState(() {
          _errorText = '';
          _password = value;
        }),
      ),
    );
  }

  Widget _signInButton(BuildContext context, bool signIn) {
    return SpinnerButton(
      repeat: _loading,
      disabled: _checkDisabled(),
      title: 'Sign in',
      textSize: 20,
      textColor: MyPuttColors.white,
      backgroundColor: Colors.blue,
      iconColor: MyPuttColors.white,
      iconSize: 20,
      height: 48,
      width: 260,
      onPressed: _loginPressed,
    );
  }

  bool _checkDisabled() {
    return _password == null ||
        _password!.length < 8 ||
        _email == null ||
        _email!.isEmpty;
  }

  void _loginPressed() async {
    if (_email == null || _password == null) {
      setState(() {
        _errorText = 'Missing username or password';
      });
      return;
    }
    setState(() {
      _loading = true;
    });

    bool signinSuccess;
    try {
      signinSuccess =
          await _signinService.attemptSignInWithEmail(_email!, _password!);
    } catch (e, trace) {
      log(e.toString());
      log(trace.toString());
      signinSuccess = false;
      setState(
        () => _errorText = _signinService.errorMessage.isNotEmpty
            ? _signinService.errorMessage
            : 'Something went wrong. Please try again',
      );
    }

    if (!signinSuccess) {
      setState(() {
        _loading = false;
        _errorText = _signinService.errorMessage;
      });
      return;
    }
    reloadCubits(context);
    Navigator.of(context).pop();
  }
}
