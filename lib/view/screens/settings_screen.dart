import 'package:aurasounds/utils/constants.dart';
import 'package:aurasounds/view/components/settings/about.dart';
import 'package:aurasounds/view/components/settings/change_theme.dart';
import 'package:aurasounds/view/components/settings/developers.dart';
import 'package:aurasounds/view/components/settings/terms.dart';
import 'package:aurasounds/view/components/settings/update_library.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color fcolor = Get.isDarkMode ? Colors.white : Colors.black;
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 12,
                      right: 12,
                      top: 26,
                    ),
                    child: IconButton(
                      onPressed: () => Get.back(),
                      icon: const Icon(Icons.arrow_back),
                    ),
                  ),
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
                ],
              ),
              const SizedBox(
                height: 30,
              ),
              SettingsListTile(
                icon: Icons.queue_music_rounded,
                title: 'Update Song Library',
                intro: 'Load new songs into aurasounds\'s song database',
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
              SettingsListTile(
                icon: Icons.color_lens_rounded,
                title: 'Change Accent Colour',
                intro: 'Customise aurasounds to look as you wish',
                onTap: () {
                  Get.to(
                    () => XBottomSheet(
                      title: 'Change Accent Colour',
                      body: ChangeTheme(),
                    ),
                  );
                },
              ),
              const Divider(indent: 70,endIndent: 20,),
              SettingsListTile(
                icon: Icons.info_outline_rounded,
                title: 'About aurasounds',
                intro:
                    'Aurasounds is a feature rich music player made by music lover for music lovers.',
                onTap: () {
                  Get.to(
                    () => const XBottomSheet(
                      title: 'About aurasounds',
                      body: AboutScreen(),
                    ),
                  );
                },
              ),
              SettingsListTile(
                icon: Icons.business,
                title: 'Developers',
                intro: 'This app is developed and maintained by strollec',
                onTap: () {
                  Get.to(
                    () => const XBottomSheet(
                      title: 'Developers',
                      body: Developers(),
                    ),
                  );
                },
              ),
              SettingsListTile(
                icon: Icons.grid_view_rounded,
                title: 'Terms of Use',
                intro:
                    'The app is copyrighted to its developers, it should not be sold or cloned',
                onTap: () {
                  Get.to(
                    () => const XBottomSheet(
                      title: 'Terms of Use',
                      body: TermsScreen(),
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

class SettingsListTile extends StatelessWidget {
  const SettingsListTile({
    Key? key,
    required this.icon,
    required this.title,
    required this.intro,
    required this.onTap,
    this.focus = false,
  }) : super(key: key);

  final IconData icon;
  final String title;
  final String intro;
  final Function? onTap;
  final bool focus;

  @override
  Widget build(BuildContext context) {
    Color bcolor = Get.isDarkMode ? Colors.black : Colors.white;
    Color fcolor = Get.isDarkMode ? Colors.white : Colors.black;
    return ListTile(
      onTap: () => onTap!(),
      leading: Icon(icon),
      title: Text(title),
      subtitle: Text(intro),
      trailing: const Icon(Icons.arrow_forward),
    );
  }
}
