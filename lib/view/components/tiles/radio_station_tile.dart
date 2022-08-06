import 'package:aurasounds/controller/player_controller.dart';
import 'package:aurasounds/utils/constants.dart';
import 'package:aurasounds/utils/helpers.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:on_audio_query/on_audio_query.dart';

class RadioStationTile extends StatelessWidget {
  const RadioStationTile({
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

  @override
  Widget build(BuildContext context) {
    Color bcolor = Get.isDarkMode ? Colors.black : Colors.white;
    Color fcolor = Get.isDarkMode ? Colors.white : Colors.black;
    return GetX<PlayerController>(builder: (controller) {
      return Container(
        margin: EdgeInsets.only(bottom: isLast ? 160 : 0, left: 10, right: 10, top: 4),
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
            contentPadding: const EdgeInsets.only(left: 4),
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(99),
              child: Image.asset(
                'lib/assets/${getThemedAsset('radio.png')}',
                fit: BoxFit.cover,
                height: 48,
              ),
            ),
            title: Text(
              audio.title,
              maxLines: 1,
              style: xtitle.copyWith(fontSize: 14),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
      );
    });
  }
}
