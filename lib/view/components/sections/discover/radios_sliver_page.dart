import 'package:aurasounds/controller/library_controller.dart';
import 'package:aurasounds/controller/player_controller.dart';
import 'package:aurasounds/utils/helpers.dart';
import 'package:aurasounds/view/components/silver_view.dart';
import 'package:aurasounds/view/components/tiles/radio_station_tile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:line_icons/line_icons.dart';

class RadiosSliverPage extends StatelessWidget {
  RadiosSliverPage({
    Key? key,
  }) : super(key: key);

  final playerController = Get.find<PlayerController>();
  final libraryController = Get.find<LibraryController>();

  Future<void> playAudios(int position, List<MediaItem> music) async {
    await playerController.startPlaylist(
      position: position,
      playlist: 'radio',
      music: music,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GetX<LibraryController>(builder: (controller) {
        return BouncyImageSliverScrollView(
          title: 'Online Radio Stations',
          placeholderImage: 'lib/assets/${getThemedAsset('radio.png')}',
          sliverList: SliverList(
            delegate: controller.radioStations.value.isNotEmpty
                ? SliverChildBuilderDelegate(
                    (context, int index) {
                      MediaItem audio = controller.radioStations.value[index];
                      return RadioStationTile(
                        startPlaylist: (int pos) async {
                          await playAudios(pos, controller.radioStations.value);
                        },
                        audio: audio,
                        index: index,
                        isLast:
                            index + 1 == controller.radioStations.value.length,
                      );
                    },
                    childCount: controller.radioStations.value.length,
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
                            Text('No stations found')
                          ],
                        ),
                      ),
                    )
                  ]),
          ),
        );
      }),
    );
  }
}
