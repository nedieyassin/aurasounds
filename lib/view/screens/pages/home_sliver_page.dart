import 'package:aurasounds/controller/player_controller.dart';
import 'package:aurasounds/utils/helpers.dart';
import 'package:aurasounds/view/components/silver_view.dart';
import 'package:aurasounds/view/components/tiles/song_tile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:line_icons/line_icons.dart';

class HomeSliverPage extends StatelessWidget {
  HomeSliverPage({
    Key? key,
    required this.title,
    required this.playlist,
    required this.music,
    this.showNumber = false,
    this.showPlayCount = false,
    this.isFav = false,
    this.placeholderImage,
    this.actions,
  }) : super(key: key);

  final playerController = Get.find<PlayerController>();
  final String title;
  final String playlist;
  final String? placeholderImage;
  final Future<List<MediaItem>> music;
  final bool showNumber;
  final bool showPlayCount;
  final bool isFav;
  final List<Widget>? actions;

  Future<void> playAudios(int position, List<MediaItem> music) async {
    await playerController.startPlaylist(
      position: position,
      playlist: playlist,
      music: music,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
          future: music,
          builder: (context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              List<MediaItem> music = snapshot.data;
              return BouncyImageSliverScrollView(
                title: title,
                actions: actions,
                placeholderImage: placeholderImage ?? 'lib/assets/${getThemedAsset('playlist.png')}',
                sliverList: SliverList(
                  delegate: music.isNotEmpty
                      ? SliverChildBuilderDelegate(
                          (context, int index) {
                            MediaItem audio = music[index];
                            return SongTile(
                              startPlaylist: (int pos) async {
                                await playAudios(pos, music);
                              },
                              audio: audio,
                              index: index,
                              showNumber: showNumber,
                              showPlayCount: showPlayCount,
                              isFav: isFav,
                              isLast: index + 1 == music.length,
                            );
                          },
                          childCount: music.length,
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
              );
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          }),
    );
  }
}
