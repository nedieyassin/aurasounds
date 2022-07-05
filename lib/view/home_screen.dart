import 'package:aurasounds/controller/player_controller.dart';
import 'package:aurasounds/utils/constants.dart';
import 'package:aurasounds/view/components/search_widget.dart';
import 'package:aurasounds/view/components/song_tile.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 6),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.only(left: 16),
                  child: Text(
                    'aurasounds',
                    style: xheading.copyWith(
                        fontSize: 38,
                        color: Theme.of(context).primaryColor,
                        fontFamily: 'Cust'),
                  ),
                ),
                const SearchWidget()
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  RecentlyPlayedSection(
                    title: 'Recently Played Songs',
                  ),
                  MostlyPlayedSection(
                    title: 'Most Played',
                  ),
                  FavouriteSection(
                    title: 'Favourite',
                  ),
                  const SizedBox(
                    height: 160,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class RecentlyPlayedSection extends StatelessWidget {
  RecentlyPlayedSection({
    Key? key,
    required this.title,
  }) : super(key: key);
  final String title;

  var playerController = Get.find<PlayerController>();

  Future<void> playAudios(int position) async {
    await playerController.startPlaylist(
      position: position,
      playlist: 'recentplayed',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        XGridHead(
          title: title,
          onMore: () {
            showMaterialModalBottomSheet(
              context: context,
              builder: (context) => RecentPage(),
            );
          },
        ),
        GetX<PlayerController>(
          builder: (controller) {
            List<MediaItem> _list = [];
            for (var item in controller.recentlyPlayedSongList.value) {
              if (_list.length < 3) {
                _list.add(item);
              }
            }
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: controller.noOfRecentlyPlayedSongs.value > 0
                  ? StaggeredGrid.count(
                      crossAxisCount: 6,
                      mainAxisSpacing: 4,
                      crossAxisSpacing: 2.5,
                      children: _list.asMap().entries.map((entry) {
                        int index = entry.key;
                        MediaItem audio = entry.value;
                        return XGrid(
                          audio: audio,
                          onPlay: () {
                            playAudios(index);
                          },
                        );
                      }).toList(),
                    )
                  : Padding(
                      padding: const EdgeInsets.symmetric(vertical: 30),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const Icon(
                            Icons.error_outline_outlined,
                            size: 40,
                          ),
                          Center(
                            child: Padding(
                              padding: const EdgeInsets.all(14.0),
                              child: Text(
                                'No recently played songs',
                                style: xheading.copyWith(fontSize: 18),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
            );
          },
        )
      ],
    );
  }
}

class MostlyPlayedSection extends StatelessWidget {
  MostlyPlayedSection({
    Key? key,
    required this.title,
  }) : super(key: key);
  final String title;

  var playerController = Get.find<PlayerController>();

  Future<void> playAudios(int position) async {
    await playerController.startPlaylist(
      position: position,
      playlist: 'mostplayed',
    );
  }

  @override
  Widget build(BuildContext context) {
    Color fcolor = Get.isDarkMode ? Colors.white : Colors.black;
    return Column(
      children: [
        XGridHead(
          title: title,
          onMore: () {
            showMaterialModalBottomSheet(
              context: context,
              builder: (context) => MostlyPage(),
            );
          },
        ),
        GetX<PlayerController>(
          builder: (controller) {
            List<MediaItem> _list = [];
            for (var item in controller.mostlyPlayedSongList.value) {
              if (_list.length < 3) {
                _list.add(item);
              }
            }
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: controller.noOfMostlyPlayedSongs.value > 0
                  ? StaggeredGrid.count(
                      crossAxisCount: 6,
                      mainAxisSpacing: 4,
                      crossAxisSpacing: 2.5,
                      children: _list.asMap().entries.map((entry) {
                        int index = entry.key;
                        MediaItem audio = entry.value;
                        return XGrid(
                          audio: audio,
                          onPlay: () {
                            playAudios(index);
                          },
                        );
                      }).toList(),
                    )
                  : Padding(
                      padding: const EdgeInsets.symmetric(vertical: 30),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const Icon(
                            Icons.error_outline_outlined,
                            size: 40,
                          ),
                          Center(
                            child: Padding(
                              padding: const EdgeInsets.all(14.0),
                              child: Text(
                                'No mostly played songs',
                                style: xheading.copyWith(fontSize: 18),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
            );
          },
        )
      ],
    );
  }
}

class FavouriteSection extends StatelessWidget {
  FavouriteSection({
    Key? key,
    required this.title,
  }) : super(key: key);
  final String title;

  var playerController = Get.find<PlayerController>();

  Future<void> playAudios(int position) async {
    await playerController.startPlaylist(
      position: position,
      playlist: 'favourite',
    );
  }

  @override
  Widget build(BuildContext context) {
    Color fcolor = Get.isDarkMode ? Colors.white : Colors.black;
    return Column(
      children: [
        XGridHead(
          title: title,
          onMore: () {
            showMaterialModalBottomSheet(
              context: context,
              builder: (context) => FavPage(),
            );
          },
        ),
        GetX<PlayerController>(
          builder: (controller) {
            List<MediaItem> _list = [];
            for (var item in controller.favSongList.value) {
              if (_list.length < 3) {
                _list.add(item);
              }
            }

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: controller.noOfFavSongs.value > 0
                  ? StaggeredGrid.count(
                      crossAxisCount: 6,
                      mainAxisSpacing: 4,
                      crossAxisSpacing: 2.5,
                      children: _list.asMap().entries.map((entry) {
                        int index = entry.key;
                        MediaItem audio = entry.value;
                        return XGrid(
                          audio: audio,
                          onPlay: () {
                            playAudios(index);
                          },
                        );
                      }).toList(),
                    )
                  : Padding(
                      padding: const EdgeInsets.symmetric(vertical: 30),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const Icon(
                            Icons.error_outline_outlined,
                            size: 40,
                          ),
                          Center(
                            child: Padding(
                              padding: const EdgeInsets.all(14.0),
                              child: Text(
                                'No favourite songs ',
                                style: xheading.copyWith(fontSize: 18),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
            );
          },
        )
      ],
    );
  }
}

class XGridHead extends StatelessWidget {
  const XGridHead({
    Key? key,
    required this.title,
    required this.onMore,
  }) : super(key: key);

  final String title;
  final Function onMore;

  @override
  Widget build(BuildContext context) {
    Color fcolor = Get.isDarkMode ? Colors.white : Colors.black;
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20, top: 30),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            title,
            style: xtitle.copyWith(color: fcolor.withOpacity(.7)),
          ),
          ElevatedButton(
            child: const Text(
              'More',
            ),
            onPressed: () {
              onMore();
            },
            style: buildButtonStyle(),
          )
        ],
      ),
    );
  }
}

class XGrid extends StatelessWidget {
  const XGrid({
    Key? key,
    required this.audio,
    required this.onPlay,
  }) : super(key: key);

  final MediaItem audio;
  final Function onPlay;

  @override
  Widget build(BuildContext context) {
    Color fcolor = Get.isDarkMode ? Colors.white : Colors.black;
    Color bcolor = Get.isDarkMode ? Colors.black : Colors.white;
    return StaggeredGridTile.count(
      crossAxisCellCount: 2,
      mainAxisCellCount: 2.5,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: GetX<PlayerController>(builder: (controller) {
              return Container(
                  margin: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    border: Border.all(
                        width: 4,
                        color: controller.getCurrentAudioId.value ==
                                int.parse(audio.id)
                            ? Theme.of(context).primaryColor
                            : fcolor.withOpacity(.2)),
                    borderRadius: BorderRadius.circular(20),
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
                            'lib/assets/art.png',
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
                                    EvaIcons.barChart,
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
                  ));
            }),
          ),
          Text(
            audio.title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          Text(
            audio.artist!,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          )
        ],
      ),
    );
  }
}

ButtonStyle buildButtonStyle() {
  Color fcolor = Get.isDarkMode ? Colors.white : Colors.black;
  return ButtonStyle(
    backgroundColor: MaterialStateProperty.all(
      fcolor.withOpacity(0.07),
    ),
    foregroundColor: MaterialStateProperty.all(fcolor),
    padding: MaterialStateProperty.all(
      const EdgeInsets.symmetric(horizontal: 26, vertical: 2),
    ),
    shape: MaterialStateProperty.all(
      RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(99),
      ),
    ),
    elevation: MaterialStateProperty.all(0),
  );
}

