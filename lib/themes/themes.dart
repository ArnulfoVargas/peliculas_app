
import 'package:flutter/material.dart';

class Themes{
  static Color primaryColor = Colors.amberAccent;

  static ThemeData lightTheme = ThemeData.light().copyWith(
    appBarTheme: AppBarTheme(centerTitle: true, color: primaryColor, elevation: 0),
  );
} 