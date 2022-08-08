import 'dart:ui';
import 'package:aurasounds/controller/player_controller.dart';
import 'package:aurasounds/utils/constants.dart';
import 'package:aurasounds/utils/helpers.dart';
import 'package:aurasounds/view/components/tiles/song_tile.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:on_audio_query/on_audio_query.dart';

class PlayingScreen extends StatelessWidget {
  PlayingScreen({Key? key}) : super(key: key);
  var playerController = Get.find<PlayerController>();

  @override
  Widget build(BuildContext context) {
    Color bcolor = Get.isDarkMode ? Colors.black : Colors.white;
    Color fcolor = Get.isDarkMode ? Colors.white : Colors.black;
    return GetX<PlayerController>(builder: (controller) {
      return Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: MemoryImage(controller.artByteArray.value),
            fit: BoxFit.cover,
          ),
        ),
        child: ClipRRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 100.0, sigmaY: 100.0),
            child: Container(
              decoration: BoxDecoration(color: bcolor.withOpacity(.7)),
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
                                controller.openLyrics.value
                                    ? "Lyrics"
                                    : "Now Playing",
                                style: xheading.copyWith(
                                    color: fcolor, fontFamily: 'Cust'),
                              ),
                              controller.isRadio.value
                                  ? Opacity(
                                      opacity:
                                          controller.radioAlias.value.isEmpty
                                              ? .3
                                              : 1,
                                      child: ElevatedButton(
                                        child: controller.programmeLoading.value
                                            ? const SizedBox(
                                                width: 10,
                                                height: 10,
                                                child:
                                                    CircularProgressIndicator(
                                                  strokeWidth: 1,
                                                ))
                                            : const Text('Whats on Air'),
                                        onPressed: controller
                                                .radioAlias.value.isEmpty
                                            ? null
                                            : () {
                                                controller.getRadioProgramme();
                                              },
                                        style: ButtonStyle(
                                          backgroundColor:
                                              MaterialStateProperty.all(
                                            Theme.of(context)
                                                .scaffoldBackgroundColor,
                                          ),
                                          foregroundColor:
                                              MaterialStateProperty.all(fcolor),
                                          padding: MaterialStateProperty.all(
                                            const EdgeInsets.symmetric(
                                                horizontal: 14, vertical: 2),
                                          ),
                                          shape: MaterialStateProperty.all(
                                            RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(99),
                                            ),
                                          ),
                                          elevation:
                                              MaterialStateProperty.all(0),
                                        ),
                                      ),
                                    )
                                  : controller.isYoutube.value
                                      ? const SizedBox()
                                      : ElevatedButton(
                                          child: Text(
                                            !controller.openLyrics.value
                                                ? "Lyrics"
                                                : "Close",
                                          ),
                                          onPressed: () {
                                            controller.toggleMiniLyrics();
                                          },
                                          style: ButtonStyle(
                                            backgroundColor:
                                                MaterialStateProperty.all(
                                              Theme.of(context)
                                                  .scaffoldBackgroundColor,
                                            ),
                                            foregroundColor:
                                                MaterialStateProperty.all(
                                                    fcolor),
                                            padding: MaterialStateProperty.all(
                                              const EdgeInsets.symmetric(
                                                  horizontal: 14, vertical: 2),
                                            ),
                                            shape: MaterialStateProperty.all(
                                              RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(99),
                                              ),
                                            ),
                                            elevation:
                                                MaterialStateProperty.all(0),
                                          ),
                                        )
                            ],
                          ),
                        ),
                        if (!controller.openLyrics.value)
                          const ArtWork()
                        else
                          const Lyrics(),
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
                        if (!controller.openLyrics.value)
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 4,
                            ),
                            child: Column(
                              children: [
                                Center(
                                  child: Text(
                                    controller.getMeta(
                                      controller.hasCurrent.value
                                          ? controller.artist.value
                                          : '',
                                    ),
                                    style: xsubtitle.copyWith(
                                        color: fcolor.withOpacity(.7)),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                Center(
                                  child: Text(
                                    controller.getMeta(
                                      controller.hasCurrent.value
                                          ? controller.album.value
                                          : '',
                                    ),
                                    style: xsubtitle.copyWith(
                                        color: fcolor.withOpacity(.7)),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ],
                            ),
                          )
                        else
                          Container(),
                        controller.isRadio.value
                            ? const SizedBox()
                            : Container(
                                padding: const EdgeInsets.only(
                                    top: 20, left: 20, right: 20),
                                child: Column(
                                  children: [
                                    StreamBuilder<Duration>(
                                      stream: controller.hasCurrent.value
                                          ? controller
                                              .player.value.positionStream
                                          : const Stream.empty(),
                                      builder: (context, snapshot) {
                                        int? current = snapshot.hasData
                                            ? snapshot.data!.inMilliseconds
                                            : 0;
                                        double value = 0;
                                        if (controller.hasCurrent.value) {
                                          value = current /
                                              controller.duration.value
                                                  .inMilliseconds;
                                        }
                                        return Slider(
                                          // activeColor: Colors.black,
                                          inactiveColor: Colors.grey.shade600,
                                          onChanged: (double value) {
                                            if (controller.hasCurrent.value) {
                                              controller.player.value.seek(
                                                  Duration(
                                                      milliseconds: (controller
                                                                  .duration
                                                                  .value
                                                                  .inMilliseconds *
                                                              value)
                                                          .toInt()));
                                            }
                                          },
                                          value: value,
                                        );
                                      },
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 22),
                                      child: StreamBuilder<Duration>(
                                          stream: controller.hasCurrent.value
                                              ? controller
                                                  .player.value.positionStream
                                              : const Stream.empty(),
                                          builder: (context, snapshot) {
                                            int? current = snapshot.hasData
                                                ? snapshot.data!.inMilliseconds
                                                : 0;

                                            return Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Text(formatDuration(Duration(
                                                    milliseconds: current))),
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
                                  onPressed: controller.player.value.hasPrevious
                                      ? () {
                                          if (controller.hasCurrent.value) {
                                            playerController.player.value
                                                .seekToPrevious();
                                          }
                                        }
                                      : null,
                                  icon:
                                      const Icon(Icons.skip_previous_rounded)),
                              StreamBuilder<ProcessingState>(
                                stream: controller
                                    .player.value.processingStateStream,
                                builder: (context, snap) {
                                  if (snap.hasData && !snap.hasError) {
                                    if (snap.data !=
                                            ProcessingState.buffering &&
                                        snap.data != ProcessingState.loading) {
                                      return StreamBuilder<bool>(
                                          stream: controller
                                              .player.value.playingStream,
                                          builder: (context, asyncSnapshot) {
                                            if (asyncSnapshot.hasData) {
                                              bool playing =
                                                  asyncSnapshot.data as bool;
                                              return Container(
                                                decoration: BoxDecoration(
                                                  color: Theme.of(context)
                                                      .primaryColor,
                                                  borderRadius:
                                                      BorderRadius.circular(99),
                                                ),
                                                child: IconButton(
                                                  iconSize: 50,
                                                  onPressed: () {
                                                    controller.play();
                                                  },
                                                  color: Colors.white,
                                                  splashColor: Theme.of(context)
                                                      .primaryColor
                                                      .withOpacity(.5),
                                                  icon: Icon(playing
                                                      ? Icons.pause_rounded
                                                      : Icons
                                                          .play_arrow_rounded),
                                                ),
                                              );
                                            } else {
                                              return Container(
                                                decoration: BoxDecoration(
                                                  color: Theme.of(context)
                                                      .primaryColor,
                                                  borderRadius:
                                                      BorderRadius.circular(99),
                                                ),
                                                child: IconButton(
                                                  iconSize: 50,
                                                  onPressed: () {
                                                    controller.play();
                                                  },
                                                  color: Colors.white,
                                                  splashColor: Theme.of(context)
                                                      .primaryColor
                                                      .withOpacity(.5),
                                                  icon: const Icon(
                                                      Icons.play_arrow_rounded),
                                                ),
                                              );
                                            }
                                          });
                                    } else {
                                      return IconButton(
                                        icon: const CircularProgressIndicator(),
                                        iconSize: 50,
                                        onPressed: () {},
                                      );
                                    }
                                  } else {
                                    return const Icon(
                                        Icons.error_outline_outlined);
                                  }
                                },
                              ),
                              IconButton(
                                iconSize: 40,
                                onPressed: controller.player.value.hasNext
                                    ? () {
                                        if (controller.hasCurrent.value) {
                                          playerController.player.value
                                              .seekToNext();
                                        }
                                      }
                                    : null,
                                icon: const Icon(Icons.skip_next_rounded),
                              ),
                            ],
                          ),
                        ),
                        if (!controller.openLyrics.value)
                          const Actions()
                        else
                          Container()
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

class Actions extends StatelessWidget {
  const Actions({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color bcolor = Get.isDarkMode ? Colors.black : Colors.white;
    Color fcolor = Get.isDarkMode ? Colors.white : Colors.black;
    return GetX<PlayerController>(
      builder: (controller) {
        return Padding(
          padding: const EdgeInsets.only(left: 20, right: 20, bottom: 30),
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
                    onPressed: controller.isRadio.value
                        ? null
                        : () {
                            controller.toggleRepeatOne();
                          },
                    icon: Icon(
                      mode == LoopMode.one
                          ? Icons.repeat_one_outlined
                          : Icons.repeat_outlined,
                      color: mode != LoopMode.off
                          ? Theme.of(context).primaryColor
                          : (controller.isRadio.value ? Colors.grey : fcolor),
                    ),
                  );
                },
              ),
              StreamBuilder<bool>(
                  stream: controller.player.value.shuffleModeEnabledStream,
                  builder: (context, snapshot) {
                    bool shuffle = false;
                    if (snapshot.hasData) {
                      shuffle = snapshot.data ?? false;
                    }
                    return IconButton(
                      iconSize: 30,
                      onPressed:
                          controller.isRadio.value || controller.isYoutube.value
                              ? null
                              : () {
                                  controller.toggleShuffle();
                                },
                      icon: Icon(
                        Icons.shuffle_rounded,
                        color: shuffle
                            ? Theme.of(context).primaryColor
                            : (controller.isRadio.value ||
                                    controller.isYoutube.value
                                ? Colors.grey
                                : fcolor),
                      ),
                    );
                  }),
              IconButton(
                iconSize: 30,
                onPressed:
                    controller.isRadio.value || controller.isYoutube.value
                        ? null
                        : () {
                            controller.toggleFavourite();
                          },
                icon: controller.isFavourite.value
                    ? Icon(
                        Icons.favorite,
                        color: controller.isRadio.value ||
                                controller.isYoutube.value
                            ? Colors.grey
                            : Colors.red,
                      )
                    : const Icon(Icons.favorite_outline),
              ),
              IconButton(
                iconSize: 30,
                onPressed: () {
                  showMaterialModalBottomSheet(
                    context: context,
                    builder: (context) => PlaylistQueue(),
                  );
                },
                icon: const Icon(Icons.queue_music_rounded),
              ),
            ],
          ),
        );
      },
    );
  }
}

