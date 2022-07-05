import 'dart:typed_data';
import 'package:aurasounds/model/database.dart';
import 'package:aurasounds/model/lyrics.dart';
import 'package:aurasounds/view/components/no_songs.dart';
import 'package:aurasounds/view/settings_screen.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:on_audio_query/on_audio_query.dart';

class PlayerController extends GetxController {
  final OnAudioQuery _audioQuery = OnAudioQuery();
  final DBModel _db = DBModel();
  RxList<MediaItem> songList = <MediaItem>[].obs;
  RxList<MediaItem> folderSongList = <MediaItem>[].obs;
  RxList<MediaItem> recentlyPlayedSongList = <MediaItem>[].obs;
  RxList<MediaItem> mostlyPlayedSongList = <MediaItem>[].obs;
  RxList<MediaItem> favSongList = <MediaItem>[].obs;
  RxList<MediaItem> searchSongList = <MediaItem>[].obs;
  RxList<int> currentQueueList = <int>[].obs;
  RxList<FolderModel> folderList = <FolderModel>[].obs;

  RxInt noOfAllSongs = 0.obs;
  RxInt noOfAllFolders = 0.obs;
  RxInt noOfFolderSongs = 0.obs;
  RxInt noOfSearchSongs = 0.obs;
  RxInt noOfRecentlyPlayedSongs = 0.obs;
  RxInt noOfMostlyPlayedSongs = 0.obs;
  RxInt noOfFavSongs = 0.obs;

  Rx<AudioPlayer> player = AudioPlayer().obs;
  RxInt getCurrentAudioIndex = 0.obs;
  RxInt getCurrentAudioId = 0.obs;

  RxString getCurrentPlaylistValue = ''.obs;
  RxString getCurrentSearchTextValue = ''.obs;

  RxString getCurrentFolderText = ''.obs;
  RxString getCurrentFolderValue = ''.obs;

  RxString getLyricsValue = ''.obs;
  RxBool openLyrics = false.obs;
  RxBool lyricsLoading = false.obs;

  Rx<Uint8List> artByteArray = Uint8List(0).obs;
  RxBool hasArtByteArray = false.obs;
  RxInt repeatOne = 0.obs;
  RxBool shuffle = false.obs;
  RxBool hasCurrent = false.obs;
  RxBool isFavourite = true.obs;

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

  MediaItem getAudio(int index) {
    return songList[index];
  }

  MediaItem getQueueAudio(int index) {
    return player.value.sequence![index].tag as MediaItem;
  }

  MediaItem getRecentlyPlayedAudio(int index) {
    return recentlyPlayedSongList[index];
  }

  MediaItem getMostlyPlayedAudio(int index) {
    return mostlyPlayedSongList[index];
  }

  MediaItem getSearchAudio(int index) {
    return searchSongList[index];
  }

  MediaItem getFavAudio(int index) {
    return favSongList[index];
  }

  MediaItem getFolderAudio(int index) {
    return folderSongList[index];
  }

  FolderModel getFolder(int index) {
    return folderList[index];
  }

  List<MediaItem> getAudios() {
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
    _initGetFolderSongs();
  }

  void setFolder(String text, String value) {
    getCurrentFolderText.value = text;
    getCurrentFolderValue.value = value;
    _initGetFolderSongs();
  }

  void resetFolder() {
    getCurrentFolderText.value = '';
    getCurrentFolderValue.value = '';
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
    // player.value.
  }

  @override
  void onInit() {
    super.onInit();
    initSongs();
    player.value.currentIndexStream.listen((event) {
      updateCurrentAudioId();
      _updateFavourite();
      _updatePlayCount();
    });

    player.value.shuffleModeEnabledStream.listen((event) {
      _shuffledIndices();
    });
  }

  void initSongs() {
    _initGetAllSongs(open: false);
    _initGetAllFolders();
    _initGetRecentlyPlayedSongs();
    _initGetMostlyPlayedSongs();
    _listenForChangesInSequenceState();
    _initGetFavSongs();
  }

  Future<void> toggleShuffle() async {
    final enable = !player.value.shuffleModeEnabled;
    if (enable) {
      await player.value.shuffle();
    }
    await player.value.setShuffleModeEnabled(enable);
  }

  Future<void> toggleFavourite() async {
    await _db.setFavourite(getCurrentAudioId.value, isFavourite.value ? 0 : 1);
    await _updateFavourite();
    _initGetFavSongs();
  }

