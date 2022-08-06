import 'package:aurasounds/model/type.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:line_icons/line_icons.dart';

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
    Color bcolor = Get.isDarkMode ? Colors.black : Colors.white;
    return Container(
      margin: EdgeInsets.only(
          bottom: isLast ? 160 : 0, left: 10, right: 10,top: 4),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14.0),
        ),
        elevation: 0.6,
        margin: const EdgeInsets.all(0),
        child: ListTile(
          onTap: () {
            folderSongs();
          },
          leading: const Icon(
            LineIcons.folderOpenAlt,
            size: 26,
          ),
          title: Text(
            folder.folder,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          subtitle: Text(
              '${folder.numberOfSongs.toString()} song${folder.numberOfSongs > 1 ? 's' : ''}'),
        ),
      ),
    );
  }
}
