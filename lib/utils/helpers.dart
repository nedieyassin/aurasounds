import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';
import 'package:get/get.dart';

formatDuration(Duration d) {
  String hours = d.inHours.toString().padLeft(0, '2');
  String minutes = d.inMinutes.remainder(60).toString().padLeft(2, '0');
  String seconds = d.inSeconds.remainder(60).toString().padLeft(2, '0');
  if (int.parse(hours) == 0) {
    return "$minutes:$seconds";
  } else {
    return "$hours:$minutes:$seconds";
  }
}

class CustomPhysics extends ScrollPhysics {
  const CustomPhysics({ScrollPhysics? parent}) : super(parent: parent);

  @override
  CustomPhysics applyTo(ScrollPhysics? ancestor) {
    return CustomPhysics(parent: buildParent(ancestor));
  }

  @override
  SpringDescription get spring => const SpringDescription(
        mass: 150,
        stiffness: 100,
        damping: 1,
      );
}

String getThemedAsset(String path) {
  final String pre = Get.isDarkMode ? 'dark-' : 'light-';
  return '$pre$path';
}
