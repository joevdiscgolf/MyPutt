import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:myputt/locator.dart';
import 'package:myputt/screens/auth/enter_details_screen.dart';
import 'package:myputt/services/firebase_auth_service.dart';
import 'package:myputt/utils/colors.dart';
import 'package:myputt/utils/validators.dart';

class CustomField extends StatelessWidget {
  const CustomField({
    Key? key,
    required this.controller,
    this.obscureText = false,
    this.hint,
    this.iconData,
    this.onInput,
    this.keyboardType,
    this.innerPadding =
        const EdgeInsets.only(left: 12, right: 12, top: 20, bottom: 8),
  }) : super(key: key);

  final TextEditingController controller;
  final bool obscureText;
  final String? hint;
  final IconData? iconData;
  final Function? onInput;
  final TextInputType? keyboardType;
  final EdgeInsets innerPadding;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: 60,
      child: TextFormField(
        keyboardType: keyboardType,
        obscureText: obscureText,
        controller: controller,
        autocorrect: false,
        maxLines: 1,
        maxLength: 32,
        style: Theme.of(context)
            .textTheme
            .subtitle1!
            .copyWith(fontSize: 18, fontWeight: FontWeight.bold),
        decoration: InputDecoration(
          hintText: hint,
          contentPadding: innerPadding,
          hintStyle: Theme.of(context)
              .textTheme
              .subtitle1!
              .copyWith(color: Colors.grey[400], fontSize: 18),
          enabledBorder: Theme.of(context).inputDecorationTheme.border,
          focusedBorder: Theme.of(context).inputDecorationTheme.border,
          prefixIcon: Padding(
            padding: const EdgeInsets.symmetric(vertical: 18.0),
            child: iconData == null
                ? null
                : Icon(
                    iconData,
                    color: Colors.grey,
                    size: 22,
                  ),
          ),
          counter: const Offstage(),
        ),
        onChanged: (String text) {
          if (onInput != null) {
            onInput!(text);
          }
        },
      ),
    );
  }
}

class UsernameField extends StatefulWidget {
  const UsernameField({
    Key? key,
    this.textEditingController,
    required this.enabled,
    this.onChanged,
    required this.onValidityChanged,
  }) : super(key: key);

  final TextEditingController? textEditingController;
  final bool enabled;
  final Function? onChanged;
  final Function onValidityChanged;

  @override
  State<UsernameField> createState() => _UsernameFieldState();
}

class _UsernameFieldState extends State<UsernameField> {
  final FirebaseAuthService authService = locator.get<FirebaseAuthService>();
  UsernameStatus _usernameStatus = UsernameStatus.none;
  Timer? checkUsernameOnStoppedTyping;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 8, right: 8, top: 12, bottom: 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: MyPuttColors.gray[100],
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
                  border: InputBorder.none,
                  hintText: 'username',
                  contentPadding: const EdgeInsets.only(top: 12, bottom: 12),
                  isDense: true,
                  hintStyle: Theme.of(context)
                      .textTheme
                      .subtitle1!
                      .copyWith(color: MyPuttColors.gray[400], fontSize: 14),
                  enabledBorder: Theme.of(context).inputDecorationTheme.border,
                  focusedBorder: Theme.of(context).inputDecorationTheme.border,
                  prefixIcon: Icon(
                    FlutterRemix.at_line,
                    color: MyPuttColors.gray[500]!,
                    size: 20,
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
    if (widget.onChanged != null) {
      widget.onChanged!(value);
    }
    const duration = Duration(milliseconds: 400);
    if (checkUsernameOnStoppedTyping != null) {
      setState(() => checkUsernameOnStoppedTyping?.cancel());
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
            strokeWidth: 2,
          ),
        );
      default:
        return Container();
    }
  }
}

class DetailsTextField extends StatelessWidget {
  const DetailsTextField({
    Key? key,
    required this.iconData,
    this.textEditingController,
    required this.hint,
    required this.enabled,
    this.maxLines = 1,
    this.maxLength,
    this.onChanged,
    this.textInputType,
  }) : super(key: key);

  final IconData iconData;
  final String hint;
  final TextEditingController? textEditingController;
  final bool enabled;
  final int maxLines;
  final int? maxLength;
  final Function? onChanged;
  final TextInputType? textInputType;

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
          maxLines: maxLines,
          maxLength: maxLength,
          style: Theme.of(context)
              .textTheme
              .subtitle1!
              .copyWith(fontSize: 18, fontWeight: FontWeight.bold),
          keyboardType: textInputType,
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.only(top: 12, bottom: 12),
            border: InputBorder.none,
            hintText: hint,
            isDense: true,
            hintStyle: Theme.of(context)
                .textTheme
                .subtitle1!
                .copyWith(color: MyPuttColors.gray[400], fontSize: 14),
            enabledBorder: Theme.of(context).inputDecorationTheme.border,
            focusedBorder: Theme.of(context).inputDecorationTheme.border,
            prefixIcon: Icon(
              iconData,
              color: MyPuttColors.gray[500]!,
              size: 20,
            ),
            counter: const Offstage(),
          ),
          onChanged: (String text) {
            if (onChanged != null) {
              onChanged!(text);
            }
          },
        ),
      ),
    );
  }
}
