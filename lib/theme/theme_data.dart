import 'package:flutter/material.dart';
import 'package:myputt/utils/colors.dart';

ThemeData lightTheme(BuildContext context) {
  final textTheme = Theme.of(context).textTheme;

  return ThemeData(
    scaffoldBackgroundColor: MyPuttColors.white,
    canvasColor: MyPuttColors.white,
    visualDensity: VisualDensity.adaptivePlatformDensity,
    highlightColor: Colors.transparent,
    splashColor: Colors.transparent,
    textTheme: const TextTheme(
      headline1: TextStyle(
        fontFamily: 'Inter',
        color: MyPuttColors.darkGray,
        fontSize: 80,
        height: 1.15,
        fontWeight: FontWeight.normal,
      ),
      headline2: TextStyle(
        fontFamily: 'Inter',
        color: MyPuttColors.darkGray,
        fontSize: 64,
        height: 1.125,
        fontWeight: FontWeight.normal,
      ),
      headline3: TextStyle(
        fontFamily: 'Inter',
        color: MyPuttColors.darkGray,
        fontSize: 48,
        height: 1.167,
        fontWeight: FontWeight.normal,
      ),
      headline4: TextStyle(
        fontFamily: 'Inter',
        color: MyPuttColors.darkGray,
        fontSize: 32,
        height: 1.125,
        fontWeight: FontWeight.normal,
      ),
      headline5: TextStyle(
        fontFamily: 'Inter',
        color: MyPuttColors.darkGray,
        fontSize: 24,
        height: 1.17,
        fontWeight: FontWeight.normal,
      ),
      headline6: TextStyle(
        fontFamily: 'Inter',
        color: MyPuttColors.darkGray,
        fontSize: 18,
        height: 1.22,
        fontWeight: FontWeight.normal,
      ),
      subtitle1: TextStyle(
        fontFamily: 'Inter',
        color: MyPuttColors.darkGray,
        fontSize: 16,
        height: 1.25,
        fontWeight: FontWeight.normal,
      ),
      subtitle2: TextStyle(
        fontFamily: 'Inter',
        color: MyPuttColors.darkGray,
        fontSize: 14,
        height: 1.28,
        fontWeight: FontWeight.normal,
      ),
      bodyText1: TextStyle(
        fontFamily: 'Inter',
        color: MyPuttColors.darkGray,
        fontSize: 12,
        height: 1.33,
        fontWeight: FontWeight.normal,
      ),
      bodyText2: TextStyle(
        fontFamily: 'Inter',
        color: MyPuttColors.darkGray,
        fontSize: 10,
        height: 1.2,
        fontWeight: FontWeight.normal,
      ),
      button: TextStyle(
        fontFamily: 'Inter',
        color: MyPuttColors.darkGray,
        fontSize: 16,
        height: 1.25,
        fontWeight: FontWeight.normal,
      ),
      caption: TextStyle(
        fontFamily: 'Inter',
        color: MyPuttColors.darkGray,
        fontSize: 12,
        height: 1.33,
        fontWeight: FontWeight.normal,
      ),
      overline: TextStyle(
        fontFamily: 'Inter',
        color: MyPuttColors.darkGray,
        fontSize: 12,
        height: 1.33,
        fontWeight: FontWeight.normal,
      ),
    ),
  );
}
