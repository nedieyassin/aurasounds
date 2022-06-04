import 'package:aurasounds/controller/nav_controller.dart';
import 'package:aurasounds/controller/player_controller.dart';
import 'package:aurasounds/controller/playlist_controller.dart';
import 'package:aurasounds/utils/theme.dart';
import 'package:aurasounds/view/nav_host.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    systemNavigationBarColor: Colors.transparent, // navigation bar color
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.dark// status bar color
  ));
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  runApp(const Aura());
}

class Aura extends StatelessWidget {
  const Aura({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(NavController());
    Get.put(PlaylistController());
    Get.put(PlayerController());

    return GetMaterialApp(
      title: 'Aura Sounds',
      theme: lightTheme(),
      debugShowCheckedModeBanner: false,
      home: NavHost(),
    );
  }
}
