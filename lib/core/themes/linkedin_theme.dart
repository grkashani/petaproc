import 'package:flutter/material.dart';

import '../constant/constants.dart';

class LinkedinTheme {
  static ThemeData lightTheme = ThemeData(
    textTheme: const TextTheme(
      bodyLarge: TextStyle(fontFamily: 'IRAN-T'),
      bodyMedium: TextStyle(fontFamily: 'IRAN-R'),
      displayLarge: TextStyle(fontFamily: 'IRAN-B'),
    ),
  );
  static ThemeData darkTheme = ThemeData(
    scaffoldBackgroundColor: bgColor,
    canvasColor: secondaryColor,
    textTheme: const TextTheme(
      bodyLarge: TextStyle(fontFamily: 'IRAN-T'),
      bodyMedium: TextStyle(fontFamily: 'IRAN-R'),
      displayLarge: TextStyle(fontFamily: 'IRAN-B'),
    ),
  );
}
