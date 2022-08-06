import 'package:aurasounds/controller/library_controller.dart';
import 'package:aurasounds/model/type.dart';
import 'package:aurasounds/utils/constants.dart';
import 'package:aurasounds/view/components/tiles/folder_tile.dart';
import 'package:aurasounds/view/screens/pages/folder_sliver_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class FoldersTab extends StatelessWidget {
  FoldersTab({Key? key}) : super(key: key);

  final libraryController = Get.find<LibraryController>();

  void openFolderSongs(FolderModel folder) {
    libraryController.initGetFolderSongs(folder.folderUri);
    Get.to(() => FolderSliverPage(
          folder: folder,
        ));
  }

  @override
  Widget build(BuildContext context) {
    Color bcolor = Get.isDarkMode ? Colors.black : Colors.white;
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            GetX<LibraryController>(
              builder: (controller) {
                return Padding(
                  padding: const EdgeInsets.only(
                    top: 10,
                    left: 16,
                    bottom: 8,
                  ),
                  child: Text(
                    '${controller.folderList.value.length} Folders',
                  ),
                );
              },
            ),
            const Spacer(),
            Opacity(
              opacity: 0,
              child: IconButton(
                onPressed: () async {
                },
                icon: const Icon(Icons.play_arrow_rounded),
              ),
            ),

          ],
        ),
        Expanded(
          child: Scrollbar(
            child: GetX<LibraryController>(
              builder: (controller) {
                return controller.folderList.value.isNotEmpty
                    ? ListView.builder(
                        itemCount: controller.folderList.value.length,
                        physics: const BouncingScrollPhysics(),
                        itemBuilder: (BuildContext context, int index) {
                          FolderModel folder = controller.folderList.value[index];
                          return FolderTile(
                            isLast: index + 1 == controller.folderList.value.length,
                            folder: folder,
                            folderSongs: () {
                              openFolderSongs(folder);
                            },
                          );
                        })
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const Icon(
                            Icons.error_outline_outlined,
                            size: 60,
                          ),
                          Center(
                            child: Padding(
                              padding: const EdgeInsets.all(14.0),
                              child: Text(
                                'No Folders',
                                style: xheading,
                              ),
                            ),
                          )
                        ],
                      );
              },
            ),
          ),
        ),
      ],
    );
  }
}
