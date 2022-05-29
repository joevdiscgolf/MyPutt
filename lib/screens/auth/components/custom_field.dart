import 'package:flutter/material.dart';

class CustomField extends StatelessWidget {
  const CustomField(
      {Key? key,
      required this.controller,
      this.obscureText = false,
      required this.hint,
      required this.iconData,
      this.onInput})
      : super(key: key);

  final TextEditingController controller;
  final bool obscureText;
  final String hint;
  final IconData iconData;
  final Function? onInput;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: 60,
      child: TextFormField(
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
          contentPadding:
              const EdgeInsets.only(left: 12, right: 12, top: 20, bottom: 8),
          isDense: true,
          hintStyle: Theme.of(context)
              .textTheme
              .subtitle1!
              .copyWith(color: Colors.grey[400], fontSize: 18),
          enabledBorder: Theme.of(context).inputDecorationTheme.border,
          focusedBorder: Theme.of(context).inputDecorationTheme.border,
          prefixIcon: Padding(
            padding: const EdgeInsets.symmetric(vertical: 18.0),
            child: Icon(
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
