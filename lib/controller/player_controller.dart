import 'package:aurasounds/model/audio.dart';
import 'package:get/get.dart';
import 'package:assets_audio_player/assets_audio_player.dart';

class PlayerController extends GetxController {
  final player = AssetsAudioPlayer().obs;
  var getCurrentAudioIndex = 0.obs;
  var getCurrentAudioId = 0.obs;
  var repeatOne = false.obs;
  var shuffle = false.obs;

  String getMeta(String meta) {
    return meta.isNotEmpty ? meta : '<unknown>';
  }

  @override
  void onInit() {
    super.onInit();
    player.value.playerState.listen((event) {
      updateCurrentAudioId();
    });
  }

  void toggleShuffle() {
    player.value.toggleShuffle();
    shuffle.value = player.value.shuffle;
  }

  void toggleRepeatOne() {
    repeatOne.value = !repeatOne.value;
    print('repeat ${repeatOne.value}');
    player.value.setLoopMode(repeatOne.value ? LoopMode.single : LoopMode.playlist);
  }

  void updateCurrentAudioId() {
    if (player.value.current.hasValue) {
      getCurrentAudioId.value = player.value.getCurrentAudioextra['id'] as int;
    }
  }

  void startPlay(XAudio audio, {index = 0}) {
    player.value.open(
      Audio.file(
        audio.data!,
        metas: Metas(
            extra: {
              'duration': audio.duration,
            },
            title: audio.title,
            artist: audio.artist,
            album: audio.album,
            onImageLoadFail: const MetasImage.asset('lib/assets/art.jpg')),
      ),
      showNotification: true,
    );
    getCurrentAudioIndex.value = index;
  }

  void openPlaylist(List<XAudio> playlist) {
    player.value.open(
      Playlist(
        audios: playlist
            .map((XAudio audio) => Audio.file(
                  audio.data!,
                  metas: Metas(
                      extra: {
                        'duration': audio.duration,
                        'id': audio.id,
                      },
                      title: audio.title,
                      artist: audio.artist,
                      album: audio.album,
                      onImageLoadFail:
                          const MetasImage.asset('lib/assets/art.jpg')),
                ))
            .toList(),
      ),
      showNotification: true,
      autoStart: false,
    );
  }

  void startPlaylist(List<XAudio> playlist, {position = 0}) {
    if (player.value.playlist == null) {
      openPlaylist(playlist);
    }
    player.value.playlistPlayAtIndex(position);
    getCurrentAudioIndex.value = position;
  }

  void play() {
    player.value.playOrPause();
  }

  @override
  void dispose() {
    player.value.dispose();
    super.dispose();
  }
}
