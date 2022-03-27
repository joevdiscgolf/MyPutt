import 'package:flutter/material.dart';

class HexColor extends Color {
  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF" + hexColor;
    }
    return int.parse(hexColor, radix: 16);
  }

  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));
}

extension ColorExtension on Color {
  /// Convert the color to a darken color based on the [percent]
  Color darken([int percent = 40]) {
    assert(1 <= percent && percent <= 100);
    final value = 1 - percent / 100;
    return Color.fromARGB(alpha, (red * value).round(), (green * value).round(),
        (blue * value).round());
  }
}

class CustomColor extends ColorSwatch<int> {
  final Map<int, Color> swatch;

  const CustomColor(int primary, this.swatch) : super(primary, swatch);

  /// The lightest shade.
  Color? get shade50 => this[50];

  /// The second lightest shade.
  Color get shade100 => this[100]!;

  /// The third lightest shade.
  Color get shade200 => this[200]!;

  /// The fourth lightest shade.
  Color get shade300 => this[300]!;

  /// The fifth lightest shade.
  Color get shade400 => this[400]!;

  /// The default shade.
  Color get shade500 => this[500]!;

  /// The fourth darkest shade.
  Color get shade600 => this[600]!;

  /// The third darkest shade.
  Color get shade700 => this[700]!;

  /// The second darkest shade.
  Color get shade800 => this[800]!;

  /// The darkest shade.
  Color get shade900 => this[900]!;

  MaterialColor get asMaterialColor {
    return MaterialColor(shade500.value, swatch);
  }
}

class MyPuttColors {
  static const CustomColor gray = CustomColor(_grayPrimaryValue, {
    50: Color(0xffF7F7F7),
    100: Color(0xffEBEBEB),
    200: Color(0xffDDDDDD),
    300: Color(0xffB0B0B0),
    400: Color(0xff717171),
    500: Color(_grayPrimaryValue),
    600: Color(0xff3F3F3F),
    700: Color(0xff212121),
    800: Color(0xff111111),
    900: Color(0xff000000),
  });
  static const int _grayPrimaryValue = (0xff535353);

  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xff000000);
  static const Color darkGray = Color(0xff111111);
  static const Color green = Color(0xff31b00b);
  static const Color lightGreen = Color(0xff00de64);
  static const Color blue = Color(0xFF2196F3);
  static const Color lightBlue = Color(0xff00bbff);
  static const Color skyBlue = Color(0xff8DCDFF);
  static const Color faintBlue = Color(0xff97dfff);
  static const Color darkBlue = Color(0xff0E7DD6);
  static const Color shadowColor = Color(0x1F000000);
  static const Color red = Color(0xffFF5151);
  static const Color darkRed = Color(0xffef1919);
  static const Color purple = Color(0xff5f3df8);
  static const Color pink = Color(0xffed54ff);
  static const Color orange = Color(0xffffad14);
}

final Map<Color, String> myPuttColorToHex = {
  MyPuttColors.purple: '5f3df8',
  MyPuttColors.blue: '2196F3',
  MyPuttColors.green: '31b00b',
  MyPuttColors.pink: 'ed54ff',
  MyPuttColors.red: 'FF5151',
};

Color getColorFromDifference(int difference) {
  if (difference > 0) {
    return MyPuttColors.darkBlue;
  } else if (difference < 0) {
    return MyPuttColors.darkRed;
  } else {
    return MyPuttColors.gray[400]!;
  }
}
