import 'package:aurasounds/controller/nav_controller.dart';
import 'package:aurasounds/controller/player_controller.dart';
import 'package:aurasounds/utils/constants.dart';
import 'package:aurasounds/view/components/song_tile.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:on_audio_query/on_audio_query.dart';

class LibraryScreen extends StatelessWidget {
  LibraryScreen({Key? key}) : super(key: key);
  var playerController = Get.find<PlayerController>();
  var navController = Get.find<NavController>();

  Future<void> playAudios(int position) async {
    await playerController.startPlaylist(position: position);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          Expanded(
            child: Scrollbar(
              child: GetX<PlayerController>(
                builder: (controller) {
                  return ListView.builder(
                      itemCount: controller.noOfSongs.value + 1,
                      itemBuilder: (BuildContext context, int index) {
                        if (index == 0) {
                          return Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(
                                  left: 12,
                                  right: 12,
                                  top: 26,
                                ),
                                child: Text(
                                  'Library',
                                  style: xheading.copyWith(
                                      color: Colors.grey.shade600,
                                      fontFamily: 'Cust'),
                                ),
                              ),
                              SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 16),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      TabCycle(
                                        color: Colors.blue,
                                        icon: EvaIcons.list,
                                        tab: controller.tabValue.value,
                                        tabKey: 'allsongs',
                                        label: 'All songs',
                                        onTap: () {
                                          // controller.getPlaylist();
                                          controller.getTab('allsongs');
                                        },
                                      ),
                                      TabCycle(
                                        color: Colors.orange,
                                        icon: EvaIcons.shuffle,
                                        tab: controller.tabValue.value,
                                        label: 'Shuffle',
                                        onTap: () {},
                                      ),
                                      TabCycle(
                                        color: Colors.teal,
                                        icon: EvaIcons.search,
                                        tab: controller.tabValue.value,
                                        label: 'Search',
                                        onTap: () {},
                                      ),
                                      TabCycle(
                                        color: Colors.purple,
                                        icon: EvaIcons.folderOutline,
                                        tab: controller.tabValue.value,
                                        tabKey: 'folders',
                                        label: 'Folders',
                                        onTap: () {
                                          controller.getTab('folders');
                                        },
                                      ),
                                      TabCycle(
                                        color: Colors.pink,
                                        icon: EvaIcons.heart,
                                        tab: controller.tabValue.value,
                                        label: 'Favourite',
                                        onTap: () {},
                                      ),
                                      TabCycle(
                                        color: Colors.indigo,
                                        icon: EvaIcons.clockOutline,
                                        tab: controller.tabValue.value,
                                        label: 'Recently Played',
                                        onTap: () {},
                                      ),
                                      TabCycle(
                                        color: Colors.brown,
                                        icon: EvaIcons.headphones,
                                        tab: controller.tabValue.value,
                                        label: 'Most Played',
                                        onTap: () {},
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  GetX<PlayerController>(builder: (controller) {
                                    return Padding(
                                      padding: const EdgeInsets.only(
                                          top: 16, left: 12, bottom: 8),
                                      child: Text(
                                        '${controller.getCurrentTabText.value} (${controller.noOfSongs})',
                                        style: xtitle,
                                      ),
                                    );
                                  }),
                                  DropdownButton(
                                    // Initial Value
                                    value: controller.sortValue.value,

                                    // Array list of items
                                    items: controller.sortType.value
                                        .map((Map item) {
                                      return DropdownMenuItem(
                                        value: item['value'] as String,
                                        child: Text(item['label']),
                                      );
                                    }).toList(),
                                    // After selecting the desired option,it will
                                    // change button value to selected value
                                    onChanged: (String? value) {
                                      controller.setSortOrder(value!);
                                    },
                                  )
                                ],
                              )
                            ],
                          );
                        } else {
                          SongModel audio = controller.getAudio(index - 1);
                          return SongTile(
                            startPlaylist: (int pos) async {
                              await playAudios(pos);
                            },
                            audio: audio,
                            index: index - 1,
                          );
                        }
                      });
                },
              ),
            ),
          )
        ],
      ),
    );
  }
}

class TabCycle extends StatelessWidget {
  const TabCycle({
    Key? key,
    required this.color,
    required this.icon,
    required this.label,
    required this.onTap,
    required this.tab,
    this.tabKey = '',
  }) : super(key: key);

  final Color color;
  final IconData icon;
  final String label;
  final String tab;
  final String tabKey;
  final Function? onTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: const EdgeInsets.only(bottom: 10, left: 10, right: 10),
          child: ElevatedButton(
            child: Icon(
              icon,
              color: color,
            ),
            onPressed: () {
              onTap!();
            },
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(color.withOpacity(.2)),
              padding: MaterialStateProperty.all(
                const EdgeInsets.all(20),
              ),
              shape: MaterialStateProperty.all(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(99),
                ),
              ),
              elevation: MaterialStateProperty.all(0),
            ),
          ),
        ),
        Text(label),
      ],
    );
  }
}
