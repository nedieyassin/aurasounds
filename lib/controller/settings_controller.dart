import 'package:aurasounds/model/native.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:on_audio_query/on_audio_query.dart';

class SettingsController extends GetxController {
  RxString syncProgress = ''.obs;

  Future<void> updateLibrary() async {
    await OnAudioQuery().permissionsRequest();
    getNativeSongs().listen((p) {
      syncProgress.value = p;
    }).onDone(() {
      syncProgress.value = '';
      Get.snackbar(
        'Alert',
        'Songs library updated!',
        margin: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
        icon: const Icon(
          Icons.message,
          color: Colors.blue,
        ),
      );
    });
  }
}
