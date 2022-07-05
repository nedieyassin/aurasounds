import 'package:aurasounds/controller/player_controller.dart';
import 'package:aurasounds/utils/constants.dart';
import 'package:aurasounds/view/components/song_tile.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class SearchWidget extends StatelessWidget {
  const SearchWidget({
    Key? key,
  }) : super(key: key);

  void openSearchSongs(BuildContext context) {
    showMaterialModalBottomSheet(
      context: context,
      builder: (context) => SearchSongsBottomSheet(),
    );
    // Get.bottomSheet(FolderSongsBottomSheet(), isScrollControlled: true);
  }

  @override
  Widget build(BuildContext context) {
    Color fcolor = Get.isDarkMode ? Colors.white : Colors.black;
    return Container(
      margin: const EdgeInsets.only(right: 10),
      child: ElevatedButton(
        child: Row(
          children: const [
            Text(
              'Search',
            ),
            SizedBox(
              width: 10,
            ),
            Icon(EvaIcons.search),
          ],
        ),
        onPressed: () {
          openSearchSongs(context);
        },
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(fcolor.withOpacity(.1)),
          foregroundColor: MaterialStateProperty.all(fcolor.withOpacity(.7)),
          padding: MaterialStateProperty.all(
            const EdgeInsets.only(left: 20, bottom: 10, top: 10, right: 10),
          ),
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(99),
            ),
          ),
          elevation: MaterialStateProperty.all(0),
        ),
      ),
    );
  }
}

class SearchSongsBottomSheet extends StatelessWidget {
  SearchSongsBottomSheet({
    Key? key,
  }) : super(key: key);
  var playerController = Get.find<PlayerController>();

  Future<void> playAudios(int position) async {
    await playerController.startPlaylist(
        position: position, playlist: 'search');
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
            Container(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              child: TextField(
                autofocus: true,
                onChanged: (String? q) {
                  playerController.searchSongs(q ?? '');
                },
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                    hintText: 'Search songs',
                    hintStyle: TextStyle(color: Colors.grey.shade500)),
              ),
            ),
            GetX<PlayerController>(
              builder: (controller) {
                return Padding(
                  padding: const EdgeInsets.only(
                    top: 4,
                    left: 16,
                    bottom: 8,
                  ),
                  child: Text(
                    'Search results for: ${controller.getCurrentSearchTextValue.value}',
                    style: xtitle,
                  ),
                );
              },
            ),
            Expanded(
              child: Container(
                color: bcolor,
                child: Scrollbar(
                  child: GetX<PlayerController>(
                    builder: (controller) {
                      if (controller.noOfSearchSongs.value.isGreaterThan(0)) {
                        return ListView.builder(
                            itemCount: controller.noOfSearchSongs.value,
                            itemBuilder: (BuildContext context, int index) {
                              MediaItem audio =
                                  controller.getSearchAudio(index);
                              return SongTile(
                                startPlaylist: (int pos) async {
                                  await playAudios(pos);
                                },
                                audio: audio,
                                index: index,
                                isLast: index + 1 ==
                                    controller.noOfSearchSongs.value,
                              );
                            });
                      } else {
                        return Column(
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
                                  'No Search Results',
                                  style: xheading,
                                ),
                              ),
                            )
                          ],
                        );
                      }
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
