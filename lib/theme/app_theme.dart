import 'package:flutter/material.dart';

/// Defines the themes for the application.
class AppTheme {
  /// Creates a light theme with the given seed color.
  static ThemeData lightWithSeed(Color seed) => ThemeData(
        useMaterial3: true,
        colorSchemeSeed: seed,
        brightness: Brightness.light,
      );

  /// Creates a dark theme with the given seed color.
  static ThemeData darkWithSeed(Color seed) => ThemeData(
        useMaterial3: true,
        colorSchemeSeed: seed,
        brightness: Brightness.dark,
      );

  /// The default light theme.
  static ThemeData get light => lightWithSeed(Colors.teal);

  /// The default dark theme.
  static ThemeData get dark => darkWithSeed(Colors.teal);
}
