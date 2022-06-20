import 'dart:ui';
import 'package:aurasounds/controller/nav_controller.dart';
import 'package:aurasounds/controller/player_controller.dart';
import 'package:aurasounds/utils/constants.dart';
import 'package:aurasounds/utils/helpers.dart';
import 'package:aurasounds/view/folder_screen.dart';
import 'package:aurasounds/view/home_screen.dart';
import 'package:aurasounds/view/library_screen.dart';
import 'package:aurasounds/view/playing_screen.dart';
import 'package:aurasounds/view/settings_screen.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
      body: Stack(
        children: [
          PageView(
            controller: navController.pageController.value,
            onPageChanged: (int index) {
              navController.navigateTo(index);
            },
            children: <Widget>[
              HomeScreen(),
              LibraryScreen(),
              FolderScreen(),
              SettingsScreen(),
            ],
          ),
          GetX<NavController>(
            builder: (controller) {
              return Positioned(
                bottom: 0,
                child: ClipRRect(
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 30.0, sigmaY: 30.0),
                    child: Column(
                      children: [
                        GetX<PlayerController>(
                          builder: (controller) {
                            return controller.id.value.isNotEmpty ? const MiniPlayer() : Container();
                          }
                        ),
                        Container(
                          height: 72,
                          width: MediaQuery.of(context).size.width,
                          color: Colors.white.withOpacity(.2),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              IconButton(
                                tooltip: 'Home',
                                icon: Icon(
                                  controller.currentIndex.value == 0
                                      ? EvaIcons.headphones
                                      : EvaIcons.headphonesOutline,
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
                                tooltip: 'Library',
                                icon: Icon(
                                  controller.currentIndex.value == 1
                                      ? EvaIcons.list
                                      : EvaIcons.listOutline,
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
                                tooltip: 'Folders',
                                icon: Icon(
                                  controller.currentIndex.value == 2
                                      ? EvaIcons.folder
                                      : EvaIcons.folderOutline,
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
                                  controller.currentIndex.value == 3
                                      ? EvaIcons.settings2
                                      : EvaIcons.settings2Outline,
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

class MiniPlayer extends StatelessWidget {
  const MiniPlayer({
    Key? key,
  }) : super(key: key);

  void openNowPlaying(BuildContext context) {
    showMaterialModalBottomSheet(
      context: context,
      builder: (context) => PlayingScreen(),
    );
    // Get.bottomSheet(FolderSongsBottomSheet(), isScrollControlled: true);
  }

  @override
  Widget build(BuildContext context) {
    return GetX<PlayerController>(builder: (controller) {
      return Container(
        width: MediaQuery.of(context).size.width,
        color: Colors.white.withOpacity(.1),
        child: ListTile(
          onTap: (){
            openNowPlaying(context);
          },
          contentPadding: const EdgeInsets.symmetric(
              horizontal: 10, vertical: 0),
          leading: ClipRRect(
            borderRadius: BorderRadius.circular(99),
            child: QueryArtworkWidget(
              id: int.parse(controller.id.value),
              type: ArtworkType.AUDIO,
              artworkBorder: BorderRadius.zero,
              nullArtworkWidget: Image.asset(
                'lib/assets/art.png',
                fit: BoxFit.cover,
                height: 48,
              ),
            ),
          ),
          title: Text(
            controller.getMeta(controller.title.value),
            style: xtitle.copyWith(fontSize: 18),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          subtitle: StreamBuilder<Duration>(
              stream: controller.hasCurrent.value
                  ? controller.player.value.positionStream
                  : const Stream.empty(),
              builder: (context, snapshot) {
                int? current = snapshot.hasData
                    ? snapshot.data!.inMilliseconds
                    : 0;

                return Row(
                  mainAxisAlignment:
                      MainAxisAlignment.spaceBetween,
                  crossAxisAlignment:
                      CrossAxisAlignment.center,
                  children: [
                    Text(
                      formatDuration(
                        Duration(milliseconds: current),
                      ),
                    ),
                  ],
                );
              }),
          trailing: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              borderRadius: BorderRadius.circular(99),
            ),
            child: IconButton(
              iconSize: 30,
              onPressed: () {
                controller.play();
              },
              color: Colors.white,
              splashColor: Theme.of(context)
                  .primaryColor
                  .withOpacity(.5),
              icon: StreamBuilder<bool>(
                  stream:
                      controller.player.value.playingStream,
                  builder: (context, asyncSnapshot) {
                    if (asyncSnapshot.hasData) {
                      bool playing =
                          asyncSnapshot.data as bool;
                      return Icon(playing
                          ? Icons.pause_rounded
                          : Icons.play_arrow_rounded);
                    } else {
                      return const Icon(
                          Icons.play_arrow_outlined);
                    }
                  }),
            ),
          ),
        ),
      );
    });
  }
}
