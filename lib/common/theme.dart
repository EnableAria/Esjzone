import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTheme {
  static ThemeData fromSeedColor({
    required Color seedColor,
    Brightness brightness = Brightness.light,
    bool darkMode = false,
  }) {
    Brightness iconBrightness = brightness == Brightness.light ? Brightness.dark : Brightness.light;
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
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarIconBrightness: iconBrightness, // 状态栏图标颜色
          systemNavigationBarColor: colorScheme.surface, // 导航栏背景色
          systemNavigationBarIconBrightness: iconBrightness// 导航栏图标色
        ),
      ),
    );
  }
}