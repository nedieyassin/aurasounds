import 'package:aurasounds/controller/library_controller.dart';
import 'package:aurasounds/controller/player_controller.dart';
import 'package:aurasounds/view/components/sections/home_section_heads.dart';
import 'package:aurasounds/view/components/tiles/large_song_tile.dart';
import 'package:aurasounds/view/screens/pages/home_sliver_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:just_audio_background/just_audio_background.dart';

class RecentlyPlayedSection extends StatelessWidget {
  RecentlyPlayedSection({
    Key? key,
    required this.title,
  }) : super(key: key);
  final String title;

  final playerController = Get.find<PlayerController>();
  final libraryController = Get.find<LibraryController>();

  Future<void> playAudios(int position) async {
    await playerController.startPlaylist(
      position: position,
      playlist: 'recentplayed',
      music: libraryController.recentlyPlayedSongs.value,
      falseOpen: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        HomeSectionHead(
          title: title,
          onMore: () async {
            Get.to(
              () => HomeSliverPage(
                title: title,
                showNumber: true,
                music: libraryController.initGetRecentlyPlayedSongs(),
                playlist: 'recentplayed',
              ),
            );
          },
        ),
        GetX<LibraryController>(
          builder: (controller) {
            List<MediaItem> _list = [];
            for (var item in controller.recentlyPlayedSongs.value) {
              if (_list.length < 20) {
                _list.add(item);
              }
            }
            return SizedBox(
              height: 200,
              child: ListView(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                children: [
                  const SizedBox(
                    width: 16,
                  ),
                  ..._list.asMap().entries.map((entry) {
                    int index = entry.key;
                    MediaItem audio = entry.value;
                    return LargeSongTile(
                      audio: audio,
                      onPlay: () {
                        playAudios(index);
                      },
                    );
                  }).toList(),
                  const SizedBox(
                    width: 16,
                  ),
                ],
              ),
            );
          },
        )
      ],
    );
  }
}
