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
      indicatorColor: color,
      accentColor: Colors.transparent,
      scaffoldBackgroundColor: const Color(0xFF090909),
      cardColor: Colors.grey.shade900
    );
