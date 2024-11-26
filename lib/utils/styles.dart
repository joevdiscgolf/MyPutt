import 'package:flutter/material.dart';
import 'package:myputt/utils/colors.dart';

abstract class MyPuttStyles {
  static TextStyle? appBarTitleStyle(BuildContext context, {Color? color}) =>
      Theme.of(context).textTheme.titleLarge?.copyWith(
            fontSize: 20,
            color: color ?? MyPuttColors.blue,
            fontWeight: FontWeight.bold,
          );
}
