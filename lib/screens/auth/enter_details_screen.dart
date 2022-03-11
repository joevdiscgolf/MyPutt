import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:myputt/services/auth_service.dart';
import 'package:myputt/services/signin_service.dart';
import 'package:tailwind_colors/tailwind_colors.dart';
import 'package:myputt/components/buttons/primary_button.dart';
import 'package:myputt/locator.dart';
import 'package:myputt/utils/validators.dart';

enum UsernameStatus { none, available, unavailable, checking }
enum HeaderType { username, displayName, pdgaNumber }

class EnterDetailsScreen extends StatefulWidget {
  const EnterDetailsScreen({Key? key}) : super(key: key);

  static String routeName = '/select_username';

  @override
  State<EnterDetailsScreen> createState() => _EnterDetailsScreenState();
}

class _EnterDetailsScreenState extends State<EnterDetailsScreen> {
  final SigninService _signinService = locator.get<SigninService>();
  final AuthService _authService = locator.get<AuthService>();
  final formKey = GlobalKey<FormState>();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController displayNameController = TextEditingController();
  final TextEditingController pdgaNumberController = TextEditingController();

  bool _loading = false;
  bool _disabled = true;
  UsernameStatus _usernameStatus = UsernameStatus.none;
  Timer? checkUsernameOnStoppedTyping;
  String? displayName;

  @override
  void dispose() {
    usernameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        SystemChannels.textInput.invokeMethod('TextInput.hide');
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          shadowColor: Colors.transparent,
          title: Text(
            'Finish setup',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headline4,
          ),
          leading: IconButton(
            color: Colors.transparent,
            icon: const Icon(
              FlutterRemix.arrow_left_s_line,
              color: Colors.black,
            ),
            onPressed: () {
              _signinService.signOut();
            },
          ),
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(left: 24, right: 24, bottom: 16),
            child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  const SizedBox(
                    height: 10,
                  ),
                  Flexible(
                    child: ListView(
                      physics: const ClampingScrollPhysics(),
                      children: <Widget>[
                        _header(context, HeaderType.username),
                        const SizedBox(height: 10),
                        _usernameField(context),
                        const SizedBox(height: 4),
                        _availabilityLabel(context),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  Flexible(
                    child: ListView(
                      physics: const ClampingScrollPhysics(),
                      children: <Widget>[
                        _header(context, HeaderType.displayName),
                        const SizedBox(height: 10),
                        _displayNameField(context),
                      ],
                    ),
                  ),
                  Flexible(
                    child: ListView(
                      physics: const ClampingScrollPhysics(),
                      children: <Widget>[
                        _header(context, HeaderType.pdgaNumber),
                        const SizedBox(height: 10),
                        _pdgaNumberField(context),
                      ],
                    ),
                  ),
                  _submitButton(context),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _header(BuildContext context, HeaderType type) {
    String text;
    switch (type) {
      case HeaderType.username:
        text = 'Choose your username';
        break;
      case HeaderType.displayName:
        text = 'Choose your display name';
        break;
      case HeaderType.pdgaNumber:
        text = 'Enter your PDGA number (optional)';
        break;
    }
    return Text(text,
        textAlign: TextAlign.center,
        maxLines: 2,
        style: Theme.of(context).textTheme.headline6);
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

  Widget _displayNameField(BuildContext context) {
    return TextFormField(
      controller: displayNameController,
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
        hintText: 'Enter display name',
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
          FlutterRemix.user_line,
          color: TWUIColors.gray,
          size: 22,
        ),
        counter: const Offstage(),
      ),
      onChanged: (text) {
        setState(() {
          displayName = text;
        });
      },
    );
  }

  Widget _pdgaNumberField(BuildContext context) {
    return TextFormField(
      inputFormatters: [
        LengthLimitingTextInputFormatter(6),
      ],
      controller: pdgaNumberController,
      enabled: !_loading,
      autocorrect: false,
      maxLines: 1,
      maxLength: 24,
      style: Theme.of(context)
          .textTheme
          .subtitle1!
          .copyWith(fontSize: 18, fontWeight: FontWeight.bold),
      keyboardType: const TextInputType.numberWithOptions(),
      decoration: InputDecoration(
        hintText: 'PDGA number',
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
          FlutterRemix.user_line,
          color: TWUIColors.gray,
          size: 22,
        ),
        counter: const Offstage(),
      ),
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

  Widget _submitButton(BuildContext context) {
    return PrimaryButton(
      label: 'Submit',
      fontSize: 20,
      loading: _loading,
      disabled: _disabled || displayName == '' || displayName == null,
      backgroundColor: TWUIColors.blue,
      height: 48,
      width: double.infinity,
      onPressed: () async {
        setState(() => _loading = true);
        bool success = false;
        if (int.tryParse(pdgaNumberController.value.text) != null) {
          success = await _signinService.setupNewUser(
              usernameController.value.text, displayNameController.value.text,
              pdgaNumber: int.parse(pdgaNumberController.value.text));
        } else {
          success = await _signinService.setupNewUser(
              usernameController.value.text, displayNameController.value.text);
        }
        setState(() => _loading = false);
      },
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
