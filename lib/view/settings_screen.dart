import 'package:aurasounds/utils/constants.dart';
import 'package:aurasounds/view/components/change_theme.dart';
import 'package:aurasounds/view/components/update_library.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
                    color: Colors.grey.shade600, fontFamily: 'Cust'),
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            XListTile(
              icon: EvaIcons.loaderOutline,
              title: 'Update Song Library',
              intro: 'Load new songs into aurasounds\'s song database',
              buttonText: 'Update Library',
              onTap: () {
                Get.bottomSheet( XBottomSheet(
                  title: 'Update Song Library',
                  body: UpdateLibrary(),
                ));

              },
              focus: true,
            ),
            XListTile(
              icon: EvaIcons.colorPaletteOutline,
              title: 'Change Accent Colour',
              intro: 'Customise aurasounds to look as you wish',
              buttonText: 'Change Theme',
              onTap: () {
                Get.bottomSheet(XBottomSheet(
                  title: 'Change Accent Coluor',
                  body: ChangeTheme(),
                ));
              },
            ),
            XListTile(
              icon: EvaIcons.gridOutline,
              title: 'Terms of Use',
              intro:
                  'The app is copyrighted to its developers, it should not be sold or cloned',
              buttonText: 'See more',
              onTap: () {},
            ),
            XListTile(
              icon: EvaIcons.infoOutline,
              title: 'About aurasounds',
              intro:
                  'Aurasounds is a feature rich music player made by music lover for music lovers.',
              buttonText: 'See more',
              onTap: () {},
            ),
            XListTile(
              icon: EvaIcons.personOutline,
              title: 'Developers',
              intro: 'This app is developed and maintained by Yassin Nedie',
              buttonText: 'View Details',
              onTap: () {},
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
    return Container(
      decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(14))),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Center(
              child: Text(
                title,
                style: xtitle,
              ),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: body,
            ),
          )
        ],
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
    return GestureDetector(
      onTap: () {},
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.all(Radius.circular(16)),
            border: focus
                ? Border.all(width: 2, color: Theme.of(context).primaryColor)
                : Border.all(color: Colors.grey.shade200)),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
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
                  color: Colors.black87,
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
                    style: const TextStyle(
                      fontSize: 19,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
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
