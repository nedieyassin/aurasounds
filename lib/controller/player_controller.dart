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
  RxList<SongModel> folderSongList = <SongModel>[].obs;
  RxList<SongModel> recentlyPlayedSongList = <SongModel>[].obs;
  RxList<FolderModel> folderList = <FolderModel>[].obs;

  RxInt noOfAllSongs = 0.obs;
  RxInt noOfAllFolders = 0.obs;
  RxInt noOfFolderSongs = 0.obs;
  RxInt noOfRecentlyPlayedSongs = 0.obs;
  RxInt noOfFavSongs = 0.obs;

  Rx<AudioPlayer> player = AudioPlayer().obs;
  RxInt getCurrentAudioIndex = 0.obs;
  RxInt getCurrentAudioId = 0.obs;

  RxString getCurrentPlaylistValue = ''.obs;

  RxString getCurrentFolderText = ''.obs;
  RxString getCurrentFolderValue = ''.obs;
  RxBool isInFolder = false.obs;

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

  RxString sortValue = 'date_added.DESC'.obs;

  // RxString tabValue = 'allsongs'.obs;

  RxString id = ''.obs;
  RxString title = ''.obs;
  RxString artist = ''.obs;
  RxString album = ''.obs;
  Rx<Duration> duration = const Duration(milliseconds: 0).obs;

  String getMeta(String meta) {
    return meta.isNotEmpty ? meta : '<unknown>';
  }

  SongModel getAudio(int index) {
    return songList[index];
  }
  SongModel getRecentlyPlayedAudio(int index) {
    return recentlyPlayedSongList[index];
  }

  SongModel getFolderAudio(int index) {
    return folderSongList[index];
  }

  FolderModel getFolder(int index) {
    return folderList[index];
  }

  List<SongModel> getAudios() {
    return songList;
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

  void setSortOrder(String sort) {
    sortValue.value = sort;
    getCurrentPlaylistValue.value = '';
    _initGetAllSongs();
  }

  void setFolder(String text, String value) {
    getCurrentFolderText.value = text;
    getCurrentFolderValue.value = value;
    isInFolder.value = true;
    _initGetFolderSongs();
  }

  void resetFolder() {
    isInFolder.value = false;
    getCurrentFolderText.value = '';
    getCurrentFolderValue.value = '';
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
    _initGetAllSongs(open: false);
    _initGetAllFolders();
    _initGetRecentlyPlayedSongs();
    _listenForChangesInSequenceState();
    player.value.currentIndexStream.listen((event) {
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

  Future<void> _initGetAllSongs({open = false}) async {
    noOfAllSongs.value = 0;
    songList.value = await _db.getAllSongs(
      sortValue.value.split('.').first,
      sortValue.value.split('.').last,
    );
    noOfAllSongs.value = songList.value.length;

    if (open) {
      openPlaylist(songList.value);
    }
  }

  Future<void> _initGetFolderSongs() async {
    noOfFolderSongs.value = 0;
    folderSongList.value =
        await _db.getFolderSongs(getCurrentFolderValue.value);
    noOfFolderSongs.value = folderSongList.value.length;
  }

  Future<void> _initGetRecentlyPlayedSongs() async {
    noOfRecentlyPlayedSongs.value = 0;
    recentlyPlayedSongList.value = await _db.getRecentlyPlayedSongs();
    noOfRecentlyPlayedSongs.value = recentlyPlayedSongList.value.length;
  }

  Future<void> _initGetAllFolders() async {
    noOfAllFolders.value = 0;
    if (folderList.value.isEmpty) {
      folderList.value = await _db.getAllSongFolders();
    }
    noOfAllFolders.value = folderList.value.length;
  }

  Future<void> openPlaylist(List<SongModel> playlist) async {
    await player.value.setAudioSource(
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

  Future<void> startPlaylist({position = 0, required String playlist}) async {
    if (getCurrentPlaylistValue.value != playlist) {
      if (playlist == 'allsongs') {
        player.value.pause();
        await openPlaylist(songList);
        getCurrentPlaylistValue.value = playlist;
      } else if (playlist.contains('foldersongs')) {
        await openPlaylist(folderSongList);
        getCurrentPlaylistValue.value = playlist;
      }
    }
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
