import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:myputt/services/auth_service.dart';
import 'package:myputt/services/signin_service.dart';
import 'package:myputt/utils/colors.dart';
import 'package:tailwind_colors/tailwind_colors.dart';
import 'package:myputt/components/buttons/primary_button.dart';
import 'package:myputt/locator.dart';
import 'package:myputt/utils/validators.dart';

enum UsernameStatus { none, available, unavailable, checking }

enum HeaderType { username, displayName, pdgaNumber }

class EnterDetailsScreen extends StatefulWidget {
  const EnterDetailsScreen({Key? key}) : super(key: key);

  static String routeName = '/enter_details';

  @override
  State<EnterDetailsScreen> createState() => _EnterDetailsScreenState();
}

class _EnterDetailsScreenState extends State<EnterDetailsScreen> {
  final SigninService _signinService = locator.get<SigninService>();
  final formKey = GlobalKey<FormState>();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController displayNameController = TextEditingController();
  final TextEditingController pdgaNumberController = TextEditingController();

  bool _loading = false;
  bool _usernameValid = false;
  Timer? checkUsernameOnStoppedTyping;
  String? username;
  String? _displayName;
  String? _pdgaNumber;

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
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          backgroundColor: Colors.white,
          shadowColor: Colors.transparent,
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
        body: Padding(
          padding: const EdgeInsets.only(left: 32, right: 32, bottom: 16),
          child: Form(
            key: formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                _header(context),
                const SizedBox(
                  height: 24,
                ),
                _mainBody(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _mainBody(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              UsernameField(
                textEditingController: usernameController,
                enabled: !_loading,
                onChanged: (String text) {
                  setState(() {
                    _usernameValid = false;
                    username = text;
                  });
                },
                onValidityChanged: (bool valid) =>
                    setState(() => _usernameValid = valid),
              ),
              const SizedBox(height: 24),
              DetailsTextField(
                  iconData: FlutterRemix.user_line,
                  textEditingController: displayNameController,
                  hint: 'Display name',
                  enabled: !_loading,
                  onInput: (String text) =>
                      setState(() => _displayName = text)),
              const SizedBox(
                height: 24,
              ),
              DetailsTextField(
                iconData: FlutterRemix.hashtag,
                textEditingController: pdgaNumberController,
                hint: 'PDGA # (optional)',
                enabled: !_loading,
                onInput: (String text) => setState(() => _pdgaNumber = text),
                numberInput: true,
              ),
            ],
          ),
          const Spacer(),
          _submitButton(context),
          const SizedBox(
            height: 16,
          )
        ],
      ),
    );
  }

  Widget _header(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Create an account',
          style: Theme.of(context)
              .textTheme
              .headline6
              ?.copyWith(color: MyPuttColors.blue, fontSize: 32),
        ),
        const SizedBox(
          height: 4,
        ),
        Text(
          'Please fill out the information below',
          style: Theme.of(context)
              .textTheme
              .headline6
              ?.copyWith(fontSize: 16, color: MyPuttColors.gray[400]),
        ),
      ],
    );
  }

  Widget _submitButton(BuildContext context) {
    return PrimaryButton(
      label: 'Submit',
      fontSize: 20,
      loading: _loading,
      disabled: checkDisabled(),
      height: 60,
      backgroundColor: TWUIColors.blue,
      width: double.infinity,
      onPressed: () async {
        setState(() => _loading = true);
        if (_pdgaNumber == '' || _pdgaNumber == null) {
          await _signinService.setupNewUser(
            usernameController.value.text,
            displayNameController.value.text,
          );
        } else if (int.tryParse(_pdgaNumber!) != null) {
          await _signinService.setupNewUser(
              usernameController.value.text, displayNameController.value.text,
              pdgaNumber: int.parse(pdgaNumberController.value.text));
        }
        setState(() => _loading = false);
      },
    );
  }

  bool checkDisabled() {
    return !_usernameValid || _displayName == '';
  }
}

class UsernameField extends StatefulWidget {
  const UsernameField({
    Key? key,
    required this.textEditingController,
    required this.enabled,
    required this.onChanged,
    required this.onValidityChanged,
  }) : super(key: key);

  final TextEditingController textEditingController;
  final bool enabled;
  final Function onChanged;
  final Function onValidityChanged;

  @override
  State<UsernameField> createState() => _UsernameFieldState();
}