class RecentPage extends StatelessWidget {
  RecentPage({
    Key? key,
  }) : super(key: key);

  var playerController = Get.find<PlayerController>();

  Future<void> playAudios(int position) async {
    await playerController.startPlaylist(
      position: position,
      playlist: 'recentplayed',
    );
  }

  @override
  Widget build(BuildContext context) {
    Color bcolor = Get.isDarkMode ? Colors.black : Colors.white;
    Color fcolor = Get.isDarkMode ? Colors.white : Colors.black;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Recently Played Songs'),
        centerTitle: true,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        foregroundColor: fcolor,
        elevation: 0,
      ),
      body: Container(
        color: bcolor,
        child: Scrollbar(
          child: GetX<PlayerController>(builder: (controller) {
            return ListView.builder(
              itemCount: controller.noOfRecentlyPlayedSongs.value,
              itemBuilder: (context, int index) {
                MediaItem audio =
                    playerController.getRecentlyPlayedAudio(index);
                return SongTile(
                  startPlaylist: (int pos) async {
                    await playAudios(pos);
                  },
                  audio: audio,
                  index: index,
                  showNumber: true,
                  isLast: index + 1 == controller.noOfRecentlyPlayedSongs.value,
                );
              },
            );
          }),
        ),
      ),
    );
  }
}

