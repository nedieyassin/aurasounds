import 'dart:ui';

import 'package:aurasounds/controller/nav_controller.dart';
import 'package:aurasounds/view/home_screen.dart';
import 'package:aurasounds/view/library_screen.dart';
import 'package:aurasounds/view/playing_screen.dart';
import 'package:aurasounds/view/settings_screen.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NavHost extends StatelessWidget {
  NavHost({Key? key}) : super(key: key);
  var navController = Get.find<NavController>();
  final PageController pageController = PageController();

  void scrollTo(int page) {
    // pageController.animateToPage(
    //   page,
    //   duration: const Duration(milliseconds: 500),
    //   curve: Curves.linear,
    // );
    pageController.jumpToPage(page);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView(
            controller: pageController,
            onPageChanged: (int index) {
              navController.navigateTo(index);
            },
            children: <Widget>[
              HomeScreen(),
              PlayingScreen(),
              LibraryScreen(),
              SettingsScreen(),
            ],
          ),
          GetX<NavController>(builder: (controller) {
            return AnimatedPositioned(
              bottom: controller.currentIndex.value == 1 ? -72 : 0,
              duration: const Duration(milliseconds: 300),
              child: ClipRRect(
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                  child: Container(
                    height: 72,
                    width: MediaQuery.of(context).size.width,
                    color: Theme.of(context).primaryColor.withOpacity(.02),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        IconButton(
                          tooltip: 'Home',
                          icon: Icon(
                            EvaIcons.homeOutline,
                            color: controller.currentIndex.value == 0
                                ? Theme.of(context).primaryColor
                                : Colors.grey.shade700,
                            size: 28,
                          ),
                          onPressed: () {
                            if (controller.currentIndex.value != 0) {
                              navController.navigateTo(0);
                              scrollTo(0);
                            }
                          },
                        ),
                        IconButton(
                          tooltip: 'Now Playing',
                          icon: Icon(
                            EvaIcons.playCircleOutline,
                            color: controller.currentIndex.value == 1
                                ? Theme.of(context).primaryColor
                                : Colors.grey.shade700,
                            size: 28,
                          ),
                          onPressed: () {
                            if (controller.currentIndex.value != 1) {
                              navController.navigateTo(1);
                              scrollTo(1);
                            }
                          },
                        ),
                        IconButton(
                          tooltip: 'Library',
                          icon: Icon(
                            EvaIcons.listOutline,
                            color: controller.currentIndex.value == 2
                                ? Theme.of(context).primaryColor
                                : Colors.grey.shade700,
                            size: 28,
                          ),
                          onPressed: () {
                            if (controller.currentIndex.value != 2) {
                              navController.navigateTo(2);
                              scrollTo(2);
                            }
                          },
                        ),
                        IconButton(
                          tooltip: 'Settings',
                          icon: Icon(
                            EvaIcons.settings2Outline,
                            color: controller.currentIndex.value == 3
                                ? Theme.of(context).primaryColor
                                : Colors.grey.shade700,
                            size: 28,
                          ),
                          onPressed: () {
                            if (controller.currentIndex.value != 3) {
                              navController.navigateTo(3);
                              scrollTo(3);
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          })
        ],
      ),
    );
  }
}