class _UsernameFieldState extends State<UsernameField> {
  final AuthService authService = locator.get<AuthService>();
  UsernameStatus _usernameStatus = UsernameStatus.none;
  Timer? checkUsernameOnStoppedTyping;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: MyPuttColors.gray[200],
      ),
      child: Center(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
              child: TextFormField(
                controller: widget.textEditingController,
                enabled: widget.enabled,
                autocorrect: false,
                maxLines: 1,
                maxLength: 24,
                style: Theme.of(context)
                    .textTheme
                    .subtitle1!
                    .copyWith(fontSize: 18, fontWeight: FontWeight.bold),
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.only(top: 18, bottom: 12),
                  border: InputBorder.none,
                  hintText: 'username',
                  // contentPadding:
                  //     const EdgeInsets.only(left: 12, right: 12, top: 18, bottom: 18),
                  isDense: true,
                  hintStyle: Theme.of(context)
                      .textTheme
                      .subtitle1!
                      .copyWith(color: TWUIColors.gray[500], fontSize: 18),
                  enabledBorder: Theme.of(context).inputDecorationTheme.border,
                  focusedBorder: Theme.of(context).inputDecorationTheme.border,
                  prefixIcon: Icon(
                    FlutterRemix.at_line,
                    color: TWUIColors.gray[600]!,
                    size: 22,
                  ),
                  counter: const Offstage(),
                ),
                onChanged: _usernameHandler,
              ),
            ),
            _availabilityIcon(context),
            const SizedBox(
              width: 24,
            )
          ],
        ),
      ),
    );
  }

  void _usernameHandler(String value) {
    widget.onChanged(value);
    const duration = Duration(
        milliseconds:
            400); // set the duration that you want call search() after that.
    if (checkUsernameOnStoppedTyping != null) {
      setState(() => checkUsernameOnStoppedTyping?.cancel()); // clear timer
    }
    setState(() => checkUsernameOnStoppedTyping =
        Timer(duration, () => _checkUsernameAvailability(value)));
  }

  void _checkUsernameAvailability(String username) async {
    setState(() => _usernameStatus = UsernameStatus.checking);
    if (validUsername(username)) {
      final bool available = await authService.usernameIsAvailable(username);
      setState(() {
        _usernameStatus =
            available ? UsernameStatus.available : UsernameStatus.unavailable;
      });
      widget.onValidityChanged(true);
    } else {
      widget.onValidityChanged(true);
      setState(() => _usernameStatus = UsernameStatus.none);
    }
  }

  Widget _availabilityIcon(BuildContext context) {
    switch (_usernameStatus) {
      case UsernameStatus.available:
        return Icon(
          FlutterRemix.check_line,
          color: MyPuttColors.gray[400],
          size: 20,
        );
      case UsernameStatus.unavailable:
        return Icon(
          FlutterRemix.close_line,
          color: MyPuttColors.gray[400],
          size: 20,
        );
      case UsernameStatus.checking:
        return SizedBox(
          height: 20,
          width: 20,
          child: CircularProgressIndicator(
            color: MyPuttColors.gray[400],
          ),
        );
      default:
        return Container();
    }
  }
}

class DetailsTextField extends StatelessWidget {
  const DetailsTextField(
      {Key? key,
      required this.iconData,
      required this.textEditingController,
      required this.hint,
      required this.enabled,
      this.onInput,
      this.numberInput = false})
      : super(key: key);

  final IconData iconData;
  final String hint;
  final TextEditingController textEditingController;
  final bool enabled;
  final Function? onInput;
  final bool numberInput;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 8, right: 8, top: 12, bottom: 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: MyPuttColors.gray[100],
      ),
      child: Center(
        child: TextFormField(
          controller: textEditingController,
          enabled: enabled,
          autocorrect: false,
          maxLines: 1,
          maxLength: 24,
          style: Theme.of(context)
              .textTheme
              .subtitle1!
              .copyWith(fontSize: 18, fontWeight: FontWeight.bold),
          keyboardType: numberInput ? TextInputType.number : TextInputType.text,
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.only(top: 12, bottom: 12),
            border: InputBorder.none,
            hintText: hint,
            // contentPadding:
            //     const EdgeInsets.only(left: 12, right: 12, top: 18, bottom: 18),
            isDense: true,
            hintStyle: Theme.of(context)
                .textTheme
                .subtitle1!
                .copyWith(color: TWUIColors.gray[500], fontSize: 18),
            enabledBorder: Theme.of(context).inputDecorationTheme.border,
            focusedBorder: Theme.of(context).inputDecorationTheme.border,
            prefixIcon: Icon(
              iconData,
              color: TWUIColors.gray[600]!,
              size: 22,
            ),
            counter: const Offstage(),
          ),
          onChanged: (String text) {
            if (onInput != null) {
              onInput!(text);
            }
          },
        ),
      ),
    );
  }
}
