import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:myputt/services/auth_service.dart';
import 'package:tailwind_colors/tailwind_colors.dart';
import 'package:myputt/components/buttons/primary_button.dart';
import 'package:myputt/locator.dart';
import 'package:myputt/utils/validators.dart';

enum UsernameStatus { none, available, unavailable, checking }

class EnterDetailsScreen extends StatefulWidget {
  const EnterDetailsScreen({Key? key}) : super(key: key);

  static String routeName = '/select_username';

  @override
  State<EnterDetailsScreen> createState() => _EnterDetailsScreenState();
}

class _EnterDetailsScreenState extends State<EnterDetailsScreen> {
  final AuthService _authService = locator.get<AuthService>();
  final formKey = GlobalKey<FormState>();
  final TextEditingController usernameController = TextEditingController();

  bool _loading = false;
  bool _disabled = true;
  UsernameStatus _usernameStatus = UsernameStatus.none;
  Timer? checkUsernameOnStoppedTyping;

  @override
  void dispose() {
    usernameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(left: 24, right: 24, bottom: 16),
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Expanded(
                  child: ListView(
                    physics: const ClampingScrollPhysics(),
                    children: <Widget>[
                      _header(context),
                      const SizedBox(height: 28),
                      _usernameField(context),
                      const SizedBox(height: 4),
                      _availabilityLabel(context),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                _continueButton(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _header(BuildContext context) {
    return Text('Choose your\nusername',
        textAlign: TextAlign.center,
        maxLines: 2,
        style: Theme.of(context).textTheme.headline4);
  }

  Widget _usernameField(BuildContext context) {
    return TextFormField(
      controller: usernameController,
      enabled: !_loading,
      autocorrect: false,
      maxLines: 1,
      maxLength: 24,
      style: Theme.of(context)
          .textTheme
          .subtitle1!
          .copyWith(fontSize: 18, fontWeight: FontWeight.bold),
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
        hintText: 'Enter username',
        contentPadding:
            const EdgeInsets.only(left: 12, right: 12, top: 18, bottom: 18),
        isDense: true,
        hintStyle: Theme.of(context)
            .textTheme
            .subtitle1!
            .copyWith(color: TWUIColors.gray[400], fontSize: 18),
        enabledBorder: Theme.of(context).inputDecorationTheme.border,
        focusedBorder: Theme.of(context).inputDecorationTheme.border,
        prefixIcon: const Icon(
          FlutterRemix.at_line,
          color: TWUIColors.gray,
          size: 22,
        ),
        counter: const Offstage(),
      ),
      onChanged: _usernameHandler,
    );
  }

  Widget _availabilityLabel(BuildContext context) {
    switch (_usernameStatus) {
      case UsernameStatus.available:
        return Text(
          'This username is available 🎉',
          maxLines: 3,
          textAlign: TextAlign.center,
          overflow: TextOverflow.ellipsis,
          style: Theme.of(context).textTheme.bodyText1!.copyWith(
                fontWeight: FontWeight.w600,
                color: TWUIColors.gray[400],
              ),
        );
      case UsernameStatus.unavailable:
        return Text(
          'This username is already taken 😔',
          maxLines: 3,
          textAlign: TextAlign.center,
          overflow: TextOverflow.ellipsis,
          style: Theme.of(context).textTheme.bodyText1!.copyWith(
                fontWeight: FontWeight.w600,
                color: TWUIColors.gray[400],
              ),
        );
      case UsernameStatus.checking:
        return Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              const SizedBox(width: 6),
              Text(
                'Checking availability...',
                maxLines: 3,
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.bodyText1!.copyWith(
                      fontWeight: FontWeight.w600,
                      color: TWUIColors.gray[400],
                    ),
              ),
            ],
          ),
        );
      case UsernameStatus.none:
      default:
        return Text(
          'Enter a valid username',
          maxLines: 3,
          textAlign: TextAlign.center,
          overflow: TextOverflow.ellipsis,
          style: Theme.of(context).textTheme.bodyText1!.copyWith(
                fontWeight: FontWeight.w600,
                color: TWUIColors.gray[400],
              ),
        );
    }
  }

  Widget _continueButton(BuildContext context) {
    return PrimaryButton(
      label: 'Continue',
      fontSize: 20,
      loading: _loading,
      disabled: _disabled,
      backgroundColor: TWUIColors.blue,
      height: 48,
      onPressed: () async {
        setState(() => _loading = true);
        final bool success =
            await _authService.setupNewUser(usernameController.value.text);
        if (success) {
          print('success');
        }
        setState(() => _loading = false);
      },
      width: double.infinity,
    );
  }

  void _usernameHandler(String value) {
    setState(() => _disabled = true);
    const duration = Duration(
        milliseconds:
            800); // set the duration that you want call search() after that.
    if (checkUsernameOnStoppedTyping != null) {
      setState(() => checkUsernameOnStoppedTyping?.cancel()); // clear timer
    }
    setState(() => checkUsernameOnStoppedTyping =
        Timer(duration, () => _checkUsernameAvailability(value)));
  }

  void _checkUsernameAvailability(String username) async {
    if (validUsername(username)) {
      setState(() => _usernameStatus = UsernameStatus.checking);
      final bool available = await _authService.usernameIsAvailable(username);
      setState(() {
        _usernameStatus =
            available ? UsernameStatus.available : UsernameStatus.unavailable;
        _disabled = !validUsername(usernameController.value.text) ||
            _usernameStatus != UsernameStatus.available;
      });
    } else {
      setState(() => _usernameStatus = UsernameStatus.none);
    }
  }
}
