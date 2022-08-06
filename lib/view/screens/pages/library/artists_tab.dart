import 'package:aurasounds/controller/library_controller.dart';
import 'package:aurasounds/model/type.dart';
import 'package:aurasounds/utils/constants.dart';
import 'package:aurasounds/view/components/tiles/album_tile.dart';
import 'package:aurasounds/view/components/tiles/artist_tile.dart';
import 'package:aurasounds/view/components/tiles/folder_tile.dart';
import 'package:aurasounds/view/screens/pages/album_sliver_page.dart';
import 'package:aurasounds/view/screens/pages/artist_sliver_page.dart';
import 'package:aurasounds/view/screens/pages/folder_sliver_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ArtistTab extends StatelessWidget {
  ArtistTab({Key? key}) : super(key: key);

  final libraryController = Get.find<LibraryController>();

  void openArtistSongs(XArtistModel artist) {
    libraryController.initGetArtistSongs(artist.artistUri);
    Get.to(() => ArtistSliverPage(
          artist: artist,
        ));
  }

  @override
  Widget build(BuildContext context) {
    Color bcolor = Get.isDarkMode ? Colors.black : Colors.white;
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            GetX<LibraryController>(
              builder: (controller) {
                return Padding(
                  padding: const EdgeInsets.only(
                    top: 10,
                    left: 16,
                    bottom: 8,
                  ),
                  child: Text(
                    '${controller.artistList.value.length} Artists',
                  ),
                );
              },
            ),
            const Spacer(),
            Opacity(
              opacity: 0,
              child: IconButton(
                onPressed: () async {
                },
                icon: const Icon(Icons.play_arrow_rounded),
              ),
            ),

          ],
        ),
        Expanded(
          child: Scrollbar(
            child: GetX<LibraryController>(
              builder: (controller) {
                return controller.artistList.value.isNotEmpty
                    ? ListView.builder(
                        itemCount: controller.artistList.value.length,
                        physics: const BouncingScrollPhysics(),
                        itemBuilder: (BuildContext context, int index) {
                          XArtistModel artist = controller.artistList.value[index];
                          return ArtistTile(
                            isLast: index + 1 == controller.artistList.value.length,
                            artist: artist,
                            artistSongs: () {
                              openArtistSongs(artist);
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
                                'No Artists',
                                style: xheading,
                              ),
                            ),
                          )
                        ],
                      );
              },
            ),
          ),
        ),
      ],
    );
  }
}
