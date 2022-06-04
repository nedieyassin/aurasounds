import 'package:aurasounds/model/audio.dart';
import 'package:aurasounds/model/channel.dart';
import 'package:get/get.dart';

class PlaylistController extends GetxController {
  var songList = <XAudio>[].obs;
  var noOfSongs = 0.obs;

  XAudio toObject(Map obj) {
    return XAudio(
      id: obj['id'],
      data: obj['data'],
      title: obj['title'],
      album: obj['album'],
      artist: obj['artist'],
      albumId: obj['albumId'],
      duration: obj['duration'],
      albumPathUri: obj['albumPathUri'],
    );
  }

  XAudio getAudio(int index) {
    return songList[index];
  }

  List<XAudio> getAudios() {
    return songList;
  }

  void getPlaylist() {
    nativeGetPlaylist().then((List list) {
      List<XAudio> _l = [];
      for (var audio in list) {
        _l.add(toObject(audio));
      }
      songList.value = _l;
      noOfSongs.value = _l.length;
    });
  }

  @override
  void onInit() {
    super.onInit();
    getPlaylist();
  }
}
