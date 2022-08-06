import 'dart:math';

import 'package:aurasounds/controller/library_controller.dart';
import 'package:aurasounds/controller/player_controller.dart';
import 'package:aurasounds/utils/constants.dart';
import 'package:aurasounds/view/components/tiles/song_tile.dart';
import 'package:aurasounds/view/components/widgets/sorting_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:just_audio_background/just_audio_background.dart';

class SongsTab extends StatelessWidget {
  SongsTab({Key? key}) : super(key: key);

  final playerController = Get.find<PlayerController>();
  final libraryController = Get.find<LibraryController>();

  Future<void> playAudios(int position, {shuffle = false}) async {
    await playerController.startPlaylist(
        position: position,
        playlist: 'allsongs',
        music: libraryController.allSongs.value,
        falseOpen: libraryController.dirtyList.value['allSongs'],
        shuffle: shuffle);
  }

  @override
  Widget build(BuildContext context) {
    Color bcolor = Get.isDarkMode ? Colors.black : Colors.white;
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            GetX<LibraryController>(
              builder: (controller) {
                return Padding(
                  padding: const EdgeInsets.only(
                    top: 10,
                    left: 16,
                    bottom: 8,
                  ),
                  child: Text(
                    '${controller.allSongs.value.length} Songs',
                  ),
                );
              },
            ),
            const Spacer(),
            IconButton(
              onPressed: () async {
                await playAudios(0);
              },
              icon: const Icon(Icons.play_arrow_rounded),
            ),
            // IconButton(
            //   onPressed: () async {
            //     await playAudios(
            //       Random().nextInt(libraryController.allSongs.value.length),
            //       shuffle: true,
            //     );
            //   },
            //   icon: const Icon(Icons.shuffle_rounded),
            // ),
            SortingWidget(),
          ],
        ),
        Expanded(
          child: Scrollbar(
            child: GetX<LibraryController>(
              builder: (controller) {
                return controller.allSongs.value.isNotEmpty
                    ? ListView.builder(
                        physics: const BouncingScrollPhysics(),
                        itemCount: controller.allSongs.value.length,
                        itemBuilder: (BuildContext context, int index) {
                          MediaItem audio = controller.allSongs.value[index];
                          return SongTile(
                            startPlaylist: (int pos) async {
                              await playAudios(pos);
                            },
                            audio: audio,
                            index: index,
                            isLast:
                                index + 1 == controller.allSongs.value.length,
                          );
                        })
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const Icon(
                            Icons.error_outline_outlined,
                            size: 60,
                          ),
                          Center(
                            child: Padding(
                              padding: const EdgeInsets.all(14.0),
                              child: Text(
                                'No Songs',
                                style: xheading,
                              ),
                            ),
                          )
                        ],
                      );
              },
            ),
          ),
        ),
      ],
    );
  }
}