class Lyrics extends StatelessWidget {
  const Lyrics({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color bcolor = Get.isDarkMode ? Colors.black : Colors.white;
    Color fcolor = Get.isDarkMode ? Colors.white : Colors.black;
    return GetX<PlayerController>(builder: (controller) {
      return Expanded(
        child: Container(
          color: bcolor.withOpacity(.2),
          margin: const EdgeInsets.only(bottom: 10),
          child: controller.lyricsLoading.value
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const CircularProgressIndicator(),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Loading lyrics',
                        style: xtitle,
                      ),
                    )
                  ],
                )
              : controller.getLyricsValue.value.isNotEmpty
                  ? Scrollbar(
                      child: SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 16, horizontal: 10),
                          child: Text(
                            controller.getLyricsValue.value,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 22,
                            ),
                          ),
                        ),
                      ),
                    )
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.error_outline_outlined,
                          size: 60,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(14.0),
                          child: Text(
                            'Lyrics Not Found',
                            style: xheading,
                          ),
                        )
                      ],
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
    return Expanded(
      child: Container(
        child: GetX<PlayerController>(
          builder: (controller) {
            return controller.isYoutube.value
                ? CachedNetworkImage(
                    fit: BoxFit.cover,
                    imageUrl: controller.getArtUrl.value,
                    errorWidget: (context, _, __) => Image(
                      fit: BoxFit.cover,
                      image: AssetImage(
                        'lib/assets/${getThemedAsset('youtube.png')}',
                      ),
                    ),
                    placeholder: (context, url) => Image(
                      fit: BoxFit.cover,
                      image: AssetImage(
                        'lib/assets/${getThemedAsset('youtube.png')}',
                      ),
                    ),
                  )
                : QueryArtworkWidget(
                    id: int.parse(controller.id.value),
                    quality: 100,
                    type: ArtworkType.AUDIO,
                    artworkBorder: BorderRadius.zero,
                    artworkFit: BoxFit.contain,
                    nullArtworkWidget: Image.asset(
                      controller.isRadio.value
                          ? 'lib/assets/${getThemedAsset('radio.png')}'
                          : 'lib/assets/${getThemedAsset('cover.png')}',
                      fit: BoxFit.contain,
                    ),
                  );
          },
        ),
        padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 40),
      ),
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
    Color fcolor = Get.isDarkMode ? Colors.white : Colors.black;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Current Queue'),
        centerTitle: true,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        foregroundColor: fcolor,
        elevation: 0,
      ),
      body: Scrollbar(
        child: ListView.builder(
          itemCount: (playerController.player.value.sequence ?? []).length,
          itemBuilder: (context, int index) {
            MediaItem audio = playerController
                .getQueueAudio(playerController.currentQueueList[index]);
            return SongTile(
              startPlaylist: (int pos) async {
                await playAudios(pos);
              },
              audio: audio,
              trailing: false,
              index: playerController.currentQueueList[index],
              isLast: index + 1 ==
                  (playerController.player.value.sequence ?? []).length,
            );
          },
        ),
      ),
    );
  }
}
