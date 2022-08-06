import 'package:aurasounds/controller/library_controller.dart';
import 'package:aurasounds/controller/player_controller.dart';
import 'package:aurasounds/utils/helpers.dart';
import 'package:aurasounds/view/components/sections/discover/radios_sliver_page.dart';
import 'package:aurasounds/view/screens/pages/home_sliver_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:on_audio_query/on_audio_query.dart';

class MostPlayedTile extends StatelessWidget {
  MostPlayedTile({
    Key? key,
  }) : super(key: key);

  final libraryController = Get.find<LibraryController>();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 130,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () {
                Get.to(
                  () => HomeSliverPage(
                    title: 'Most Played',
                    playlist: 'mostplayed',
                    music: libraryController.initGetMostlyPlayedSongs(),
                    showPlayCount: true,
                  ),
                );
              },
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.asset(
                    'lib/assets/${getThemedAsset('playlist.png')}',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 10.0,
            ),
            child: Text(
              "Most Played",
              textAlign: TextAlign.center,
              softWrap: false,
              overflow: TextOverflow.ellipsis,
            ),
          )
        ],
      ),
    );
  }
}
