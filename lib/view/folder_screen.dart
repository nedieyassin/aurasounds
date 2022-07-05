import 'package:aurasounds/utils/constants.dart';
import 'package:aurasounds/view/components/all_folders.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
class FolderScreen extends StatelessWidget {
  FolderScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    Color fcolor = Get.isDarkMode ? Colors.white : Colors.black;
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(
                left: 18,
                right: 12,
                top: 26,
                bottom: 26
              ),
              child: Text(
                'Folders',
                style: xheading.copyWith(
                  color:fcolor.withOpacity(.7),
                  fontFamily: 'Cust',
                ),
              ),
            ),
            Expanded(
              child: AllFoldersPage(),
            )
          ],
        ),
      ),
    );
  }
}
