import 'package:aurasounds/model/youtube.dart';
import 'package:get/get.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

class YoutubeController extends GetxController {

  RxList headerList = [].obs;
  RxList bodyList = [].obs;
  RxList<Video> chartSongs = <Video>[].obs;
  RxBool searchQuery = false.obs;

  RxBool isLoadingStream = false.obs;

  @override
  void onInit() {
    super.onInit();
    YouTubeServices().getMusicHome().then((value) {
      headerList.value = value['head'] ?? [];
      bodyList.value = value['body'] ?? [];
    });
  }

  Future<bool> getPlaylistSongs(String id) async {
    chartSongs.value = await YouTubeServices().getPlaylistSongs(id);
    return true;
  }
}
