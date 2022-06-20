import 'package:aurasounds/controller/player_controller.dart';
import 'package:aurasounds/utils/constants.dart';
import 'package:aurasounds/utils/helpers.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:on_audio_query/on_audio_query.dart';

class SongTile extends StatelessWidget {
  const SongTile(
      {Key? key,
      required this.audio,
      required this.index,
      required this.startPlaylist,
      required this.isLast})
      : super(key: key);
  final SongModel audio;
  final int index;
  final bool isLast;
  final Function startPlaylist;

  @override
  Widget build(BuildContext context) {
    return GetX<PlayerController>(builder: (controller) {
      return Container(
        margin: EdgeInsets.only(bottom: isLast ? 160 : 0,left: 10,right: 10,top: 8),
        padding: const EdgeInsets.only(left: 10,right: 18),
        decoration: BoxDecoration(
          color: controller.getCurrentAudioId.value == audio.id
              ? Theme.of(context).primaryColor.withOpacity(.1)
              : Theme.of(context).scaffoldBackgroundColor,
          borderRadius: const BorderRadius.all(Radius.circular(14)),
          border: controller.getCurrentAudioId.value == audio.id
              ? Border.all(width: 2, color: Theme.of(context).primaryColor)
              : Border.all(width: 0,color: Theme.of(context).scaffoldBackgroundColor ),

        ),
        child: ListTile(
          onTap: () {
            startPlaylist(index);
          },
          contentPadding: EdgeInsets.zero,
          leading: ClipRRect(
            borderRadius: BorderRadius.circular(99),
            child: QueryArtworkWidget(
              id: audio.id,
              type: ArtworkType.AUDIO,
              artworkBorder: BorderRadius.zero,
              nullArtworkWidget: Image.asset(
                'lib/assets/art.png',
                fit: BoxFit.cover,
                height: 48,
              ),
            ),
          ),
          trailing: Text(formatDuration(Duration(milliseconds:audio.duration!)),style: xtitle.copyWith(fontSize: 14,color: Colors.grey)),
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
