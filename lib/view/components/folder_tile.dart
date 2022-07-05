import 'package:aurasounds/controller/player_controller.dart';
import 'package:aurasounds/model/database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FolderTile extends StatelessWidget {
  const FolderTile(
      {Key? key,
      required this.folder,
      required this.folderSongs,
      required this.isLast})
      : super(key: key);
  final FolderModel folder;
  final Function folderSongs;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    var playerController = Get.find<PlayerController>();
    return Container(
      margin:
          EdgeInsets.only(bottom: isLast ? 160 : 0, left: 10, right: 10, top: 8),
      padding: const EdgeInsets.only(left: 2, right: 18),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: const BorderRadius.all(Radius.circular(14)),
      ),
      child: ListTile(
        onTap: () {
          folderSongs();
          playerController.setFolder(folder.folder, folder.folderUri);
        },
        leading: const Icon(Icons.folder,size: 26,),
        title: Text(
          folder.folder,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Text('${folder.numberOfSongs.toString()} song${folder.numberOfSongs > 1?'s':''}'),
      ),
    );
  }
}