class MostlyPage extends StatelessWidget {
  MostlyPage({
    Key? key,
  }) : super(key: key);

  var playerController = Get.find<PlayerController>();

  Future<void> playAudios(int position) async {
    await playerController.startPlaylist(
      position: position,
      playlist: 'mostplayed',
    );
  }

  @override
  Widget build(BuildContext context) {
    Color bcolor = Get.isDarkMode ? Colors.black : Colors.white;
    Color fcolor = Get.isDarkMode ? Colors.white : Colors.black;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mostly Played Songs'),
        centerTitle: true,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        foregroundColor: fcolor,
        elevation: 0,
      ),
      body: Container(
        color: bcolor,
        child: Scrollbar(
          child: GetX<PlayerController>(builder: (controller) {
            return ListView.builder(
              itemCount: controller.noOfMostlyPlayedSongs.value,
              itemBuilder: (context, int index) {
                MediaItem audio = playerController.getMostlyPlayedAudio(index);
                return SongTile(
                  startPlaylist: (int pos) async {
                    await playAudios(pos);
                  },
                  audio: audio,
                  index: index,
                  showPlayCount: true,
                  isLast: index + 1 == controller.noOfMostlyPlayedSongs.value,
                );
              },
            );
          }),
        ),
      ),
    );
  }
}

class FavPage extends StatelessWidget {
  FavPage({
    Key? key,
  }) : super(key: key);

  var playerController = Get.find<PlayerController>();

  Future<void> playAudios(int position) async {
    await playerController.startPlaylist(
      position: position,
      playlist: 'favourite',
    );
  }

  @override
  Widget build(BuildContext context) {
    Color bcolor = Get.isDarkMode ? Colors.black : Colors.white;
    Color fcolor = Get.isDarkMode ? Colors.white : Colors.black;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favourite Songs'),
        centerTitle: true,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        foregroundColor: fcolor,
        elevation: 0,
      ),
      body: Container(
        color: bcolor,
        child: Scrollbar(
          child: GetX<PlayerController>(builder: (controller) {
            return ListView.builder(
              itemCount: controller.noOfFavSongs.value,
              itemBuilder: (context, int index) {
                MediaItem audio = playerController.getFavAudio(index);
                return SongTile(
                  startPlaylist: (int pos) async {
                    await playAudios(pos);
                  },
                  audio: audio,
                  index: index,
                  isFav: true,
                  isLast: index + 1 == controller.noOfFavSongs.value,
                );
              },
            );
          }),
        ),
      ),
    );
  }
}
