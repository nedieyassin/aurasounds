import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AppController extends GetxController {
  var appThemeColor = Colors.pink.obs;

  void changeTheme(MaterialColor color) {
    appThemeColor.value = color;
  }
}
