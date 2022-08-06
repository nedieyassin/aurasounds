import 'dart:ui';
import 'package:aurasounds/controller/nav_controller.dart';
import 'package:aurasounds/controller/player_controller.dart';
import 'package:aurasounds/utils/constants.dart';
import 'package:aurasounds/utils/helpers.dart';
import 'package:aurasounds/view/components/mini_player.dart';
import 'package:aurasounds/view/screens/home_screen.dart';
import 'package:aurasounds/view/screens/library_screen.dart';
import 'package:aurasounds/view/screens/playing_screen.dart';
import 'package:aurasounds/view/screens/settings_screen.dart';
import 'package:aurasounds/view/screens/youtube_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:line_icons/line_icons.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:on_audio_query/on_audio_query.dart';

class NavHost extends StatelessWidget {
  NavHost({Key? key}) : super(key: key);
  var navController = Get.find<NavController>();

  void scrollTo(int page) {
    navController.pageController.value.jumpToPage(page);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          PageView(
            controller: navController.pageController.value,
            onPageChanged: (int index) {
              navController.navigateTo(index);
            },
            children: const <Widget>[
              HomeScreen(),
              LibraryScreen(),
              YoutubeScreen(),
            ],
          ),
          GetX<NavController>(
            builder: (controller) {
              Color bcolor = Get.isDarkMode ? Colors.black : Colors.white;
              Color fcolor = Get.isDarkMode ? Colors.white : Colors.black;
              return Positioned(
                bottom: 0,
                child: ClipRRect(
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 30.0, sigmaY: 30.0),
                    child: Column(
                      children: [
                        GetX<PlayerController>(builder: (controller) {
                          return controller.id.value.isNotEmpty
                              ? const MiniPlayer()
                              : Container();
                        }),
                        Container(
                          height: 80,
                          width: MediaQuery.of(context).size.width,
                          color: bcolor.withOpacity(.2),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  IconButton(
                                    tooltip: 'Home',
                                    splashColor: Colors.transparent,
                                    icon: Icon(
                                      Icons.headphones_rounded,
                                      color: controller.currentIndex.value == 0
                                          ? Theme.of(context).primaryColor
                                          : fcolor.withOpacity(.7),
                                      size: 28,
                                    ),
                                    onPressed: () {
                                      if (controller.currentIndex.value != 0) {
                                        navController.navigateTo(0);
                                        scrollTo(0);
                                      }
                                    },
                                  ),
                                  const Text('Home')
                                ],
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  IconButton(
                                    tooltip: 'Library',
                                    splashColor: Colors.transparent,
                                    icon: Icon(
                                      Icons.queue_music_outlined,
                                      color: controller.currentIndex.value == 1
                                          ? Theme.of(context).primaryColor
                                          : fcolor.withOpacity(.7),
                                      size: 28,
                                    ),
                                    onPressed: () {
                                      if (controller.currentIndex.value != 1) {
                                        navController.navigateTo(1);
                                        scrollTo(1);
                                      }
                                    },
                                  ),
                                  const Text('Library')
                                ],
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  IconButton(
                                    tooltip: 'Youtube',
                                    splashColor: Colors.transparent,
                                    icon: Icon(
                                      LineIcons.youtube,
                                      color: controller.currentIndex.value == 2
                                          ? Theme.of(context).primaryColor
                                          : fcolor.withOpacity(.7),
                                      size: 28,
                                    ),
                                    onPressed: () {
                                      if (controller.currentIndex.value != 2) {
                                        navController.navigateTo(2);
                                        scrollTo(2);
                                      }
                                    },
                                  ),
                                  const Text('Youtube Music')
                                ],
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  IconButton(
                                    tooltip: 'Youtube',
                                    splashColor: Colors.transparent,
                                    icon: Icon(
                                      Icons.settings,
                                      color: fcolor.withOpacity(.7),
                                      size: 28,
                                    ),
                                    onPressed: () {
                                      // if (controller.currentIndex.value != 3) {
                                      //   navController.navigateTo(3);
                                      //   scrollTo(3);
                                      // }
                                      Get.to(const SettingsScreen());
                                    },
                                  ),
                                  const Text(
                                    'Settings',
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          )
        ],
      ),
    );
  }
}

