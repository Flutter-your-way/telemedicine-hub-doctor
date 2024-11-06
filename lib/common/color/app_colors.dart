
import 'package:flutter/material.dart';

class AppColors {
  /// 212121
  static Color black = const Color(0xFF212121);

  static Color yellow = const Color(0xFFFFAB00);

  /// D0D2D5
  static Color greyOutline = const Color(0xFFD0D2D5);

  /// A0A0A0
  static Color grey = const Color(0xFFA0A0A0);

  /// 015988
  static Color primaryBlue = const Color(0xFF015988);

  /// ECFAF2
  static Color lightGreen = const Color(0xFFECFAF2);

  /// F1FAFF
  static Color lightBlue = const Color(0xFFF1FAFF);

  /// F1FAFF
  static Color backgroundColor = const Color(0xFFF1FAFF);

  /// 8083A3
  static Color captionColor = const Color(0xFF8083A3);

  /// EAF6ED
  static Color greenishWhite = const Color(0xFFEAF6ED);

  /// 0065FF
  static Color blue = const Color(0xFF0065FF);

  /// 8083A3
  static Color cardCaption = const Color(0xFF8083A3);

  /// EAF8FF
  static Color bluishWhite = const Color(0xFFEAF8FF);

  static Gradient backgroundGradient = const LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomCenter,
    colors: <Color>[
      Color(0xFFF1FAFF),
      Color(0xFFF6FCFF),
      Color(0xFFF5FBFF),
      Color(0xFFFFFFFF),
    ],
  );
}
