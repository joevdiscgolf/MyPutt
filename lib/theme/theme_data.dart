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
    textTheme: TextTheme(
      headline1: TextStyle(
        fontFamily: 'Inter',
        color: MyPuttColors.gray[800],
        fontSize: 80,
        height: 1.15,
        fontWeight: FontWeight.normal,
      ),
      headline2: TextStyle(
        fontFamily: 'Inter',
        color: MyPuttColors.gray[800],
        fontSize: 64,
        height: 1.125,
        fontWeight: FontWeight.normal,
      ),
      headline3: TextStyle(
        fontFamily: 'Inter',
        color: MyPuttColors.gray[800],
        fontSize: 48,
        height: 1.167,
        fontWeight: FontWeight.normal,
      ),
      headline4: TextStyle(
        fontFamily: 'Inter',
        color: MyPuttColors.gray[800],
        fontSize: 32,
        height: 1.125,
        fontWeight: FontWeight.normal,
      ),
      headline5: TextStyle(
        fontFamily: 'Inter',
        color: MyPuttColors.gray[800],
        fontSize: 24,
        height: 1.17,
        fontWeight: FontWeight.normal,
      ),
      headline6: TextStyle(
        fontFamily: 'Inter',
        color: MyPuttColors.gray[800],
        fontSize: 18,
        height: 1.22,
        fontWeight: FontWeight.normal,
      ),
      subtitle1: TextStyle(
        fontFamily: 'Inter',
        color: MyPuttColors.gray[800],
        fontSize: 16,
        height: 1.25,
        fontWeight: FontWeight.normal,
      ),
      subtitle2: TextStyle(
        fontFamily: 'Inter',
        color: MyPuttColors.gray[800],
        fontSize: 14,
        height: 1.28,
        fontWeight: FontWeight.normal,
      ),
      bodyText1: TextStyle(
        fontFamily: 'Inter',
        color: MyPuttColors.gray[800],
        fontSize: 12,
        height: 1.33,
        fontWeight: FontWeight.normal,
      ),
      bodyText2: TextStyle(
        fontFamily: 'Inter',
        color: MyPuttColors.gray[800],
        fontSize: 10,
        height: 1.2,
        fontWeight: FontWeight.normal,
      ),
      button: TextStyle(
        fontFamily: 'Inter',
        color: MyPuttColors.gray[800],
        fontSize: 16,
        height: 1.25,
        fontWeight: FontWeight.normal,
      ),
      caption: TextStyle(
        fontFamily: 'Inter',
        color: MyPuttColors.gray[800],
        fontSize: 12,
        height: 1.33,
        fontWeight: FontWeight.normal,
      ),
      overline: TextStyle(
        fontFamily: 'Inter',
        color: MyPuttColors.gray[800],
        fontSize: 12,
        height: 1.33,
        fontWeight: FontWeight.normal,
      ),
    ),
  );

  // return ThemeData(
  //   scaffoldBackgroundColor: Colors.white,
  //   canvasColor: Colors.white,
  //   visualDensity: VisualDensity.adaptivePlatformDensity,
  //   highlightColor: TWUIColors.gray[100]!,
  //   splashColor: TWUIColors.gray[100]!,
  //   textTheme: GoogleFonts.workSansTextTheme(textTheme).copyWith(
  //     headline1: GoogleFonts.workSans(
  //       color: TWUIColors.gray[800],
  //       fontSize: 80,
  //       height: 1.15,
  //       fontWeight: FontWeight.bold,
  //     ),
  //     headline2: GoogleFonts.workSans(
  //       color: TWUIColors.gray[800],
  //       fontSize: 64,
  //       height: 1.125,
  //       fontWeight: FontWeight.bold,
  //     ),
  //     headline3: GoogleFonts.workSans(
  //       color: TWUIColors.gray[800],
  //       fontSize: 48,
  //       height: 1.125,
  //       fontWeight: FontWeight.bold,
  //     ),
  //     headline4: GoogleFonts.workSans(
  //       color: TWUIColors.gray[800],
  //       fontSize: 32,
  //       height: 1.125,
  //       fontWeight: FontWeight.bold,
  //     ),
  //     headline5: GoogleFonts.workSans(
  //       color: TWUIColors.gray[800],
  //       fontSize: 24,
  //       height: 1.17,
  //       fontWeight: FontWeight.bold,
  //     ),
  //     headline6: GoogleFonts.workSans(
  //       color: TWUIColors.gray[800],
  //       fontSize: 18,
  //       height: 1.22,
  //       fontWeight: FontWeight.w600,
  //     ),
  //     subtitle1: GoogleFonts.workSans(
  //       color: TWUIColors.gray[800],
  //       fontSize: 16,
  //       height: 1.25,
  //     ),
  //     subtitle2: GoogleFonts.workSans(
  //       color: TWUIColors.gray[800],
  //       fontSize: 14,
  //       height: 1.28,
  //     ),
  //     bodyText1: GoogleFonts.workSans(
  //       color: TWUIColors.gray[800],
  //       fontSize: 15,
  //       height: 1.33,
  //     ),
  //     bodyText2: GoogleFonts.workSans(
  //       color: TWUIColors.gray[800],
  //       fontSize: 13,
  //       height: 1.2,
  //     ),
  //     button: GoogleFonts.workSans(
  //       color: TWUIColors.gray[800],
  //       fontSize: 16,
  //       fontWeight: FontWeight.w600,
  //     ),
  //     caption: GoogleFonts.workSans(
  //       color: TWUIColors.gray[800],
  //       fontSize: 12,
  //       height: 1.2,
  //     ),
  //     overline: GoogleFonts.workSans(
  //       color: TWUIColors.gray[800],
  //       fontSize: 12,
  //       height: 1.2,
  //     ),
  //   ),
  // );
}
