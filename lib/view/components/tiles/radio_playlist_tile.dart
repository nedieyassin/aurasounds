import 'package:aurasounds/controller/player_controller.dart';
import 'package:aurasounds/utils/helpers.dart';
import 'package:aurasounds/view/components/sections/discover/radios_sliver_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:on_audio_query/on_audio_query.dart';

class RadioPlaylistTile extends StatelessWidget {
  const RadioPlaylistTile({
    Key? key,
  }) : super(key: key);

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
                  () => RadiosSliverPage(),
                );
              },
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.asset(
                    'lib/assets/${getThemedAsset('radio.png')}',
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
              "Radio Stations",
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
