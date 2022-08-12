import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:mixpanel_flutter/mixpanel_flutter.dart';
import 'package:myputt/components/buttons/my_putt_button.dart';
import 'package:myputt/services/myputt_auth_service.dart';
import 'package:myputt/utils/colors.dart';
import 'package:myputt/locator.dart';

import '../../components/custom_fields/custom_text_fields.dart';

enum UsernameStatus { none, available, unavailable, checking }

enum HeaderType { username, displayName, pdgaNumber }

class EnterDetailsScreen extends StatefulWidget {
  const EnterDetailsScreen({Key? key}) : super(key: key);

  static String routeName = '/enter_details';

  @override
  State<EnterDetailsScreen> createState() => _EnterDetailsScreenState();
}

class _EnterDetailsScreenState extends State<EnterDetailsScreen> {
  final Mixpanel _mixpanel = locator.get<Mixpanel>();
  final MyPuttAuthService _signinService = locator.get<MyPuttAuthService>();

  String? _errorText;
  bool _usernameValid = false;
  Timer? checkUsernameOnStoppedTyping;
  ButtonState _buttonState = ButtonState.normal;

  String _username = '';
  String _displayName = '';
  String _pdgaNumber = '';

  @override
  void initState() {
    super.initState();
    _mixpanel.track('Enter Details Screen Impression');
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
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                _header(context),
                const SizedBox(height: 24),
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
                enabled: _buttonState != ButtonState.loading,
                onValidityChanged: (bool valid) =>
                    setState(() => _usernameValid = valid),
                onChanged: (String username) =>
                    setState(() => _username = username),
              ),
              const SizedBox(height: 24),
              DetailsTextField(
                iconData: FlutterRemix.user_line,
                hint: 'Display name',
                enabled: _buttonState != ButtonState.loading,
                onChanged: (String displayName) =>
                    setState(() => _displayName = displayName),
              ),
              const SizedBox(height: 24),
              DetailsTextField(
                iconData: FlutterRemix.hashtag,
                hint: 'PDGA number (optional)',
                enabled: _buttonState != ButtonState.loading,
                onChanged: (String pdgaNum) =>
                    setState(() => _pdgaNumber = pdgaNum),
                textInputType: const TextInputType.numberWithOptions(
                  signed: true,
                  decimal: true,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          SizedBox(
            height: 24,
            child: _errorText == null
                ? null
                : Text(
                    _errorText!,
                    style: Theme.of(context).textTheme.headline6?.copyWith(
                          color: MyPuttColors.red,
                        ),
                  ),
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
    return MyPuttButton(
      title: 'Submit',
      onPressed: _onSubmit,
      width: double.infinity,
      disabled: _checkDisabled(),
      height: 56,
      borderRadius: 48,
      buttonState: _buttonState,
    );
  }

  Future<void> _onSubmit() async {
    _mixpanel.track('Enter Details Screen Submit Button Pressed', properties: {
      'Username': _username,
      'Display Name': _displayName,
      'PDGA Number': _pdgaNumber
    });
    if (!_validateFields()) {
      return;
    }
    final int? pdgaNumber = _pdgaNumber.isEmpty ? null : int.parse(_pdgaNumber);
    setState(() => _buttonState = ButtonState.loading);
    final bool success = await _signinService.setupNewUser(
      _username,
      _displayName,
      pdgaNumber: pdgaNumber,
    );
    if (success) {
      setState(() => _buttonState = ButtonState.success);
    } else {
      setState(() => _buttonState = ButtonState.retry);
    }
  }

  bool _validateFields() {
    if (_username.isEmpty) {
      setState(() => _errorText = 'Enter a username');
      return false;
    } else if (_displayName.isEmpty) {
      setState(() => _errorText = 'Enter a display name');
      return false;
    } else if (_pdgaNumber.isNotEmpty && int.tryParse(_pdgaNumber) == null) {
      setState(() => _errorText = 'Enter a valid PDGA number');
      return false;
    }
    return true;
  }

  bool _checkDisabled() {
    return !_usernameValid || _displayName.isEmpty;
  }
}
