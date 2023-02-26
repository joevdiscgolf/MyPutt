import 'package:flutter/material.dart';
import 'package:myputt/utils/colors.dart';

ThemeData lightTheme(BuildContext context) {
  return ThemeData(
    scaffoldBackgroundColor: MyPuttColors.white,
    canvasColor: MyPuttColors.white,
    visualDensity: VisualDensity.adaptivePlatformDensity,
    highlightColor: Colors.transparent,
    splashColor: Colors.transparent,
    textTheme: const TextTheme(
      displayLarge: TextStyle(
        fontFamily: 'Inter',
        color: MyPuttColors.darkGray,
        fontSize: 80,
        height: 1.15,
        fontWeight: FontWeight.normal,
      ),
      displayMedium: TextStyle(
        fontFamily: 'Inter',
        color: MyPuttColors.darkGray,
        fontSize: 64,
        height: 1.125,
        fontWeight: FontWeight.normal,
      ),
      displaySmall: TextStyle(
        fontFamily: 'Inter',
        color: MyPuttColors.darkGray,
        fontSize: 48,
        height: 1.167,
        fontWeight: FontWeight.normal,
      ),
      headlineMedium: TextStyle(
        fontFamily: 'Inter',
        color: MyPuttColors.darkGray,
        fontSize: 32,
        height: 1.125,
        fontWeight: FontWeight.normal,
      ),
      headlineSmall: TextStyle(
        fontFamily: 'Inter',
        color: MyPuttColors.darkGray,
        fontSize: 24,
        height: 1.17,
        fontWeight: FontWeight.normal,
      ),
      titleLarge: TextStyle(
        fontFamily: 'Inter',
        color: MyPuttColors.darkGray,
        fontSize: 18,
        height: 1.22,
        fontWeight: FontWeight.normal,
      ),
      titleMedium: TextStyle(
        fontFamily: 'Inter',
        color: MyPuttColors.darkGray,
        fontSize: 16,
        height: 1.25,
        fontWeight: FontWeight.normal,
      ),
      titleSmall: TextStyle(
        fontFamily: 'Inter',
        color: MyPuttColors.darkGray,
        fontSize: 14,
        height: 1.28,
        fontWeight: FontWeight.normal,
      ),
      bodyLarge: TextStyle(
        fontFamily: 'Inter',
        color: MyPuttColors.darkGray,
        fontSize: 12,
        height: 1.33,
        fontWeight: FontWeight.normal,
      ),
      bodyMedium: TextStyle(
        fontFamily: 'Inter',
        color: MyPuttColors.darkGray,
        fontSize: 10,
        height: 1.2,
        fontWeight: FontWeight.normal,
      ),
      labelLarge: TextStyle(
        fontFamily: 'Inter',
        color: MyPuttColors.darkGray,
        fontSize: 16,
        height: 1.25,
        fontWeight: FontWeight.normal,
      ),
      bodySmall: TextStyle(
        fontFamily: 'Inter',
        color: MyPuttColors.darkGray,
        fontSize: 12,
        height: 1.33,
        fontWeight: FontWeight.normal,
      ),
      labelSmall: TextStyle(
        fontFamily: 'Inter',
        color: MyPuttColors.darkGray,
        fontSize: 12,
        height: 1.33,
        fontWeight: FontWeight.normal,
      ),
    ),
  );
}
