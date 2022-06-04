import 'dart:ui';

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:aurasounds/controller/player_controller.dart';
import 'package:aurasounds/utils/constants.dart';
import 'package:aurasounds/utils/helpers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PlayingScreen extends StatelessWidget {
  PlayingScreen({Key? key}) : super(key: key);
  var playerController = Get.find<PlayerController>();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: ExactAssetImage('lib/assets/art.jpg'),
          fit: BoxFit.cover,
        ),
      ),
      child: ClipRRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
          child: Container(
            decoration:BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.white.withOpacity(.8),
                    Colors.white,
                  ],
                )
            ),
            child: SafeArea(
              child: GetX<PlayerController>(
                builder: (controller) {
                  return StreamBuilder<Playing?>(
                      stream: controller.player.value.current,
                      builder: (context, snapshot) {
                        bool hasCurrent = false;
                        if (snapshot.hasData) {
                          hasCurrent = true;
                        } else {
                          hasCurrent = false;
                        }
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 26),
                              child: Center(
                                child: Text(
                                  "Now Playing",
                                  style: xheading.copyWith(
                                      color: Colors.grey.shade600),
                                ),
                              ),
                            ),
                            Container(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image.asset(
                                  'lib/assets/art.jpg',
                                  fit: BoxFit.cover,
                                  height: 300,
                                ),
                              ),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 24, vertical: 40),
                            ),
                            Expanded(child: Container()),
                            Container(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              child: Center(
                                child: Text(
                                  controller.getMeta(
                                    hasCurrent
                                        ? controller
                                            .player.value.getCurrentAudioTitle
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
                                    hasCurrent
                                        ? controller
                                            .player.value.getCurrentAudioArtist
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
                                    hasCurrent
                                        ? controller
                                            .player.value.getCurrentAudioAlbum
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
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 22),
                                    child: StreamBuilder<Duration>(
                                        stream: hasCurrent
                                            ? controller
                                                .player.value.currentPosition
                                            : const Stream.empty(),
                                        builder: (context, snapshot) {
                                          int? duration = 0;
                                          if (hasCurrent) {
                                            duration = controller.player.value
                                                        .getCurrentAudioextra[
                                                    'duration'] ??
                                                1;
                                          }

                                          int? current = snapshot.hasData
                                              ? snapshot.data!.inMilliseconds
                                              : 0;
                                          return Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Text(formatDuration(Duration(
                                                  milliseconds: current))),
                                              Text(formatDuration(Duration(
                                                  milliseconds: duration!))),
                                            ],
                                          );
                                        }),
                                  ),
                                  StreamBuilder<Duration>(
                                      stream: hasCurrent
                                          ? controller
                                              .player.value.currentPosition
                                          : const Stream.empty(),
                                      builder: (context, snapshot) {
                                        int? duration = 0;
                                        if (hasCurrent) {
                                          duration = controller.player.value
                                                      .getCurrentAudioextra[
                                                  'duration'] ??
                                              1;
                                        }
                                        int? current = snapshot.hasData
                                            ? snapshot.data!.inMilliseconds
                                            : 0;
                                        double value = 0;
                                        if (hasCurrent) {
                                          value = current / duration!;
                                        }
                                        return Slider(
                                          onChanged: (double value) {
                                            if (hasCurrent) {
                                              controller.player.value.seek(
                                                  Duration(
                                                      milliseconds:
                                                          (duration! * value)
                                                              .toInt()));
                                            }
                                          },
                                          value: value,
                                          inactiveColor: Colors.grey.shade400,
                                        );
                                      }),
                                ],
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(vertical: 20),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  IconButton(
                                      iconSize: 40,
                                      onPressed: () {
                                        if (hasCurrent) {
                                          playerController.player.value
                                              .previous();
                                        }
                                      },
                                      icon: const Icon(
                                          Icons.skip_previous_rounded)),
                                  Container(
                                    decoration: BoxDecoration(
                                        color: Theme.of(context).primaryColor,
                                        borderRadius:
                                            BorderRadius.circular(99)),
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
                                              controller.player.value.isPlaying,
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
                                      if (hasCurrent) {
                                        playerController.player.value.next();
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  GetX<PlayerController>(builder: (controller) {
                                    return IconButton(
                                      iconSize: 30,
                                      onPressed: () {
                                        controller.toggleRepeatOne();
                                      },
                                      icon: Icon(
                                        Icons.repeat_one_outlined,
                                        color: controller.repeatOne.value
                                            ? Theme.of(context).primaryColor
                                            : Colors.black,
                                      ),
                                    );
                                  }),
                                  GetX<PlayerController>(builder: (controller) {
                                    return IconButton(
                                      iconSize: 30,
                                      onPressed: () {
                                        controller.toggleShuffle();
                                      },
                                      icon: Icon(Icons.shuffle_rounded,
                                          color: controller.shuffle.value
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
                                        const PlaylistQueue(),
                                      );
                                    },
                                    icon: const Icon(Icons.queue_music_rounded),
                                  ),
                                ],
                              ),
                            )
                          ],
                        );
                      });
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class PlaylistQueue extends StatelessWidget {
  const PlaylistQueue({
    Key? key,
  }) : super(key: key);

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
              'Current Playlist',
              style: xtitle,
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: 100,
              itemBuilder: (context, int index) {
                return ListTile(
                  title: Text('Item $index'),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
