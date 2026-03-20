import 'package:flutter/material.dart';

class CustomTheme {
  static ThemeData fromSeedColor({
    required Color seedColor,
    Brightness brightness = Brightness.light,
    bool darkMode = false,
  }) {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: seedColor,
      brightness: brightness,
      surface: darkMode ? Colors.black : null,
    );

    return ThemeData(
      brightness: brightness,
      colorScheme: colorScheme,
      appBarTheme: AppBarTheme(
        surfaceTintColor: Colors.transparent,
        backgroundColor: colorScheme.surface,
        // shape: Border(bottom: BorderSide(
        //   color: colorScheme.outlineVariant,
        //   width: 1.0,
        // )),
      ),
    );
  }
}