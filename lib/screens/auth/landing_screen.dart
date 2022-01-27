import 'package:flutter/material.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:myputt/components/buttons/primary_button.dart';
import 'package:myputt/locator.dart';
import 'package:myputt/services/auth_service.dart';
import 'package:myputt/services/signin_service.dart';

class LandingScreen extends StatefulWidget {
  const LandingScreen({Key? key}) : super(key: key);

  @override
  State<LandingScreen> createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> {
  final AuthService _authService = locator.get<AuthService>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String? _email;
  String? _password;
  bool _error = false;
  String _errorText = '';
  bool _loading = false;

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
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Align(
                  alignment: Alignment.center,
                  child: Center(
                    child: _header(context),
                  ),
                ),
                Column(
                  children: [
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: _emailField(context),
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: _passwordField(context),
                    ),
                    const SizedBox(height: 10),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: _signInButton(context),
                    ),
                    _error
                        ? Text(_errorText,
                            style: const TextStyle(color: Colors.red))
                        : Container()
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
              style: Theme.of(context).textTheme.headline3,
              children: const [
                TextSpan(
                  text: 'My',
                ),
                TextSpan(text: 'Putt', style: TextStyle(color: Colors.blue)),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Master your game',
            style: Theme.of(context)
                .textTheme
                .headline6!
                .copyWith(color: Colors.grey[400], fontWeight: FontWeight.w500),
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
              const EdgeInsets.only(left: 12, right: 12, top: 18, bottom: 18),
          isDense: true,
          hintStyle: Theme.of(context)
              .textTheme
              .subtitle1!
              .copyWith(color: Colors.grey[400], fontSize: 18),
          enabledBorder: Theme.of(context).inputDecorationTheme.border,
          focusedBorder: Theme.of(context).inputDecorationTheme.border,
          prefixIcon: const Icon(
            FlutterRemix.mail_line,
            color: Colors.grey,
            size: 22,
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
              const EdgeInsets.only(left: 12, right: 12, top: 18, bottom: 18),
          isDense: true,
          hintStyle: Theme.of(context)
              .textTheme
              .subtitle1!
              .copyWith(color: Colors.grey[400], fontSize: 18),
          enabledBorder: Theme.of(context).inputDecorationTheme.border,
          focusedBorder: Theme.of(context).inputDecorationTheme.border,
          prefixIcon: const Icon(
            FlutterRemix.lock_line,
            color: Colors.grey,
            size: 22,
          ),
          counter: const Offstage(),
        ),
        onChanged: (String? value) => setState(() => _password = value),
      ),
    );
  }

  Widget _signInButton(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        PrimaryButton(
            loading: _loading,
            label: 'Sign in',
            fontSize: 20,
            // icon: FlutterRemix.cellphone_fill,
            backgroundColor: Colors.blue,
            height: 48,
            width: 260,
            onPressed: () async {
              if (_email == null || _password == null) {
                setState(() {
                  _error = true;
                  _errorText = 'Missing username or password';
                });
                print('email or pass is null');
              }
              else {
                setState(() {
                  _loading = true;
                });
                final signInSuccess = await locator.get<SigninService>().attemptSignIn(_email!, _password!);
                setState(() {
                  _loading = !signInSuccess;
                });
                }
              }
    ),
        const SizedBox(height: 36),
      ],
    );
  }
}