  Future<void> _updatePlayCount() async {
    if (!hasCurrent.value) return;
    int nowId = getCurrentAudioId.value;
    Future.delayed(
      Duration(
        milliseconds: (duration.value.inMilliseconds * 0.2).floor(),
      ),
    );
    if (nowId == getCurrentAudioId.value) {
      await _db.setPlayCount(getCurrentAudioId.value);
      _initGetMostlyPlayedSongs();
      _initGetRecentlyPlayedSongs();
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
    if (songList.value.isEmpty) {
      Get.to(
        () => const FullPage(
          title: 'Scan for songs',
          body: NoSongs(),
        ),
      );
    }
    if (open) {
      openPlaylist(songList.value);
    }
  }

  Future<void> _updateFavourite() async {
    Map? _fav = await _db.getFavourite(getCurrentAudioId.value);
    if (_fav == null) {
      isFavourite.value = false;
      return;
    }
    isFavourite.value = _fav['favourite'] == 1 ? true : false;
  }

  Future<void> _initGetFolderSongs() async {
    if (getCurrentFolderValue.value.isEmpty) return;
    noOfFolderSongs.value = 0;
    folderSongList.value = await _db.getFolderSongs(
      getCurrentFolderValue.value,
      sortValue.value.split('.').first,
      sortValue.value.split('.').last,
    );
    noOfFolderSongs.value = folderSongList.value.length;
  }

  Future<void> _initGetRecentlyPlayedSongs() async {
    noOfRecentlyPlayedSongs.value = 0;
    recentlyPlayedSongList.value = await _db.getRecentlyPlayedSongs();
    noOfRecentlyPlayedSongs.value = recentlyPlayedSongList.value.length;
  }

  Future<void> _initGetMostlyPlayedSongs() async {
    noOfMostlyPlayedSongs.value = 0;
    mostlyPlayedSongList.value = await _db.getMostlyPlayedSongs();
    noOfMostlyPlayedSongs.value = mostlyPlayedSongList.value.length;
  }

  Future<void> _initGetFavSongs() async {
    noOfFavSongs.value = 0;
    favSongList.value = await _db.getFavouriteSongs();
    noOfFavSongs.value = favSongList.value.length;
  }

  Future<void> searchSongs(String q) async {
    noOfSearchSongs.value = 0;
    getCurrentSearchTextValue.value = q;
    if (q.isEmpty) return;
    getCurrentPlaylistValue.value = '';
    searchSongList.value = await _db.searchSongs(q);
    noOfSearchSongs.value = searchSongList.value.length;
  }

  Future<void> _initGetAllFolders() async {
    noOfAllFolders.value = 0;
    folderList.value = await _db.getAllSongFolders();
    noOfAllFolders.value = folderList.value.length;
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

  Future<void> openPlaylist(List<MediaItem> playlist) async {
    await player.value.setAudioSource(
      ConcatenatingAudioSource(
        useLazyPreparation: true,
        children: playlist
            .map(
              (MediaItem audio) => AudioSource.uri(
                Uri.parse(audio.extras!['uri']),
                tag: audio,
              ),
            )
            .toList(),
      ),
    );
    await _shuffledIndices();
  }

  Future<void> startPlaylist({position = 0, required String playlist}) async {
    if (getCurrentPlaylistValue.value != playlist) {
      if (playlist == 'allsongs') {
        await openPlaylist(songList);
        getCurrentPlaylistValue.value = playlist;
      } else if (playlist.contains('foldersongs')) {
        await openPlaylist(folderSongList);
        getCurrentPlaylistValue.value = playlist;
      } else if (playlist.contains('search')) {
        await openPlaylist(searchSongList);
        getCurrentPlaylistValue.value = playlist;
      } else if (playlist.contains('favourite')) {
        await openPlaylist(favSongList);
        getCurrentPlaylistValue.value = playlist;
      } else if (playlist.contains('recentplayed')) {
        await openPlaylist(recentlyPlayedSongList);
        getCurrentPlaylistValue.value = playlist;
      } else if (playlist.contains('mostplayed')) {
        await openPlaylist(mostlyPlayedSongList);
        getCurrentPlaylistValue.value = playlist;
      }
    }

    await player.value.seek(const Duration(seconds: 0), index: position);
    await player.value.play();
    getCurrentAudioIndex.value = position;
    _updatePlayCount();
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
