import 'package:aurasounds/controller/library_controller.dart';
import 'package:aurasounds/controller/player_controller.dart';
import 'package:aurasounds/view/components/sections/home_section_heads.dart';
import 'package:aurasounds/view/components/tiles/large_song_tile.dart';
import 'package:aurasounds/view/components/tiles/most_played_tile.dart';
import 'package:aurasounds/view/components/tiles/radio_playlist_tile.dart';
import 'package:aurasounds/view/screens/pages/home_sliver_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:just_audio_background/just_audio_background.dart';

class DiscoverSection extends StatelessWidget {
  DiscoverSection({
    Key? key,
    required this.title,
  }) : super(key: key);
  final String title;

  final playerController = Get.find<PlayerController>();
  final libraryController = Get.find<LibraryController>();

  Future<void> playAudios(int position) async {
    await playerController.startPlaylist(
      position: position,
      playlist: 'mostplayed',
      music: libraryController.mostlyPlayedSongs.value,
      falseOpen: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        HomeSectionHead(
          title: title,
        ),
        SizedBox(
          height: 140,
          child: ListView(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            children:  [
              const SizedBox(
                width: 16,
              ),
              const RadioPlaylistTile(),
              MostPlayedTile(),
              const SizedBox(
                width: 16,
              ),
            ],
          ),
        )
      ],
    );
  }
}
