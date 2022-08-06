import 'package:aurasounds/controller/library_controller.dart';
import 'package:aurasounds/controller/player_controller.dart';
import 'package:aurasounds/model/type.dart';
import 'package:aurasounds/utils/constants.dart';
import 'package:aurasounds/utils/helpers.dart';
import 'package:aurasounds/view/screens/pages/album_sliver_page.dart';
import 'package:aurasounds/view/screens/pages/artist_sliver_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:on_audio_query/on_audio_query.dart';

class SongTile extends StatelessWidget {
  SongTile({
    Key? key,
    required this.audio,
    required this.index,
    required this.startPlaylist,
    required this.isLast,
    this.showNumber = false,
    this.showPlayCount = false,
    this.isFav = false,
  }) : super(key: key);
  final MediaItem audio;
  final int index;
  final bool isLast;
  final bool showNumber;
  final bool showPlayCount;
  final bool isFav;
  final Function startPlaylist;

  final libraryController = Get.find<LibraryController>();

  @override
  Widget build(BuildContext context) {
    Color bcolor = Get.isDarkMode ? Colors.black : Colors.white;
    Color fcolor = Get.isDarkMode ? Colors.white : Colors.black;
    return GetX<PlayerController>(builder: (controller) {
      return Container(
        margin: EdgeInsets.only(
            bottom: isLast ? 160 : 0, left: 10, right: 10, top: 4),
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(16)),
          border: controller.getCurrentAudioId.value == int.parse(audio.id)
              ? Border.all(width: 2, color: Theme.of(context).primaryColor)
              : Border.all(
                  width: 0, color: Theme.of(context).scaffoldBackgroundColor),
        ),
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14.0),
          ),
          elevation: 0.6,
          margin: const EdgeInsets.all(0),
          child: ListTile(
            onTap: () {
              startPlaylist(index);
            },
            contentPadding: const EdgeInsets.only(left: 10),
            leading: Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(9),
                  child: QueryArtworkWidget(
                    id: int.parse(audio.id),
                    type: ArtworkType.AUDIO,
                    artworkBorder: BorderRadius.zero,
                    nullArtworkWidget: Image.asset(
                      'lib/assets/${getThemedAsset('art.png')}',
                      fit: BoxFit.cover,
                      height: 48,
                    ),
                  ),
                ),
                showNumber
                    ? Positioned.fill(
                        child: Container(
                          height: 20,
                          width: 40,
                          margin: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(99),
                            color: bcolor,
                          ),
                          child: Center(
                              child: Text(
                            '${index + 1}',
                            style: TextStyle(color: fcolor),
                          )),
                        ),
                      )
                    : showPlayCount
                        ? Positioned.fill(
                            child: Container(
                              height: 20,
                              width: 40,
                              margin: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(99),
                                color: bcolor,
                              ),
                              child: Center(
                                  child: Text(
                                '${audio.extras!['play_count']}',
                                style: TextStyle(color: fcolor),
                              )),
                            ),
                          )
                        : isFav
                            ? const Positioned.fill(
                                child: Icon(
                                  Icons.favorite,
                                  color: Colors.red,
                                ),
                              )
                            : const SizedBox(
                                width: 0,
                                height: 0,
                              ),
              ],
            ),
            title: Text(
              audio.title,
              maxLines: 1,
              style: xtitle.copyWith(fontSize: 14),
              overflow: TextOverflow.ellipsis,
            ),
            subtitle: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    '${audio.artist}',
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Text(
                  formatDuration(audio.duration!),
                  style: xtitle.copyWith(fontSize: 14, color: Colors.grey),
                )
              ],
            ),
            trailing: audio.extras!['is_radio'] ?? false
                ? const SizedBox()
                : PopupMenuButton<int>(
                    icon: const Icon(Icons.more_vert_rounded),
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(15.0),
                      ),
                    ),
                    onSelected: (int? value) async {
                      if (value == 1) {
                        libraryController.toggleFavourite(int.parse(audio.id));
                      }
                      if (value == 2) {
                        libraryController.initGetArtistSongs(
                            audio.extras!['artist_id'].toString());
                        Get.to(() => ArtistSliverPage(
                              artist: XArtistModel(
                                  artistName: audio.artist!,
                                  numberOfSongs: 0,
                                  artistUri:
                                      audio.extras!['artist_id'].toString()),
                            ));
                      }
                      if (value == 3) {
                        final libraryController = Get.find<LibraryController>();
                        libraryController.initGetAlbumSongs(
                            audio.extras!['album_id'].toString());
                        Get.to(
                          () => AlbumSliverPage(
                            album: XAlbumModel(
                              albumName: audio.album!,
                              albumUri: audio.extras!['album_id'].toString(),
                              numberOfSongs: 0,
                            ),
                          ),
                        );
                      }
                    },
                    itemBuilder: (context) => [
                      // PopupMenuItem<int>(
                      //   value: 0,
                      //   child: Row(
                      //     children: const [
                      //       Icon(Icons.playlist_add),
                      //       SizedBox(width: 10.0),
                      //       Text('Add to Playlist'),
                      //     ],
                      //   ),
                      // ),
                      PopupMenuItem<int>(
                        value: 1,
                        child: Row(
                          children: [
                            const Icon(Icons.favorite),
                            const SizedBox(width: 10.0),
                            audio.extras!['favourite'] == 1
                                ? const Text('Remove Favourite')
                                : const Text('Add Favourite'),
                          ],
                        ),
                      ),
                      const PopupMenuDivider(),
                      PopupMenuItem<int>(
                        value: 2,
                        child: Row(
                          children: const [
                            Icon(Icons.person),
                            SizedBox(width: 10.0),
                            Text('Go to Artist'),
                          ],
                        ),
                      ),
                      PopupMenuItem<int>(
                        value: 3,
                        child: Row(
                          children: const [
                            Icon(Icons.album),
                            SizedBox(width: 10.0),
                            Text('Go to Album'),
                          ],
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      );
    });
  }
}
