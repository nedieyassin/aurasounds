import 'dart:ui';
import 'package:aurasounds/controller/player_controller.dart';
import 'package:aurasounds/utils/constants.dart';
import 'package:aurasounds/utils/helpers.dart';
import 'package:aurasounds/view/components/song_tile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:on_audio_query/on_audio_query.dart';

class PlayingScreen extends StatelessWidget {
  PlayingScreen({Key? key}) : super(key: key);
  var playerController = Get.find<PlayerController>();

  @override
  Widget build(BuildContext context) {
    return GetX<PlayerController>(builder: (controller) {
      return Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: (controller.hasArtByteArray.value
                ? MemoryImage(controller.artByteArray.value)
                : const AssetImage('lib/assets/art.png')) as ImageProvider,
            fit: BoxFit.cover,
          ),
        ),
        child: ClipRRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 100.0, sigmaY: 100.0),
            child: Container(
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.white.withOpacity(0.7),
                  Colors.white.withOpacity(0.7),
                ],
              )),
              child: SafeArea(
                child: GetX<PlayerController>(
                  builder: (controller) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 26, horizontal: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Now Playing",
                                style: xheading.copyWith(
                                    color: Colors.black, fontFamily: 'Cust'),
                              ),
                              ElevatedButton(
                                child: const Text(
                                  'Lyrics',
                                ),
                                onPressed: () {
                                  controller.toggleMiniLyrics();
                                },
                                style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all(
                                    Theme.of(context).scaffoldBackgroundColor,
                                  ),
                                  foregroundColor:
                                      MaterialStateProperty.all(Colors.black),
                                  padding: MaterialStateProperty.all(
                                    const EdgeInsets.symmetric(
                                        horizontal: 14, vertical: 2),
                                  ),
                                  shape: MaterialStateProperty.all(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(99),
                                    ),
                                  ),
                                  elevation: MaterialStateProperty.all(0),
                                ),
                              )
                            ],
                          ),
                        ),
                        !controller.openLyrics.value
                            ? const ArtWork()
                            : Expanded(
                                child: SingleChildScrollView(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 16, horizontal: 10),
                                    child: Text(
                                      controller.getLyricsValue.value,
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(fontSize: 18),
                                    ),
                                  ),
                                ),
                              ),
                        !controller.openLyrics.value
                            ? Expanded(child: Container())
                            : Container(),
                        Container(
                          padding: const EdgeInsets.only(
                              left: 20, right: 20, top: 10),
                          child: Center(
                            child: Text(
                              controller.getMeta(
                                controller.hasCurrent.value
                                    ? controller.title.value
                                    : '',
                              ),
                              style: xtitle,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 4),
                          child: Center(
                            child: Text(
                              controller.getMeta(
                                controller.hasCurrent.value
                                    ? controller.artist.value
                                    : '',
                              ),
                              style: xsubtitle.copyWith(
                                  color: Colors.grey.shade600),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 0),
                          child: Center(
                            child: Text(
                              controller.getMeta(
                                controller.hasCurrent.value
                                    ? controller.album.value
                                    : '',
                              ),
                              style: xsubtitle.copyWith(
                                  color: Colors.grey.shade600),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.only(
                              top: 20, left: 20, right: 20),
                          child: Column(
                            children: [
                              StreamBuilder<Duration>(
                                stream: controller.hasCurrent.value
                                    ? controller.player.value.positionStream
                                    : const Stream.empty(),
                                builder: (context, snapshot) {
                                  int? current = snapshot.hasData
                                      ? snapshot.data!.inMilliseconds
                                      : 0;
                                  double value = 0;
                                  if (controller.hasCurrent.value) {
                                    value = current /
                                        controller
                                            .duration.value.inMilliseconds;
                                  }
                                  return Slider(
                                    // activeColor: Colors.black,
                                    inactiveColor: Colors.grey.shade600,
                                    onChanged: (double value) {
                                      if (controller.hasCurrent.value) {
                                        controller.player.value.seek(Duration(
                                            milliseconds: (controller.duration
                                                        .value.inMilliseconds *
                                                    value)
                                                .toInt()));
                                      }
                                    },
                                    value: value,
                                  );
                                },
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 22),
                                child: StreamBuilder<Duration>(
                                    stream: controller.hasCurrent.value
                                        ? controller.player.value.positionStream
                                        : const Stream.empty(),
                                    builder: (context, snapshot) {
                                      int? current = snapshot.hasData
                                          ? snapshot.data!.inMilliseconds
                                          : 0;

                                      return Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Text(formatDuration(
                                              Duration(milliseconds: current))),
                                          Text(formatDuration(
                                              controller.duration.value)),
                                        ],
                                      );
                                    }),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(vertical: 20),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              IconButton(
                                  iconSize: 40,
                                  onPressed: () {
                                    if (controller.hasCurrent.value) {
                                      playerController.player.value
                                          .seekToPrevious();
                                    }
                                  },
                                  icon:
                                      const Icon(Icons.skip_previous_rounded)),
                              Container(
                                decoration: BoxDecoration(
                                    color: Theme.of(context).primaryColor,
                                    borderRadius: BorderRadius.circular(99)),
                                child: IconButton(
                                  iconSize: 50,
                                  onPressed: () {
                                    controller.play();
                                  },
                                  color: Colors.white,
                                  splashColor: Theme.of(context)
                                      .primaryColor
                                      .withOpacity(.5),
                                  icon: StreamBuilder<bool>(
                                      stream:
                                          controller.player.value.playingStream,
                                      builder: (context, asyncSnapshot) {
                                        if (asyncSnapshot.hasData) {
                                          bool playing =
                                              asyncSnapshot.data as bool;
                                          return Icon(playing
                                              ? Icons.pause_rounded
                                              : Icons.play_arrow_rounded);
                                        } else {
                                          return const Icon(
                                              Icons.play_arrow_outlined);
                                        }
                                      }),
                                ),
                              ),
                              IconButton(
                                iconSize: 40,
                                onPressed: () {
                                  if (controller.hasCurrent.value) {
                                    playerController.player.value.seekToNext();
                                  }
                                },
                                icon: const Icon(Icons.skip_next_rounded),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.only(
                              left: 20, right: 20, bottom: 30),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              StreamBuilder<LoopMode>(
                                stream: controller.player.value.loopModeStream,
                                builder: (context, snapshot) {
                                  LoopMode mode = LoopMode.off;
                                  if (snapshot.hasData) {
                                    mode = snapshot.data ?? LoopMode.off;
                                  }
                                  return IconButton(
                                    iconSize: 30,
                                    onPressed: () {
                                      controller.toggleRepeatOne();
                                    },
                                    icon: Icon(
                                      mode == LoopMode.one
                                          ? Icons.repeat_one_outlined
                                          : Icons.repeat_outlined,
                                      color: mode != LoopMode.off
                                          ? Theme.of(context).primaryColor
                                          : Colors.black,
                                    ),
                                  );
                                },
                              ),
                              StreamBuilder<bool>(
                                  stream: controller
                                      .player.value.shuffleModeEnabledStream,
                                  builder: (context, snapshot) {
                                    bool shuffle = false;
                                    if (snapshot.hasData) {
                                      shuffle = snapshot.data ?? false;
                                    }
                                    return IconButton(
                                      iconSize: 30,
                                      onPressed: () {
                                        controller.toggleShuffle();
                                      },
                                      icon: Icon(Icons.shuffle_rounded,
                                          color: shuffle
                                              ? Theme.of(context).primaryColor
                                              : Colors.black),
                                    );
                                  }),
                              IconButton(
                                iconSize: 30,
                                onPressed: () {},
                                icon: const Icon(Icons.favorite_outline),
                              ),
                              IconButton(
                                iconSize: 30,
                                onPressed: () {
                                  Get.bottomSheet(
                                    PlaylistQueue(),
                                  );
                                },
                                icon: const Icon(Icons.queue_music_rounded),
                              ),
                            ],
                          ),
                        )
                      ],
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      );
    });
  }
}

