import 'package:aurasounds/utils/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeSectionHead extends StatelessWidget {
  const HomeSectionHead({
    Key? key,
    required this.title,
    this.onMore,
  }) : super(key: key);

  final String title;
  final Function? onMore;

  @override
  Widget build(BuildContext context) {
    Color fcolor = Get.isDarkMode ? Colors.white : Colors.black;
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20, top: 30),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            title,
            style: xtitle.copyWith(color: fcolor.withOpacity(.7), fontSize: 18),
          ),
          onMore != null
              ? ElevatedButton(
                  child: const Text(
                    'More',
                  ),
                  onPressed: () {
                    if (onMore != null) {
                      onMore!();
                    }
                  },
                  style: buildButtonStyle(),
                )
              : const SizedBox(height: 30,)
        ],
      ),
    );
  }
}

ButtonStyle buildButtonStyle() {
  Color fcolor = Get.isDarkMode ? Colors.white : Colors.black;
  return ButtonStyle(
    backgroundColor: MaterialStateProperty.all(
      fcolor.withOpacity(0.03),
    ),
    foregroundColor: MaterialStateProperty.all(fcolor),
    padding: MaterialStateProperty.all(
      const EdgeInsets.symmetric(horizontal: 26, vertical: 2),
    ),
    shape: MaterialStateProperty.all(
      RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(99),
      ),
    ),
    elevation: MaterialStateProperty.all(0),
  );
}
