import 'package:flutter/material.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:myputt/components/buttons/my_putt_button.dart';
import 'package:myputt/components/buttons/primary_button.dart';
import 'package:myputt/locator.dart';
import 'package:myputt/screens/auth/sign_up_screen.dart';
import 'package:myputt/services/auth_service.dart';
import 'package:myputt/services/signin_service.dart';
import 'package:myputt/utils/colors.dart';

class LandingScreen extends StatefulWidget {
  const LandingScreen({Key? key}) : super(key: key);

  @override
  State<LandingScreen> createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> {
  final AuthService _authService = locator.get<AuthService>();
  final SigninService _signinService = locator.get<SigninService>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String? _email;
  String? _password;
  bool _error = false;
  String _errorText = '';
  bool _loading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: GestureDetector(
        onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 48, horizontal: 24),
          child: SizedBox(
            width: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Align(
                  alignment: Alignment.center,
                  child: Center(
                    child: _header(context),
                  ),
                ),
                Column(
                  children: [
                    _emailField(context),
                    _passwordField(context),
                    const SizedBox(height: 8),
                    _signInButton(context, true),
                    const SizedBox(height: 36),
                    _error
                        ? SizedBox(
                            height: 50,
                            child: Text(_errorText,
                                style: const TextStyle(color: Colors.red)),
                          )
                        : Container(height: 50),
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
                                builder: (BuildContext context) =>
                                    const SignUpScreen()));
                      },
                      color: Colors.transparent,
                      textColor: MyPuttColors.blue,
                    )
                  ],
                ),
              ],
            ),
          ),
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
              children: [
                TextSpan(
                    text: 'My',
                    style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                        color: MyPuttColors.gray[800]!, fontSize: 64)),
                TextSpan(
                    text: 'Putt',
                    style: Theme.of(context)
                        .textTheme
                        .headlineLarge
                        ?.copyWith(color: MyPuttColors.blue, fontSize: 64)),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Master your game',
            style: Theme.of(context).textTheme.headline6!.copyWith(
                color: Colors.grey[400],
                fontWeight: FontWeight.w500,
                fontSize: 20),
          ),
        ]);
  }

  Widget _emailField(BuildContext context) {
    return SizedBox(
      width: 260,
      height: 60,
      child: TextFormField(
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
        onChanged: (String? value) => setState(() => _email = value),
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
        onChanged: (String? value) => setState(() => _password = value),
      ),
    );
  }

  Widget _signInButton(BuildContext context, bool signIn) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        PrimaryButton(
            loading: _loading,
            disabled: _email == null || _email == '' || _checkDisabled(),
            label: 'Sign in',
            fontSize: 20,
            backgroundColor: Colors.blue,
            height: 48,
            width: 260,
            onPressed: () async {
              if (_email == null || _password == null) {
                setState(() {
                  _error = true;
                  _errorText = 'Missing username or password';
                });
              } else {
                setState(() {
                  _loading = true;
                });
                final signinSuccess = await _signinService
                    .attemptSignInWithEmail(_email!, _password!);
                if (!signinSuccess) {
                  setState(() {
                    _loading = false;
                    _error = true;
                    _errorText = _authService.exception;
                  });
                }
              }
            }),
      ],
    );
  }

  bool _checkDisabled() {
    return _password == null ||
        _password!.length < 8 ||
        _email == null ||
        _email!.isEmpty;
  }
}
