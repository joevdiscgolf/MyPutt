import 'package:flutter/material.dart';
import 'package:myputt/utils/colors.dart';

class MyPuttRichText extends StatelessWidget {
  const MyPuttRichText({super.key});

  @override
  Widget build(BuildContext context) {
    final TextStyle? textStyle =
        Theme.of(context).textTheme.titleLarge?.copyWith(
              fontSize: 16,
              color: MyPuttColors.gray[100],
              fontWeight: FontWeight.w800,
            );
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        style: Theme.of(context).textTheme.headlineMedium,
        children: [
          TextSpan(
            text: 'My',
            style: textStyle,
          ),
          TextSpan(
            text: 'Putt',
            style: textStyle?.copyWith(color: MyPuttColors.lightBlue),
          ),
        ],
      ),
    );
  }
}
