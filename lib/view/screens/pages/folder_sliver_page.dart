import 'dart:math';
import 'dart:ui';

import 'package:aurasounds/controller/library_controller.dart';
import 'package:aurasounds/controller/player_controller.dart';
import 'package:aurasounds/model/type.dart';
import 'package:aurasounds/utils/helpers.dart';
import 'package:aurasounds/view/components/mini_player.dart';
import 'package:aurasounds/view/components/silver_view.dart';
import 'package:aurasounds/view/components/tiles/song_tile.dart';
import 'package:aurasounds/view/components/widgets/list_head_controls.dart';
import 'package:aurasounds/view/components/widgets/sorting_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:line_icons/line_icons.dart';

class FolderSliverPage extends StatelessWidget {
  FolderSliverPage({
    Key? key,
    required this.folder,
  }) : super(key: key);

  final playerController = Get.find<PlayerController>();
  final libraryController = Get.find<LibraryController>();

  final FolderModel folder;

  Future<void> playAudios(int position, {shuffle = false}) async {
    await playerController.startPlaylist(
        position: position,
        playlist: folder.folderUri,
        music: libraryController.folderSongs.value,
        falseOpen: libraryController.dirtyList.value['folderSongs'],
        shuffle: shuffle);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GetX<LibraryController>(builder: (controller) {
        return Stack(
          children: [
            BouncyImageSliverScrollView(
              title: folder.folder,
              actions: [
                SortingWidget(
                  onChange: () =>
                      controller.initGetFolderSongs(folder.folderUri),
                )
              ],
              placeholderImage: 'lib/assets/${getThemedAsset('folder.png')}',
              sliverList: SliverList(
                delegate: controller.folderSongs.value.isNotEmpty
                    ? SliverChildBuilderDelegate(
                        (context, int index) {
                          MediaItem audio = controller.folderSongs.value[index];
                          if (index == 0) {
                            return Column(
                              children: [
                                ListHeadControls(
                                  onPlay: () async {
                                    await playAudios(0);
                                  },
                                  onShuffle: () async {
                                    await playAudios(
                                      Random().nextInt(
                                          controller.folderSongs.value.length),
                                      shuffle: true,
                                    );
                                  },
                                ),
                                SongTile(
                                  startPlaylist: (int pos) async {
                                    await playAudios(pos);
                                  },
                                  audio: audio,
                                  index: index,
                                  isLast: index + 1 ==
                                      controller.folderSongs.value.length,
                                )
                              ],
                            );
                          } else {
                            return SongTile(
                              startPlaylist: (int pos) async {
                                await playAudios(pos);
                              },
                              audio: audio,
                              index: index,
                              isLast: index + 1 ==
                                  controller.folderSongs.value.length,
                            );
                          }
                        },
                        childCount: controller.folderSongs.value.length,
                      )
                    : SliverChildListDelegate([
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 100),
                          child: Center(
                            child: Column(
                              children: const [
                                Icon(
                                  LineIcons.frowningFace,
                                  size: 50,
                                ),
                                Text('No songs found')
                              ],
                            ),
                          ),
                        )
                      ]),
              ),
            ),
            Positioned(
              bottom: 0,
              child: ClipRRect(
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 30.0, sigmaY: 30.0),
                  child: const SafeArea(
                    top: false,
                    child: MiniPlayer(),
                  ),
                ),
              ),
            )
          ],
        );
      }),
    );
  }
}
