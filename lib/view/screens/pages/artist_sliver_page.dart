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
import 'package:on_audio_query/on_audio_query.dart';

class ArtistSliverPage extends StatelessWidget {
  ArtistSliverPage({
    Key? key,
    required this.artist,
  }) : super(key: key);

  final playerController = Get.find<PlayerController>();
  final libraryController = Get.find<LibraryController>();

  final XArtistModel artist;

  Future<void> playAudios(int position, {shuffle = false}) async {
    await playerController.startPlaylist(
        position: position,
        playlist: artist.artistName,
        music: libraryController.artistSongs.value,
        falseOpen: libraryController.dirtyList.value['artistSongs'],
        shuffle: shuffle);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GetX<LibraryController>(builder: (controller) {
        return Stack(
          children: [
            BouncyImageSliverScrollView(
              title: artist.artistName,
              isWidgetImage: true,
              imageWidget: QueryArtworkWidget(
                id: int.parse(artist.artistUri),
                type: ArtworkType.ARTIST,
                artworkQuality: FilterQuality.high,
                artworkBorder: BorderRadius.zero,
                nullArtworkWidget: Image.asset(
                  'lib/assets/${getThemedAsset('album.png')}',
                  fit: BoxFit.cover,
                  height: 48,
                ),
              ),
              actions: [
                SortingWidget(
                  onChange: () => controller.initGetAlbumSongs(artist.artistUri),
                )
              ],
              sliverList: SliverList(
                delegate: controller.artistSongs.value.isNotEmpty
                    ? SliverChildBuilderDelegate(
                        (context, int index) {
                          MediaItem audio = controller.artistSongs.value[index];
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
                                          controller.artistSongs.value.length),
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
                                      controller.artistSongs.value.length,
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
                                  controller.artistSongs.value.length,
                            );
                          }
                        },
                        childCount: controller.artistSongs.value.length,
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