class ArtWork extends StatelessWidget {
  const ArtWork({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: GetX<PlayerController>(
        builder: (controller) {
          return QueryArtworkWidget(
            id: int.parse(controller.id.value),
            quality: 100,
            type: ArtworkType.AUDIO,
            artworkHeight: 260,
            artworkBorder: BorderRadius.zero,
            artworkFit: BoxFit.contain,
            nullArtworkWidget: Image.asset(
              'lib/assets/art.png',
              fit: BoxFit.contain,
              height: 260,
            ),
          );
        },
      ),
      padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 40),
    );
  }
}

class PlaylistQueue extends StatelessWidget {
  PlaylistQueue({
    Key? key,
  }) : super(key: key);

  var playerController = Get.find<PlayerController>();

  Future<void> playAudios(int position) async {
    await playerController.playQueueAt(position: position);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(22))),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Text(
              'Current Queue',
              style: xtitle,
            ),
          ),
          Expanded(
            child: Scrollbar(
              child: ListView.builder(
                itemCount: (playerController.player.value.sequence ?? []).length,
                itemBuilder: (context, int index) {
                  MediaItem audio = playerController.getQueueAudio(playerController.currentQueueList[index]);
                  return SongTile(
                    startPlaylist: (int pos) async {
                      await playAudios(pos);
                    },
                    audio: audio,
                    index: playerController.currentQueueList[index],
                    isLast: index + 1 ==
                        (playerController.player.value.sequence ?? []).length,
                  );
                },
              ),
            ),
          )
        ],
      ),
    );
  }
}
