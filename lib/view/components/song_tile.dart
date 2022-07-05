import 'package:aurasounds/controller/player_controller.dart';
import 'package:aurasounds/utils/constants.dart';
import 'package:aurasounds/utils/helpers.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:on_audio_query/on_audio_query.dart';

class SongTile extends StatelessWidget {
  const SongTile({
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
        margin: EdgeInsets.only(
            bottom: isLast ? 160 : 0, left: 10, right: 10, top: 8),
        padding: const EdgeInsets.only(left: 10, right: 18),
        decoration: BoxDecoration(
          color: controller.getCurrentAudioId.value == int.parse(audio.id)
              ? Theme.of(context).primaryColor.withOpacity(.1)
              : Theme.of(context).scaffoldBackgroundColor,
          borderRadius: const BorderRadius.all(Radius.circular(14)),
          border: controller.getCurrentAudioId.value == int.parse(audio.id)
              ? Border.all(width: 2, color: Theme.of(context).primaryColor)
              : Border.all(
                  width: 0, color: Theme.of(context).scaffoldBackgroundColor),
        ),
        child: ListTile(
          onTap: () {
            startPlaylist(index);
          },
          contentPadding: EdgeInsets.zero,
          leading: Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(99),
                child: QueryArtworkWidget(
                  id: int.parse(audio.id),
                  type: ArtworkType.AUDIO,
                  artworkBorder: BorderRadius.zero,
                  nullArtworkWidget: Image.asset(
                    'lib/assets/art.png',
                    fit: BoxFit.cover,
                    height: 48,
                  ),
                ),
              ),
              showNumber
                  ? Container(
                      height: 20,
                      width: 40,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(99),
                        color: fcolor.withOpacity(.8),
                      ),
                      child: Center(
                          child: Text(
                        '${index + 1}',
                        style: TextStyle(color: bcolor),
                      )),
                    )
                  : const SizedBox(
                      width: 0,
                      height: 0,
                    ),
              showPlayCount
                  ? Container(
                      height: 20,
                      width: 40,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(99),
                        color: fcolor.withOpacity(.8),
                      ),
                      child: Center(
                          child: Text(
                        '${audio.extras!['play_count']}',
                        style: TextStyle(color: bcolor),
                      )),
                    )
                  : const SizedBox(
                      width: 0,
                      height: 0,
                    ),
              isFav
                  ? const Icon(
                      Icons.favorite,
                      color: Colors.red,
                    )
                  : const SizedBox(
                      width: 0,
                      height: 0,
                    ),
            ],
          ),
          trailing: Text(formatDuration(audio.duration!),
              style: xtitle.copyWith(fontSize: 14, color: Colors.grey)),
          title: Text(
            audio.title,
            maxLines: 1,
            style: xtitle.copyWith(fontSize: 14),
            overflow: TextOverflow.ellipsis,
          ),
          subtitle: Text(
            '${audio.artist}',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      );
    });
  }
}
