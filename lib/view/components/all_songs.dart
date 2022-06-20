import 'package:aurasounds/controller/player_controller.dart';
import 'package:aurasounds/utils/constants.dart';
import 'package:aurasounds/view/components/song_tile.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:on_audio_query/on_audio_query.dart';

class AllSongsPage extends StatelessWidget {
  AllSongsPage({Key? key}) : super(key: key);

  var playerController = Get.find<PlayerController>();

  Future<void> playAudios(int position) async {
    await playerController.startPlaylist(
        position: position, playlist: 'allsongs');
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            GetX<PlayerController>(
              builder: (controller) {
                return Padding(
                  padding:
                      const EdgeInsets.only(top: 10, left: 16, bottom: 8,),
                  child: Text(
                    'All Songs (${controller.noOfAllSongs})',
                    style: xtitle,
                  ),
                );
              },
            ),
            GetX<PlayerController>(builder: (controller) {
              return DropdownButton(
                underline: Container(),
                items: controller.sortType
                    .map((item) => DropdownMenuItem(
                          value: item['value'] as String,
                          child: Text(item['label']),
                        ))
                    .toList(),
                value: controller.sortValue.value,
                onChanged: (String? value) {
                  controller.setSortOrder(value!);
                },
              );
            })
          ],
        ),
        Expanded(
          child: Container(
            color: Colors.white,
            child: Scrollbar(
              child: GetX<PlayerController>(
                builder: (controller) {
                  return ListView.builder(
                      itemCount: controller.noOfAllSongs.value,
                      itemBuilder: (BuildContext context, int index) {
                        SongModel audio = controller.getAudio(index);
                        return SongTile(
                          startPlaylist: (int pos) async {
                            await playAudios(pos);
                          },
                          audio: audio,
                          index: index, isLast: index+1 == controller.noOfAllSongs.value,
                        );
                      });
                },
              ),
            ),
          ),
        ),
      ],
    );
  }
}