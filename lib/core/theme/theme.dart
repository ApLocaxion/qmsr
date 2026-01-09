import 'package:flutter/material.dart';

class Themes {
  final darkTheme = ThemeData.dark().copyWith(
    textTheme: Typography.blackCupertino.apply(fontFamily: "SFPro"),
    colorScheme: const ColorScheme(
      brightness: Brightness.dark,

      primary: Color.fromARGB(255, 124, 159, 202),
      secondary: Color.fromARGB(255, 1, 47, 107),

      // Dark mode surfaces (iOS-style)
      surface: Color.fromARGB(255, 33, 33, 36),
      surfaceContainerHighest: Color(0xFF2C2C2E),

      error: Color(0xFFFF3B30),
      scrim: Color(0xFFFF9500),
      surfaceTint: Color(0xFF34C759),

      onPrimary: Color.fromARGB(255, 240, 240, 240),
      onSecondary: Color.fromARGB(255, 240, 240, 240),
      onError: Colors.white,

      onSurface: Color.fromARGB(255, 240, 240, 240),
      onSurfaceVariant: Color(0xFFB0B0B0),

      tertiary: Color(0xFFD1D5DB),
      tertiaryFixed: Color.fromARGB(255, 239, 239, 243),
    ),

    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF1C1C1E),
      elevation: 0,
      foregroundColor: Colors.white,
    ),

    scaffoldBackgroundColor: const Color(0xFF000000),
  );
}
