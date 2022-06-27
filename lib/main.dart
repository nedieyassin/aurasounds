import 'package:aurasounds/controller/app_controller.dart';
import 'package:aurasounds/controller/nav_controller.dart';
import 'package:aurasounds/controller/player_controller.dart';
import 'package:aurasounds/utils/theme.dart';
import 'package:aurasounds/view/nav_host.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:just_audio_background/just_audio_background.dart';

Future<void> main() async {
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      systemNavigationBarColor: Colors.transparent, // navigation bar color
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark // status bar color
      ));
  await JustAudioBackground.init(
    androidNotificationChannelId: 'com.ryanheise.bg_demo.channel.audio',
    androidNotificationChannelName: 'Audio playback',
    androidNotificationOngoing: true,
  );
  runApp(const Aura());
}

class Aura extends StatelessWidget {
  const Aura({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    Get.put(NavController());
    Get.put(PlayerController());
    Get.put(AppController());

    return GetX<AppController>(builder: (controller) {
      return GetMaterialApp(
        title: 'asurasounds',
        theme: lightTheme(controller.appThemeColor.value),
        debugShowCheckedModeBanner: false,
        home: NavHost(),
      );
    });
  }
}
