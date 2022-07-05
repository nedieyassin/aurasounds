import 'package:aurasounds/utils/constants.dart';
import 'package:aurasounds/view/components/all_songs.dart';
import 'package:aurasounds/view/components/search_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LibraryScreen extends StatelessWidget {
  LibraryScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color fcolor = Get.isDarkMode ? Colors.white : Colors.black;
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                      left: 18, right: 12, top: 26, bottom: 14),
                  child: Text(
                    'Library',
                    style: xheading.copyWith(
                      color:fcolor.withOpacity(.7),
                      fontFamily: 'Cust',
                    ),
                  ),
                ),
                const SearchWidget()
              ],
            ),
            Expanded(
              child: AllSongsPage(),
            )
          ],
        ),
      ),
    );
  }
}

