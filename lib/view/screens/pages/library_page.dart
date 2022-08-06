import 'package:aurasounds/controller/library_controller.dart';
import 'package:aurasounds/utils/helpers.dart';
import 'package:aurasounds/view/screens/pages/library/albums_tab.dart';
import 'package:aurasounds/view/screens/pages/library/artists_tab.dart';
import 'package:aurasounds/view/screens/pages/library/folders_tab.dart';
import 'package:aurasounds/view/screens/pages/library/songs_tab.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LibraryPage extends StatefulWidget {
  const LibraryPage({Key? key}) : super(key: key);

  @override
  State<LibraryPage> createState() => _LibraryPageState();
}

class _LibraryPageState extends State<LibraryPage>
    with TickerProviderStateMixin {
  final libraryController = Get.find<LibraryController>();
  TabController? _tcontroller;

  @override
  void initState() {
    _tcontroller = TabController(length: 4, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    _tcontroller!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Color fcolor = !Get.isDarkMode ? Colors.black : Colors.white;
    return Column(
      children: [
        TabBar(
          controller: _tcontroller,
          indicatorSize: TabBarIndicatorSize.label,
          isScrollable: true,
          tabs: [
            Tab(
              child: Text(
                'Songs',
                style: TextStyle(color: fcolor),
              ),
            ),
            Tab(
              child: Text(
                'Folders',
                style: TextStyle(color: fcolor),
              ),
            ),
            Tab(
              child: Text(
                'Albums',
                style: TextStyle(color: fcolor),
              ),
            ),
            Tab(
              child: Text(
                'Artists',
                style: TextStyle(color: fcolor),
              ),
            ),
            // Tab(
            //   child: Text(
            //     'Playlists',
            //     style: TextStyle(color: fcolor),
            //   ),
            // ),
          ],
        ),
        Expanded(
          child: TabBarView(
            controller: _tcontroller,
            physics: const CustomPhysics(),
            children: [
              SongsTab(),
              FoldersTab(),
              AlbumsTab(),
              ArtistTab(),
              // SongsTab(),
            ],
          ),
        )
      ],
    );
  }
}
