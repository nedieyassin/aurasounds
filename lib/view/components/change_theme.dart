import 'dart:ui';

import 'package:aurasounds/controller/app_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';

class ChangeTheme extends StatelessWidget {
  ChangeTheme({Key? key}) : super(key: key);
  var appController = Get.find<AppController>();

  List<String> colors = [
    'pink',
    'purple',
    'green',
    'orange',
    'indigo',
    'brown',
    'red',
    'teal',
    'blue',
    'lime',
    'cyan',
    'amber',
  ];

  List<String> themeMode = [
    'light',
    'dark',
    'system',
  ];

  @override
  Widget build(BuildContext context) {
    Color bcolor = Get.isDarkMode ? Colors.black : Colors.white;
    Color fcolor = Get.isDarkMode ? Colors.white : Colors.black;
    return SafeArea(
        child: Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 20),
          child: Stack(
            children: [
              Positioned(
                right: 5,
                bottom: 5,
                child: Container(
                  height: 54,
                  width: 54,
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 30.0, sigmaY: 30.0),
                    child: Container(
                      height: 104,
                      width: 104,
                      child: Center(
                          child: Text(
                        'Aa',
                        style: TextStyle(fontSize: 32),
                      )),
                      decoration: BoxDecoration(
                        color: fcolor.withOpacity(.02),
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        const Padding(
          padding: EdgeInsets.only(top: 20),
          child: Text(
            'Select Theme Mode below',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 18),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: themeMode
                .map((mode) => Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Column(
                        children: [
                          Container(
                            height: 70,
                            width: 70,
                            decoration: BoxDecoration(
                              border: Border.all(
                                width: 4,
                                color:
                                    appController.appThemeModeText.value == mode
                                        ? Theme.of(context).primaryColor
                                        : Colors.transparent,
                              ),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: IconButton(
                              onPressed: () {
                                appController.changeThemeMode(mode);
                              },
                              icon: mode == 'light'
                                  ? const Icon(
                                      Icons.wb_sunny,
                                      size: 40,
                                    )
                                  : (mode == 'dark'
                                      ? const Icon(
                                          Icons.nights_stay,
                                          size: 40,
                                        )
                                      : const Icon(
                                          Icons.settings,
                                          size: 40,
                                        )),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Text(mode),
                          )
                        ],
                      ),
                    ))
                .toList(),
          ),
        ),
        const Padding(
          padding: EdgeInsets.only(top: 40,),
          child: Text(
            'Select Theme Colour  below',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 18),
          ),
        ),
        Padding(
            padding: const EdgeInsets.all(20),
            child: StaggeredGrid.count(
              crossAxisCount: 4,
              mainAxisSpacing: 5,
              crossAxisSpacing: 5,
              children: colors.map((color) {
                return StaggeredGridTile.count(
                    crossAxisCellCount: 1,
                    mainAxisCellCount: 1,
                    child: GestureDetector(
                      onTap: () {
                        appController.changeTheme(color);
                      },
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          border: Border.all(
                            width: 4,
                            color:
                                appController.appThemeColorText.value == color
                                    ? appController.getColor(color)
                                    : Colors.transparent,
                          ),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Container(
                          height: 60,
                          width: 60,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: appController.getColor(color),
                          ),
                        ),
                      ),
                    ));
              }).toList(),
            ))
      ],
    ));
  }
}
