import 'dart:typed_data';
import 'package:aurasounds/model/database.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:on_audio_query/on_audio_query.dart';

class PlayerController extends GetxController {
  final OnAudioQuery _audioQuery = OnAudioQuery();
  final DBModel _db = DBModel();
  RxList<SongModel> songList = <SongModel>[].obs;
  RxInt noOfSongs = 0.obs;
  Rx<AudioPlayer> player = AudioPlayer().obs;
  RxInt getCurrentAudioIndex = 0.obs;
  RxInt getCurrentAudioId = 0.obs;

  RxString getCurrentTabText = 'All Songs'.obs;
  RxString getCurrentTabValue = 'allsongs'.obs;

  Rx<Uint8List> artByteArray = Uint8List(0).obs;
  RxBool hasArtByteArray = false.obs;
  RxInt repeatOne = 0.obs;
  RxBool shuffle = false.obs;
  RxBool hasCurrent = false.obs;

  final RxList<Map> sortType = [
    {
      'label': 'Date Added - Desc',
      'value': 'date_added.DESC',
    },
    {
      'label': 'Date Added - Asc',
      'value': 'date_added.ASC',
    },
    {
      'label': 'Title - Desc',
      'value': 'title.DESC',
    },
    {
      'label': 'Title - Asc',
      'value': 'title.ASC',
    },
    {
      'label': 'Artist - Desc',
      'value': 'artist.DESC',
    },
    {
      'label': 'Artist - Asc',
      'value': 'artist.ASC',
    },
  ].obs;

  final List<Map<String, String>> tabType = [
    {
      'label': 'All Songs',
      'value': 'allsongs',
    },
    {
      'label': 'Folders',
      'value': 'folders',
    },
    {
      'label': 'Favourites',
      'value': 'favourites',
    },
    {
      'label': 'Recently Played',
      'value': 'recentlyplayed',
    },
    {
      'label': 'Mostly Played',
      'value': 'mostlyplayed',
    },
  ];

  RxString sortValue = 'date_added.DESC'.obs;
  RxString tabValue = 'allsongs'.obs;

  RxString id = ''.obs;
  RxString title = ''.obs;
  RxString artist = ''.obs;
  RxString album = ''.obs;
  Rx<Duration> duration = const Duration(milliseconds: 0).obs;

  String getMeta(String meta) {
    return meta.isNotEmpty ? meta : '<unknown>';
  }

  void getTab(String value) {
    for (Map<String, String> el in tabType) {
      if (el['value'] == value) {

        getCurrentTabText.value = el['label'] ?? 'All Songs';
        getCurrentTabValue.value = el['value'] ?? 'allsongs';

        print(getCurrentTabText.value);

        break;
      }
    }
  }

  void setSortOrder(String sort) {
    sortValue.value = sort;
    getPlaylist();
  }

  void setTab(String tab) {
    getTab(tab);
    tabValue.value = tab;
  }

  getArtByteArray() async {
    Uint8List? _artByteArray = await _audioQuery.queryArtwork(
      getCurrentAudioId.value,
      ArtworkType.AUDIO,
    );

    if (_artByteArray!.isNotEmpty) {
      artByteArray.value = _artByteArray;
      hasArtByteArray.value = true;
    } else {
      hasArtByteArray.value = false;
    }
  }

  void _listenForChangesInSequenceState() {
    player.value.sequenceStateStream.listen((sequenceState) {
      if (sequenceState == null) return;
      MediaItem meta = sequenceState.currentSource!.tag as MediaItem;
      id.value = meta.id;
      getCurrentAudioId.value = int.parse(meta.id);
      title.value = meta.title;
      artist.value = meta.artist!;
      album.value = meta.album!;
      duration.value = meta.duration!;
    });

    player.value.playbackEventStream.listen((event) {
      if (event.currentIndex != null) {
        hasCurrent.value = true;
      } else {
        hasCurrent.value = false;
      }
    });
  }

  @override
  void onInit() {
    super.onInit();
    getPlaylist();
    _listenForChangesInSequenceState();
    player.value.currentIndexStream.listen((event) {
      //print(event);
      updateCurrentAudioId();
    });
  }

  Future<void> toggleShuffle() async {
    final enable = !player.value.shuffleModeEnabled;
    if (enable) {
      player.value.shuffle();
    }
    player.value.setShuffleModeEnabled(enable);
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
    getCurrentAudioId.value =
        int.parse(player.value.sequenceState!.currentSource!.tag.id);
    getArtByteArray();
  }

  SongModel getAudio(int index) {
    return songList[index];
  }

  List<SongModel> getAudios() {
    return songList;
  }

  Future<void> getPlaylist() async {
    noOfSongs.value = 0;
    openPlaylist([]);
    songList.value = await _db.getAllSongs(
        sortValue.value.split('.').first, sortValue.value.split('.').last);
    noOfSongs.value = songList.value.length;
    await openPlaylist(songList.value);
    updateCurrentAudioId();
  }

  Future<void> openPlaylist(List<SongModel> playlist) async {
    player.value.setAudioSource(
      ConcatenatingAudioSource(
        useLazyPreparation: true,
        children: playlist
            .map(
              (SongModel audio) => AudioSource.uri(
                Uri.parse(audio.uri!),
                tag: MediaItem(
                    id: audio.id.toString(),
                    title: audio.title,
                    artist: audio.artist,
                    album: audio.album,
                    duration: Duration(milliseconds: audio.duration ?? 0),
                    genre: audio.genre),
              ),
            )
            .toList(),
      ),
    );
  }

  Future<void> startPlaylist({position = 0}) async {
    await player.value.seek(const Duration(seconds: 0), index: position);
    player.value.play();
    getCurrentAudioIndex.value = position;
  }

  void play() {
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
