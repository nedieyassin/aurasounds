import 'dart:typed_data';
import 'package:aurasounds/model/database.dart';
import 'package:aurasounds/model/lyrics.dart';
import 'package:aurasounds/utils/helpers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:flutter/services.dart' show rootBundle;

class PlayerController extends GetxController {
  final OnAudioQuery _audioQuery = OnAudioQuery();
  final DBModel _db = DBModel();
  Rx<AudioPlayer> player = AudioPlayer().obs;

  RxList<int> currentQueueList = <int>[].obs;
  RxInt getCurrentAudioIndex = 1000000.obs;
  RxString getCurrentAudioId = ''.obs;
  Rx<String> getArtUrl = ''.obs;
  RxString getCurrentPlaylistValue = ''.obs;

  RxString getLyricsValue = ''.obs;
  RxBool openLyrics = false.obs;
  RxBool lyricsLoading = false.obs;
  RxBool programmeLoading = false.obs;

  Rx<Uint8List> artByteArray = Uint8List(0).obs;
  RxBool hasArtByteArray = false.obs;
  RxInt repeatOne = 0.obs;
  RxBool shuffle = false.obs;
  RxBool hasCurrent = false.obs;
  RxBool isFavourite = true.obs;
  RxBool isRadio = false.obs;
  RxBool isYoutube = false.obs;
  RxString radioAlias = ''.obs;

  RxString id = ''.obs;
  RxString title = ''.obs;
  RxString artist = ''.obs;
  RxString album = ''.obs;
  Rx<Duration> duration = const Duration(milliseconds: 0).obs;

  String getMeta(String meta) {
    return meta.isNotEmpty ? meta : '<unknown>';
  }

  MediaItem getQueueAudio(int index) {
    return player.value.sequence![index].tag as MediaItem;
  }

  getArtByteArray() async {
    if (!isRadio.value && !isYoutube.value) {
      Uint8List? _artByteArray = await _audioQuery.queryArtwork(
        int.parse(getCurrentAudioId.value),
        ArtworkType.AUDIO,
      );
      if (_artByteArray != null && _artByteArray.isNotEmpty) {
        artByteArray.value = _artByteArray;
      } else {
        ByteData bytes =
            await rootBundle.load('lib/assets/${getThemedAsset('cover.png')}');
        artByteArray.value = bytes.buffer.asUint8List();
      }
    } else {
      ByteData bytes =
          await rootBundle.load('lib/assets/${getThemedAsset('cover.png')}');
      artByteArray.value = bytes.buffer.asUint8List();
    }
  }

  void toggleMiniLyrics() {
    openLyrics.value = !openLyrics.value;
    if (openLyrics.value) {
      getLyrics();
    }
  }

  Future<void> getLyrics() async {
    lyricsLoading.value = true;
    Lyrics.getLyrics(title: title.value, artist: artist.value).then((value) {
      getLyricsValue.value = value;
      lyricsLoading.value = false;
    });
  }

  Future<void> getRadioProgramme() async {
    programmeLoading.value = true;
    Lyrics.radioProgramme(radioAlias.value).then((value) {
      if (value.isNotEmpty) {
        Get.snackbar(
          'Message',
          value,
          margin: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
          duration: const Duration(seconds: 4),
          isDismissible: true,
          icon: const Icon(
            Icons.message,
            color: Colors.blue,
          ),
        );
      } else {
        Get.snackbar(
          'Alert',
          'Currently unable to get what\'s on Air ',
          margin: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
          duration: const Duration(seconds: 2),
          isDismissible: true,
          icon: const Icon(
            Icons.warning,
            color: Colors.red,
          ),
        );
      }
      programmeLoading.value = false;
    });
  }

  void _listenForChangesInSequenceState() {
    player.value.sequenceStateStream.listen((sequenceState) {
      if (sequenceState == null) {
        hasCurrent.value = false;
        return;
      }
      if (sequenceState.currentSource == null) {
        hasCurrent.value = false;
        return;
      }

      MediaItem meta = sequenceState.currentSource!.tag as MediaItem;
      id.value = meta.id;
      getCurrentAudioId.value = meta.id;
      getArtUrl.value = meta.artUri.toString();
      title.value = meta.title;
      artist.value = meta.artist ?? '';
      album.value = meta.album!;
      duration.value = meta.duration!;
      isRadio.value = meta.extras!['is_radio'] ?? false;
      isYoutube.value = meta.extras!['is_youtube'] ?? false;
      radioAlias.value = meta.extras!['alias'] ?? '';

      if (openLyrics.value) {
        getLyrics();
      }
    });
    player.value.playbackEventStream.listen((event) {
      if (event.currentIndex != null) {
        hasCurrent.value = true;
      } else {
        hasCurrent.value = false;
      }
    });

    player.value.processingStateStream.listen((event) {
      if (event == ProcessingState.ready) {
        updateCurrentAudioId();
        _updateFavourite();
        _updatePlayCount();
      }
    });

    player.value.shuffleModeEnabledStream.listen((event) {
      _shuffledIndices();
    });
  }

