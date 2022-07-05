import 'package:aurasounds/controller/player_controller.dart';
import 'package:aurasounds/model/database.dart';
import 'package:aurasounds/utils/constants.dart';
import 'package:aurasounds/view/components/folder_tile.dart';
import 'package:aurasounds/view/components/song_tile.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class AllFoldersPage extends StatelessWidget {
  AllFoldersPage({Key? key}) : super(key: key);

  var playerController = Get.find<PlayerController>();

  Future<void> playAudios(int position, String fv) async {
    await playerController.startPlaylist(
        position: position, playlist: 'foldersongs.$fv');
  }

  void openFolderSongs(BuildContext context) {
    showMaterialModalBottomSheet(
      context: context,
      builder: (context) => FolderSongsBottomSheet(),
    );
    // Get.bottomSheet(FolderSongsBottomSheet(), isScrollControlled: true);
  }

  @override
  Widget build(BuildContext context) {
    Color bcolor = Get.isDarkMode ? Colors.black : Colors.white;
    return Container(
      color: bcolor,
      child: Scrollbar(
        child: GetX<PlayerController>(
          builder: (controller) {
            return controller.noOfAllFolders.value > 0
                ? ListView.builder(
                    itemCount: controller.noOfAllFolders.value,
                    itemBuilder: (BuildContext context, int index) {
                      FolderModel folder = controller.getFolder(index);
                      return FolderTile(
                        isLast: index + 1 == controller.noOfAllFolders.value,
                        folder: folder,
                        folderSongs: () {
                          openFolderSongs(context);
                        },
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
                            'No Folders',
                            style: xheading,
                          ),
                        ),
                      )
                    ],
                  );
          },
        ),
      ),
    );
  }
}

class FolderSongsBottomSheet extends StatelessWidget {
  FolderSongsBottomSheet({
    Key? key,
  }) : super(key: key);
  var playerController = Get.find<PlayerController>();

  Future<void> playAudios(int position, String fv) async {
    await playerController.startPlaylist(
        position: position, playlist: 'foldersongs.$fv');
  }

  @override
  Widget build(BuildContext context) {
    Color bcolor = Get.isDarkMode ? Colors.black : Colors.white;
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GetX<PlayerController>(
              builder: (controller) {
                return ListTile(
                  leading: IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () {
                      Get.back();
                    },
                  ),
                  title: Text(
                    '${controller.noOfFolderSongs} - ${controller.getCurrentFolderText.value}',
                    style: xtitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  trailing: GetX<PlayerController>(builder: (controller) {
                    return DropdownButton(
                      underline: Container(),
                      items: controller.sortType
                          .map((item) => DropdownMenuItem(
                                value: item['value'] as String,
                                child: Text(item['label']),
                              ))
                          .toList(),
                      value: controller.sortValue.value,
                      onChanged: (String? value) {
                        controller.setSortOrder(value!);
                      },
                    );
                  }),
                );
              },
            ),
            Expanded(
              child: Container(
                color: bcolor,
                child: Scrollbar(
                  child: GetX<PlayerController>(
                    builder: (controller) {
                      return ListView.builder(
                          itemCount: controller.noOfFolderSongs.value,
                          itemBuilder: (BuildContext context, int index) {
                            MediaItem audio = controller.getFolderAudio(index);
                            return SongTile(
                              startPlaylist: (int pos) async {
                                await playAudios(pos,
                                    controller.getCurrentFolderValue.value);
                              },
                              audio: audio,
                              index: index,
                              isLast:
                                  index + 1 == controller.noOfFolderSongs.value,
                            );
                          });
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
