import 'package:aurasounds/utils/constants.dart';
import 'package:aurasounds/view/components/about.dart';
import 'package:aurasounds/view/components/change_theme.dart';
import 'package:aurasounds/view/components/developers.dart';
import 'package:aurasounds/view/components/terms.dart';
import 'package:aurasounds/view/components/update_library.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color fcolor = Get.isDarkMode ? Colors.white : Colors.black;
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(
                left: 12,
                right: 12,
                top: 26,
              ),
              child: Text(
                'Settings',
                style: xheading.copyWith(
                  color: fcolor.withOpacity(.7),
                  fontFamily: 'Cust',
                ),
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            XListTile(
              icon: Icons.queue_music_rounded,
              title: 'Update Song Library',
              intro: 'Load new songs into aurasounds\'s song database',
              buttonText: 'Update Library',
              onTap: () {
                Get.to(
                  () => XBottomSheet(
                    title: 'Update Song Library',
                    body: UpdateLibrary(),
                  ),
                );
              },
              focus: true,
            ),
            XListTile(
              icon: Icons.color_lens_rounded,
              title: 'Change Accent Colour',
              intro: 'Customise aurasounds to look as you wish',
              buttonText: 'Change Theme',
              onTap: () {
                Get.to(
                  () => XBottomSheet(
                    title: 'Change Accent Colour',
                    body: ChangeTheme(),
                  ),
                );
              },
            ),
            XListTile(
              icon: Icons.grid_view_rounded,
              title: 'Terms of Use',
              intro:
                  'The app is copyrighted to its developers, it should not be sold or cloned',
              buttonText: 'See more',
              onTap: () {
                Get.to(
                      () => const XBottomSheet(
                    title: 'Terms of Use',
                    body: TermsScreen(),
                  ),
                );
              },
            ),
            XListTile(
              icon:Icons.info_outline_rounded,
              title: 'About aurasounds',
              intro:
                  'Aurasounds is a feature rich music player made by music lover for music lovers.',
              buttonText: 'See more',
              onTap: () {
                Get.to(
                      () => const XBottomSheet(
                    title: 'About aurasounds',
                    body: AboutScreen(),
                  ),
                );
              },
            ),
            XListTile(
              icon: Icons.business,
              title: 'Developers',
              intro: 'This app is developed and maintained by strollec',
              buttonText: 'View Details',
              onTap: () {
                Get.to(
                  () => const XBottomSheet(
                    title: 'Developers',
                    body: Developers(),
                  ),
                );
              },
            ),
            const SizedBox(
              height: 200,
            )
          ],
        ),
      ),
    );
  }
}

class XBottomSheet extends StatelessWidget {
  const XBottomSheet({
    Key? key,
    required this.title,
    required this.body,
  }) : super(key: key);
  final String title;
  final Widget body;

  @override
  Widget build(BuildContext context) {
    Color fcolor = Get.isDarkMode ? Colors.white : Colors.black;
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        elevation: 0,
        centerTitle: true,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        foregroundColor: fcolor,
      ),
      body: SingleChildScrollView(
        child: body,
      ),
    );
  }
}


class FullPage extends StatelessWidget {
  const FullPage({
    Key? key,
    required this.title,
    required this.body,
  }) : super(key: key);
  final String title;
  final Widget body;

  @override
  Widget build(BuildContext context) {
    Color fcolor = Get.isDarkMode ? Colors.white : Colors.black;
    return Scaffold(
      appBar: AppBar(
        leading: Container(),
        title: Text(title),
        elevation: 0,
        centerTitle: true,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        foregroundColor: fcolor,
      ),
      body: SingleChildScrollView(
        child: body,
      ),
    );
  }
}

class XListTile extends StatelessWidget {
  const XListTile({
    Key? key,
    required this.icon,
    required this.title,
    required this.intro,
    required this.buttonText,
    required this.onTap,
    this.focus = false,
  }) : super(key: key);

  final IconData icon;
  final String title;
  final String intro;
  final String buttonText;
  final Function? onTap;
  final bool focus;

  @override
  Widget build(BuildContext context) {
    Color bcolor = Get.isDarkMode ? Colors.black : Colors.white;
    Color fcolor = Get.isDarkMode ? Colors.white : Colors.black;
    return GestureDetector(
      onTap: () {
        onTap!();
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        decoration: BoxDecoration(
          color: bcolor.withOpacity(.7),
          borderRadius: const BorderRadius.all(Radius.circular(16)),
          border: focus
              ? Border.all(width: 2, color: Theme.of(context).primaryColor)
              : Border.all(color: fcolor.withOpacity(.07)),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                color: fcolor.withOpacity(.1),
                borderRadius: const BorderRadius.all(
                  Radius.circular(10),
                ),
              ),
              height: 42,
              width: 42,
              margin: const EdgeInsets.only(right: 12),
              child: Center(
                child: Icon(
                  icon,
                  size: 24,
                  color: fcolor.withOpacity(.7),
                ),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: 19,
                      fontWeight: FontWeight.bold,
                      color: fcolor,
                    ),
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width - 140,
                  child: Text(
                    intro,
                    style: const TextStyle(color: Colors.grey),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width - 113,
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: ElevatedButton(
                      child: Text(buttonText),
                      onPressed: () {
                        onTap!();
                      },
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(
                            Theme.of(context).primaryColor.withOpacity(.1)),
                        foregroundColor: MaterialStateProperty.all(
                            Theme.of(context).primaryColor),
                        padding: MaterialStateProperty.all(
                          const EdgeInsets.symmetric(
                              vertical: 12, horizontal: 20),
                        ),
                        shape: MaterialStateProperty.all(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        elevation: MaterialStateProperty.all(0),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
