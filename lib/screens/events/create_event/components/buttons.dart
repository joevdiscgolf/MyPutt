import 'package:flutter/material.dart';
import 'package:myputt/components/buttons/my_putt_button.dart';
import 'package:myputt/utils/colors.dart';

class ContinueButton extends StatelessWidget {
  const ContinueButton({Key? key, required this.onPressed}) : super(key: key);

  final Function onPressed;

  @override
  Widget build(BuildContext context) {
    return MyPuttButton(
      title: 'Continue',
      onPressed: onPressed,
      width: double.infinity,
      textSize: 20,
      shadowColor: MyPuttColors.gray[400],
    );
  }
}

class CancelButton extends StatelessWidget {
  const CancelButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MyPuttButton(
      title: 'Cancel',
      textColor: MyPuttColors.gray[400]!,
      color: Colors.transparent,
      width: double.infinity,
      onPressed: () => Navigator.of(context).popUntil((route) => route.isFirst),
    );
  }
}
