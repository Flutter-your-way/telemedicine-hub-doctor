import 'package:flutter/material.dart';

class GradientTheme extends ThemeExtension<GradientTheme> {
  final Gradient backgroundGradient;

  const GradientTheme({required this.backgroundGradient});

  @override
  ThemeExtension<GradientTheme> copyWith({Gradient? backgroundGradient}) {
    return GradientTheme(
      backgroundGradient: backgroundGradient ?? this.backgroundGradient,
    );
  }

  @override
  ThemeExtension<GradientTheme> lerp(
      ThemeExtension<GradientTheme>? other, double t) {
    if (other is! GradientTheme) {
      return this;
    }
    return GradientTheme(
      backgroundGradient:
          Gradient.lerp(backgroundGradient, other.backgroundGradient, t)!,
    );
  }
}
