import 'package:aurasounds/model/youtube.dart';
import 'package:get/get.dart';

class YoutubeController extends GetxController {
  RxList headerList = [].obs;
  RxList bodyList = [].obs;

  @override
  void onInit() {
    super.onInit();
    YouTubeServices().getMusicHome().then((value) {
      headerList.value = value['head'] ?? [];
      bodyList.value = value['body'] ?? [];

    });
  }
}