  @override
  void onInit() {
    super.onInit();
    _listenForChangesInSequenceState();
  }

  Future<void> toggleShuffle({shuffle = false}) async {
    if (shuffle) {
      if (shuffle) {
        await player.value.shuffle();
      }
      await player.value.setShuffleModeEnabled(shuffle);
    } else {
      final enable = !player.value.shuffleModeEnabled;
      if (enable) {
        await player.value.shuffle();
      }
      await player.value.setShuffleModeEnabled(enable);
    }
  }

  Future<void> toggleFavourite() async {
    await _db.setFavourite(
        int.parse(getCurrentAudioId.value), isFavourite.value ? 0 : 1);
    await _updateFavourite();
  }

  Future<void> _updatePlayCount() async {
    if (!hasCurrent.value) return;
    if (isRadio.value) return;
    if (isYoutube.value) return;
    if (getCurrentPlaylistValue.value == 'radio') return;
    if (getCurrentPlaylistValue.value == 'youtube') return;
    int nowId = int.parse(getCurrentAudioId.value);
    Future.delayed(
      Duration(
        milliseconds: (duration.value.inMilliseconds * 0.2).floor(),
      ),
    );
    if (nowId == getCurrentAudioId.value) {
      await _db.setPlayCount(int.parse(getCurrentAudioId.value));
    }
  }

  void toggleRepeatOne() {
    LoopMode loopMode = LoopMode.off;
    if (player.value.loopMode == LoopMode.off) {
      loopMode = LoopMode.all;
    } else if (player.value.loopMode == LoopMode.all) {
      loopMode = LoopMode.one;
    } else if (player.value.loopMode == LoopMode.one) {
      loopMode = LoopMode.off;
    }
    player.value.setLoopMode(loopMode);
  }

  void updateCurrentAudioId() {
    if (player.value.sequenceState == null) return;
    if (player.value.sequenceState!.currentSource == null) return;
    getCurrentAudioId.value = player.value.sequenceState!.currentSource!.tag.id;
    getArtByteArray();
  }

  Future<void> _updateFavourite() async {
    if (isRadio.value || isYoutube.value) return;
    Map? _fav = await _db.getFavourite(int.parse(getCurrentAudioId.value));
    if (_fav == null) {
      isFavourite.value = false;
      return;
    }
    isFavourite.value = _fav['favourite'] == 1 ? true : false;
  }

  Future<void> _shuffledIndices() async {
    var _indices = player.value.shuffleIndices ?? [];
    var _default = List.generate(_indices.length, (index) => index);
    final enable = player.value.shuffleModeEnabled;
    if (enable) {
      currentQueueList.value = _indices;
    } else {
      currentQueueList.value = _default;
    }
  }

  Future<void> openPlaylist(List<MediaItem> music) async {
    await player.value.setAudioSource(
      ConcatenatingAudioSource(
        useLazyPreparation: true,
        children: music.map(
          (MediaItem audio) {
            if (audio.extras!['is_radio'] != null &&
                audio.extras!['is_radio'] as bool) {
              return AudioSource.uri(
                Uri.parse(audio.extras!['uri']),
                tag: audio,
              );
            } else if (audio.extras!['is_youtube'] != null &&
                audio.extras!['is_youtube'] as bool) {
              return AudioSource.uri(
                Uri.parse(audio.extras!['uri']),
                tag: audio,
              );
            } else {
              return AudioSource.uri(
                Uri.parse(audio.extras!['uri']),
                tag: audio.copyWith(
                  artUri: Uri.file(audio.extras!['art_path']),
                ),
              );
            }
          },
        ).toList(),
      ),
    );
    await _shuffledIndices();
  }

  Future<void> startPlaylist({
    required String playlist,
    required List<MediaItem> music,
    falseOpen = false,
    position = 0,
    shuffle = false,
  }) async {
    if (music.isNotEmpty) {
      if (getCurrentPlaylistValue.value != playlist || falseOpen) {
        await openPlaylist(music);
        getCurrentPlaylistValue.value = playlist;
      }
      if (shuffle) {
        toggleShuffle(
          shuffle: shuffle,
        );
      }

      await player.value.seek(const Duration(seconds: 0), index: position);
      await player.value.play();
      getCurrentAudioIndex.value = position;

      if (playlist != 'radio') {
        _updatePlayCount();
      }
    }
  }

  Future<void> playQueueAt({position = 0}) async {
    await player.value.seek(const Duration(seconds: 0), index: position);
    player.value.play();
    getCurrentAudioIndex.value = position;
  }

  Future<void> play() async {
    if (!player.value.playing) {
      player.value.play();
    } else {
      player.value.pause();
    }
  }

  @override
  void dispose() {
    player.value.dispose();
    super.dispose();
  }
}
