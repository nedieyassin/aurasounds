import 'package:aurasounds/model/native.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class SettingsController extends GetxController {
  RxBool isLibrarySongs = false.obs;

  Future<void> updateLibrary() async {
    isLibrarySongs.value = true;
    await getNativeSongs();
    isLibrarySongs.value = false;
    Get.snackbar('Alert', 'Songs library updated!',
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.symmetric(vertical: 20, horizontal: 10));
  }
}
