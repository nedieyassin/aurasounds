import 'package:aurasounds/controller/player_controller.dart';
import 'package:aurasounds/utils/helpers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:on_audio_query/on_audio_query.dart';

class LargeSongTile extends StatelessWidget {
  const LargeSongTile({
    Key? key,
    required this.audio,
    required this.onPlay,
    this.mini = false,
  }) : super(key: key);

  final MediaItem audio;
  final bool mini;
  final Function onPlay;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: mini ? 120 : 250,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: GetX<PlayerController>(builder: (controller) {
              return Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: QueryArtworkWidget(
                        id: int.parse(audio.id),
                        type: ArtworkType.AUDIO,
                        artworkBorder: BorderRadius.zero,
                        artworkWidth: 500,
                        nullArtworkWidget: Image.asset(
                          mini ? 'lib/assets/${getThemedAsset('art.png')}' : 'lib/assets/${getThemedAsset('cover.png')}',
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Center(
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(99),
                          color: Theme.of(context).primaryColor,
                        ),
                        child: IconButton(
                          onPressed: () {
                            onPlay();
                          },
                          icon: controller.getCurrentAudioId.value ==
                                  int.parse(audio.id)
                              ? const Icon(
                                  Icons.bar_chart_rounded,
                                  color: Colors.white,
                                )
                              : const Icon(
                                  Icons.play_arrow,
                                  color: Colors.white,
                                ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 10.0,
            ),
            child: Column(
              children: [
                Text(
                  audio.title,
                  textAlign: TextAlign.center,
                  softWrap: false,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  audio.artist!,
                  textAlign: TextAlign.center,
                  softWrap: false,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 11,
                    color: Theme.of(context).textTheme.caption!.color,
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
