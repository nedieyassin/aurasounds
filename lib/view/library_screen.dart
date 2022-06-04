import 'package:aurasounds/controller/player_controller.dart';
import 'package:aurasounds/controller/playlist_controller.dart';
import 'package:aurasounds/model/audio.dart';
import 'package:aurasounds/utils/constants.dart';
import 'package:aurasounds/view/song_tile.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LibraryScreen extends StatelessWidget {
  LibraryScreen({Key? key}) : super(key: key);
  var playlistController = Get.find<PlaylistController>();
  var playerController = Get.find<PlayerController>();

  void playAudios(List<XAudio> playlist, int position) {
    playerController.startPlaylist(playlist, position: position);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Scrollbar(
            child: GetX<PlaylistController>(
              builder: (controller) {
                return ListView.builder(
                    itemCount: controller.noOfSongs.value + 1,
                    itemBuilder: (BuildContext context, int index) {
                      if (index == 0) {
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 12,right: 12,top: 26,),
                              child: Text(
                                'Library',
                                style: xheading.copyWith(
                                    color: Colors.grey.shade600),
                              ),
                            ),
                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 16),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: const [
                                    TabCycle(
                                      color: Colors.blue,
                                      icon: EvaIcons.list,
                                      label: 'All songs',
                                    ),
                                    TabCycle(
                                      color: Colors.orange,
                                      icon: EvaIcons.shuffle,
                                      label: 'Shuffle',
                                    ),
                                    TabCycle(
                                      color: Colors.teal,
                                      icon: EvaIcons.search,
                                      label: 'Search',
                                    ),
                                    TabCycle(
                                      color: Colors.purple,
                                      icon: EvaIcons.folderOutline,
                                      label: 'Folders',
                                    ),
                                    TabCycle(
                                      color: Colors.pink,
                                      icon: EvaIcons.heart,
                                      label: 'Favourite',
                                    ),
                                    TabCycle(
                                      color: Colors.indigo,
                                      icon: EvaIcons.clockOutline,
                                      label: 'Recently Played',
                                    ),
                                    TabCycle(
                                      color: Colors.brown,
                                      icon: EvaIcons.headphones,
                                      label: 'Most Played',
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  top: 16, left: 12, bottom: 8),
                              child: Text(
                                'All Songs (${controller.noOfSongs})',
                                style: xtitle,
                              ),
                            )
                          ],
                        );
                      } else {
                        XAudio audio = controller.getAudio(index - 1);
                        return SongTile(
                          startPlaylist: (int pos) =>
                              playAudios(controller.getAudios(), pos),
                          audio: audio,
                          index: index - 1,
                        );
                      }
                    });
              },
            ),
          ),
        )
      ],
    );
  }
}

class TabCycle extends StatelessWidget {
  const TabCycle({
    Key? key,
    required this.color,
    required this.icon,
    required this.label,
  }) : super(key: key);
  final Color color;
  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          height: 60,
          width: 60,
          margin: const EdgeInsets.only(bottom: 10, left: 10, right: 10),
          decoration: BoxDecoration(
              color: color.withOpacity(.1),
              borderRadius: BorderRadius.circular(99)),
          child: Icon(
            icon,
            color: color,
          ),
        ),
        Text(label),
      ],
    );
  }
}
