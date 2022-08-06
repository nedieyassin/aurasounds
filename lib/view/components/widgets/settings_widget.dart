import 'package:aurasounds/view/screens/settings_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SettingWidget extends StatelessWidget {
  const SettingWidget({
    Key? key,
  }) : super(key: key);

  void openSetting(BuildContext context) {
    Get.to(const SettingsScreen());
  }

  @override
  Widget build(BuildContext context) {
    Color fcolor = Get.isDarkMode ? Colors.white : Colors.black;
    return Container(
      // margin: const EdgeInsets.only(right: 10),
      child: ElevatedButton(
        child: const Icon(Icons.settings),
        onPressed: () {
          openSetting(context);
        },
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(fcolor.withOpacity(.1)),
          foregroundColor: MaterialStateProperty.all(fcolor.withOpacity(.7)),
          padding: MaterialStateProperty.all(
            const EdgeInsets.only(left: 10, bottom: 10, top: 10, right: 10),
          ),
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(99),
            ),
          ),
          elevation: MaterialStateProperty.all(0),
        ),
      ),
    );
  }
}
