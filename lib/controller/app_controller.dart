import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';

class AppController extends GetxController {
  var appThemeColor = Colors.pink.obs;
  var appThemeMode = ThemeMode.dark.obs;
  var appThemeModeText = 'system'.obs;
  var appThemeColorText = 'pink'.obs;

  initColor() async {
    String theme = Hive.box('app').get('app_theme', defaultValue: 'pink');
    String themeMode = Hive.box('app').get('app_theme_mode',
        defaultValue:
            'system'); // prefs.getString('app_theme_mode') ?? 'system';
    changeTheme(theme);
    changeThemeMode(themeMode);
  }

  @override
  void onInit() {
    super.onInit();
    initColor();
  }

  MaterialColor getColor(String name) {
    if (name == 'pink') {
      return Colors.pink;
    } else if (name == 'purple') {
      return Colors.purple;
    } else if (name == 'green') {
      return Colors.green;
    } else if (name == 'orange') {
      return Colors.orange;
    } else if (name == 'indigo') {
      return Colors.indigo;
    } else if (name == 'brown') {
      return Colors.brown;
    } else if (name == 'red') {
      return Colors.red;
    } else if (name == 'teal') {
      return Colors.teal;
    } else if (name == 'blue') {
      return Colors.blue;
    } else if (name == 'lime') {
      return Colors.lime;
    } else if (name == 'cyan') {
      return Colors.cyan;
    } else if (name == 'amber') {
      return Colors.amber;
    } else {
      return Colors.pink;
    }
  }

  ThemeMode getThemeMode(String name) {
    if (name == 'light') {
      return ThemeMode.light;
    } else if (name == 'dark') {
      return ThemeMode.dark;
    } else {
      return ThemeMode.system;
    }
  }

  Future<void> changeTheme(String color) async {
    appThemeColor.value = getColor(color);
    appThemeColorText.value = color;
    Hive.box('app').put('app_theme', color);
  }

  Future<void> changeThemeMode(String color) async {
    appThemeMode.value = getThemeMode(color);
    appThemeModeText.value = color;
    Hive.box('app').put('app_theme_mode', color);
  }
}
