import 'package:flutter/material.dart';
import 'package:myputt/components/buttons/my_putt_button.dart';
import 'package:myputt/utils/colors.dart';

class ContinueButton extends StatelessWidget {
  const ContinueButton({
    Key? key,
    required this.onPressed,
    required this.text,
    this.buttonState = ButtonState.normal,
  }) : super(key: key);

  final Function onPressed;
  final String text;
  final ButtonState buttonState;

  @override
  Widget build(BuildContext context) {
    return MyPuttButton(
      title: text,
      onPressed: onPressed,
      width: double.infinity,
      textSize: 20,
      shadowColor: MyPuttColors.gray[400],
      buttonState: buttonState,
    );
  }
}

class PreviousPageButton extends StatelessWidget {
  const PreviousPageButton({
    Key? key,
    required this.onTap,
  }) : super(key: key);

  final Function onTap;

  @override
  Widget build(BuildContext context) {
    return MyPuttButton(
      title: 'Back',
      textColor: MyPuttColors.gray[400]!,
      backgroundColor: Colors.transparent,
      width: double.infinity,
      onPressed: onTap,
    );
  }
}
