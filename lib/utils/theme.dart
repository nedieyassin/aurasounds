import 'package:flutter/material.dart';

ThemeData lightTheme(MaterialColor color) => ThemeData(
      brightness: Brightness.light,
      primarySwatch: color,
    );

ThemeData darkTheme(MaterialColor color) => ThemeData(
      brightness: Brightness.dark,
      primarySwatch: color,
      primaryColor: color,
      splashColor: color,
      accentColor: color,
      scaffoldBackgroundColor: const Color(0xFF090909),
    );
