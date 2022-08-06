import 'package:aurasounds/controller/library_controller.dart';
import 'package:aurasounds/controller/player_controller.dart';
import 'package:aurasounds/utils/constants.dart';
import 'package:aurasounds/view/components/tiles/song_tile.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:just_audio_background/just_audio_background.dart';

class SearchWidget extends StatelessWidget {
  SearchWidget({
    Key? key,
    required this.body,
  }) : super(key: key);

  final Widget body;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        body,
        SafeArea(
          child: Hero(
            tag: 'local_search',
            child: Card(
              margin: const EdgeInsets.fromLTRB(
                18.0,
                10.0,
                18.0,
                15.0,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(
                  10.0,
                ),
              ),
              elevation: 1.0,
              child: GestureDetector(
                onTap: () {
                  // showMaterialModalBottomSheet(
                  //   context: context,
                  //   builder: (context) => SearchResults(),
                  // );
                  Get.to(
                    () => SearchResults(),
                    transition: Transition.upToDown,
                  );
                },
                child: SizedBox(
                  height: 52.0,
                  child: Center(
                    child: TextField(
                        enabled: false,
                        textAlignVertical: TextAlignVertical.center,
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.only(left: 20),
                          focusedBorder: const UnderlineInputBorder(
                            borderSide: BorderSide(
                              width: 1.5,
                              color: Colors.transparent,
                            ),
                          ),
                          fillColor: Theme.of(context).colorScheme.secondary,
                          prefixIcon: const Icon(Icons.search_rounded),
                          border: InputBorder.none,
                          hintText: 'Search songs..',
                        )),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class SearchResults extends StatelessWidget {
  SearchResults({Key? key}) : super(key: key);
  final libraryController = Get.find<LibraryController>();
  final playerController = Get.find<PlayerController>();

  Future<void> playAudios(int position, {shuffle = false}) async {
    await playerController.startPlaylist(
        position: position,
        playlist: 'searchResults',
        music: libraryController.searchResults.value,
        falseOpen: libraryController.dirtyList.value['searchResults'],
        shuffle: shuffle);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          body: SafeArea(
            child: Scrollbar(
              child: GetX<LibraryController>(
                builder: (controller) {
                  return ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      itemCount: controller.searchResults.value.length,
                      itemBuilder: (BuildContext context, int index) {
                        MediaItem audio = controller.searchResults.value[index];
                        if (index == 0) {
                          return Column(
                            children: [
                              const SizedBox(
                                height: 80,
                              ),
                              SongTile(
                                startPlaylist: (int pos) async {
                                  await playAudios(pos);
                                },
                                audio: audio,
                                index: index,
                                isLast: index + 1 ==
                                    controller.searchResults.value.length,
                              ),
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
                                controller.searchResults.value.length,
                          );
                        }
                      });
                },
              ),
            ),
          ),
        ),
        SafeArea(
          child: Hero(
            tag: 'local_search',
            child: Card(
              margin: const EdgeInsets.fromLTRB(
                18.0,
                10.0,
                18.0,
                15.0,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(
                  10.0,
                ),
              ),
              elevation: 2.0,
              child: SizedBox(
                height: 52.0,
                child: Center(
                    child: TextField(
                  textAlignVertical: TextAlignVertical.center,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.only(left: 20),
                    focusedBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(
                        width: 1.5,
                        color: Colors.transparent,
                      ),
                    ),
                    fillColor: Theme.of(context).colorScheme.secondary,
                    prefixIcon: IconButton(
                      icon: const Icon(Icons.arrow_back),
                      onPressed: () {
                        libraryController.searchSongs('');
                        Get.back();
                      },
                    ),
                    border: InputBorder.none,
                    hintText: 'Search songs..',
                  ),
                  autofocus: true,
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.search,
                  onChanged: (val) {
                    libraryController.searchSongs(val);
                  },
                  onSubmitted: (_query) {
                    if (_query.trim() != '') {}
                  },
                )),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
