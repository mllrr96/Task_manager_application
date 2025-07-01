import 'package:flutter/material.dart';

import 'color_palette.dart';

class AppTheme {
  AppTheme._();

  static final ThemeData light = ThemeData(
    fontFamily: 'Sora',
    canvasColor: Colors.transparent,
    colorScheme: ColorScheme.fromSeed(seedColor: kPrimaryColor),
    useMaterial3: true,
  ).copyWith(
    scaffoldBackgroundColor: Colors.white,
    filledButtonTheme: FilledButtonThemeData(
      style: ButtonStyle(
        shape: WidgetStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        backgroundColor: WidgetStateProperty.all(Color(0xFFB0AFAF)),
      ),
    ),
  );

  static final ThemeData dark = ThemeData(
    fontFamily: 'Sora',
    canvasColor: Colors.transparent,
    colorScheme: ColorScheme.fromSeed(
      seedColor: kPrimaryColor,
      brightness: Brightness.dark,
    ),
    useMaterial3: true,
  ).copyWith(
    filledButtonTheme: FilledButtonThemeData(
      style: ButtonStyle(
        shape: WidgetStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    ),
  );
}
