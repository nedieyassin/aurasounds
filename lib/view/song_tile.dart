import 'package:aurasounds/controller/player_controller.dart';
import 'package:aurasounds/model/audio.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SongTile extends StatelessWidget {
  const SongTile(
      {Key? key,
      required this.audio,
      required this.index,
      required this.startPlaylist})
      : super(key: key);
  final XAudio audio;
  final int index;
  final Function startPlaylist;

  @override
  Widget build(BuildContext context) {
    var playerController = Get.find<PlayerController>();
    return GetX<PlayerController>(builder: (controller) {
      return ListTile(
        onTap: () {
          // playerController.startPlay(audio, index: index);
          startPlaylist(index);
        },
        tileColor: controller.getCurrentAudioId.value == audio.id
            ? Theme.of(context).primaryColor.withOpacity(.1)
            : Colors.transparent,
        contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.asset(
            'lib/assets/art.jpg',
            fit: BoxFit.cover,
            height: 48,
          ),
        ),
        trailing: controller.getCurrentAudioId.value == audio.id
            ? Icon(EvaIcons.barChart, color: Theme.of(context).primaryColor)
            : SizedBox(
                width: 0,
                height: 0,
                child: Container(),
              ),
        title: Text(
          '${audio.title}',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Text(
          '${audio.artist} ${audio.durationText()}',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      );
    });
  }
}
