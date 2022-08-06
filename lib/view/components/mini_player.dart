import 'package:aurasounds/controller/player_controller.dart';
import 'package:aurasounds/utils/constants.dart';
import 'package:aurasounds/utils/helpers.dart';
import 'package:aurasounds/view/screens/playing_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:on_audio_query/on_audio_query.dart';

class MiniPlayer extends StatelessWidget {
  const MiniPlayer({
    Key? key,
  }) : super(key: key);

  void openNowPlaying(BuildContext context) {
    showMaterialModalBottomSheet(
      context: context,
      builder: (context) => PlayingScreen(),
    );
    // Get.bottomSheet(FolderSongsBottomSheet(), isScrollControlled: true);
  }

  @override
  Widget build(BuildContext context) {
    Color bcolor = Get.isDarkMode ? Colors.black : Colors.white;
    Color fcolor = Get.isDarkMode ? Colors.white : Colors.black;
    return GetX<PlayerController>(builder: (controller) {
      return controller.id.value.isEmpty ? const SizedBox() :  Container(
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
            color: bcolor.withOpacity(.16),
            border: Border(
              top: BorderSide(
                width: 2,
                color: Colors.grey.withOpacity(.05),
              ),
            )),
        child: Slidable(
          key: UniqueKey(),
          closeOnScroll: true,
          direction: Axis.horizontal,
          startActionPane: ActionPane(
            openThreshold: 0.1,
            dragDismissible: false,
            extentRatio: 0.2,
            motion: const BehindMotion(),
            // A pane can dismiss the Slidable.
            dismissible: DismissiblePane(
              confirmDismiss: () async {
                return false;
              },
              onDismissed: () {},
            ),
            // All actions are defined in the children parameter.
            children: [
              // A SlidableAction can have an icon and/or a label.
              SlidableAction(
                onPressed: (ctx) {
                  if (controller.player.value.hasPrevious) {
                    controller.player.value.seekToPrevious();
                  }
                },
                backgroundColor: Theme.of(context).primaryColor.withOpacity(.3),
                foregroundColor: Theme.of(context).primaryColor,
                icon: Icons.skip_previous_rounded,
              ),
            ],
          ),
          // The end action pane is the one at the right or the bottom side.
          endActionPane: ActionPane(
            openThreshold: 0.1,
            dragDismissible: false,
            extentRatio: 0.2,
            motion: const BehindMotion(),
            // A pane can dismiss the Slidable.
            dismissible: DismissiblePane(
              confirmDismiss: () async {
                return false;
              },
              onDismissed: () {},
            ),
            // All actions are defined in the children parameter.
            children: [
              // A SlidableAction can have an icon and/or a label.
              SlidableAction(
                onPressed: (ctx) {
                  if (controller.player.value.hasNext) {
                    controller.player.value.seekToNext();
                  }
                },
                backgroundColor: Theme.of(context).primaryColor.withOpacity(.3),
                foregroundColor: Theme.of(context).primaryColor,
                icon: Icons.skip_next_rounded,
              ),
            ],
          ),
          child: ListTile(
            onTap: () {
              openNowPlaying(context);
            },
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(9),
              child: QueryArtworkWidget(
                id: int.parse(controller.id.value),
                type: ArtworkType.AUDIO,
                artworkBorder: BorderRadius.zero,
                nullArtworkWidget: Image.asset(
                  controller.isRadio.value
                      ? 'lib/assets/${getThemedAsset('radio.png')}'
                      : 'lib/assets/${getThemedAsset('art.png')}',
                  fit: BoxFit.cover,
                  height: 48,
                ),
              ),
            ),
            title: Text(
              controller.getMeta(controller.title.value),
              style: xtitle.copyWith(fontSize: 18),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            subtitle: StreamBuilder<Duration>(
                stream: controller.hasCurrent.value
                    ? controller.player.value.positionStream
                    : const Stream.empty(),
                builder: (context, snapshot) {
                  int? current =
                      snapshot.hasData ? snapshot.data!.inMilliseconds : 0;

                  return controller.isRadio.value
                      ? Text(controller.artist.value)
                      : Text(
                          formatDuration(
                            Duration(milliseconds: current),
                          ),
                        );
                }),
            trailing: StreamBuilder<ProcessingState>(
              stream: controller.player.value.processingStateStream,
              builder: (context, snap) {
                if (snap.hasData && !snap.hasError) {
                  if (snap.data != ProcessingState.buffering &&
                      snap.data != ProcessingState.loading) {
                    return StreamBuilder<bool>(
                        stream: controller.player.value.playingStream,
                        builder: (context, asyncSnapshot) {
                          if (asyncSnapshot.hasData) {
                            bool playing = asyncSnapshot.data as bool;
                            return Container(
                              decoration: BoxDecoration(
                                color: Theme.of(context).primaryColor,
                                borderRadius: BorderRadius.circular(99),
                              ),
                              child: IconButton(
                                iconSize: 30,
                                onPressed: () {
                                  controller.play();
                                },
                                color: Colors.white,
                                splashColor: Theme.of(context)
                                    .primaryColor
                                    .withOpacity(.5),
                                icon: Icon(playing
                                    ? Icons.pause_rounded
                                    : Icons.play_arrow_rounded),
                              ),
                            );
                          } else {
                            return Container(
                              decoration: BoxDecoration(
                                color: Theme.of(context).primaryColor,
                                borderRadius: BorderRadius.circular(99),
                              ),
                              child: IconButton(
                                iconSize: 30,
                                onPressed: () {
                                  controller.play();
                                },
                                color: Colors.white,
                                splashColor: Theme.of(context)
                                    .primaryColor
                                    .withOpacity(.5),
                                icon: const Icon(Icons.play_arrow_rounded),
                              ),
                            );
                          }
                        });
                  } else {
                    return IconButton(
                      icon: const CircularProgressIndicator(),
                      iconSize: 30,
                      onPressed: () {},
                    );
                  }
                } else {
                  return const Icon(Icons.error_outline_outlined);
                }
              },
            ),
          ),
        ),
      );
    });
  }
}

// controller.player.value.hasPrevious &&
// controller.player.value.hasNext
// ? DismissDirection.horizontal
//     : (controller.player.value.hasPrevious
// ? DismissDirection.startToEnd
//     : controller.player.value.hasNext
// ? DismissDirection.endToStart
//     : DismissDirection.none)
