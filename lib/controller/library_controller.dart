import 'package:aurasounds/model/database.dart';
import 'package:aurasounds/model/type.dart';
import 'package:get/get.dart';
import 'package:just_audio_background/just_audio_background.dart';

class LibraryController extends GetxController {
  final DBModel _db = DBModel();

  RxList<MediaItem> allSongs = <MediaItem>[].obs;
  RxList<MediaItem> recentlyPlayedSongs = <MediaItem>[].obs;
  RxList<MediaItem> mostlyPlayedSongs = <MediaItem>[].obs;
  RxList<MediaItem> favouriteSongs = <MediaItem>[].obs;
  RxList<MediaItem> radioStations = <MediaItem>[].obs;
  RxList<MediaItem> searchResults = <MediaItem>[].obs;

  RxList<FolderModel> folderList = <FolderModel>[].obs;
  RxList<MediaItem> folderSongs = <MediaItem>[].obs;

  RxList<XAlbumModel> albumList = <XAlbumModel>[].obs;
  RxList<MediaItem> albumSongs = <MediaItem>[].obs;

  RxList<XArtistModel> artistList = <XArtistModel>[].obs;
  RxList<MediaItem> artistSongs = <MediaItem>[].obs;

  RxString sortType = 'date_added'.obs;
  RxString sortOrderType = 'DESC'.obs;

  RxMap dirtyList = {
    'allSongs': false,
    'recentlyPlayedSongs': false,
    'mostlyPlayedSongs': false,
    'favouriteSongs': false,
    'folderSongs': false,
    'albumSongs': false,
    'artistSongs': false,
    'searchResults': false,
  }.obs;

  @override
  void onInit() {
    super.onInit();
    initSongs();
    listenSort();
  }

  void initSongs() {
    initGetAllSongs();
    initGetAllFolders();
    initGetAllAlbums();
    initGetAllArtists();
    initGetRecentlyPlayedSongs();
    initGetMostlyPlayedSongs();
    initGetFavSongs();
    initGetRadioStations();
  }

  void listenSort() {
    sortType.listen((p0) {
      initGetAllSongs();
    });
    sortOrderType.listen((p0) {
      initGetAllSongs();
    });
  }

  Future<void> toggleFavourite(int id) async {
    Map? _fav = await _db.getFavourite(id);
    await _db.setFavourite(id, _fav!['favourite'] == 1 ? 0 : 1);
    initGetAllSongs();
    initGetFavSongs();
    initGetRecentlyPlayedSongs();
    initGetMostlyPlayedSongs();
  }

  Future<void> initGetAllSongs() async {
    allSongs.value = await _db.getAllSongs(
      sortType.value,
      sortOrderType.value,
    );
    dirtyList.value['allSongs'] = true;
  }

  Future<void> initGetFolderSongs(String uri) async {
    folderSongs.value = await _db.getFolderSongs(
      uri,
      sortType.value,
      sortOrderType.value,
    );
    dirtyList.value['folderSongs'] = true;
  }

  Future<void> initGetAlbumSongs(String uri) async {
    albumSongs.value = await _db.getAlbumSongs(
      uri,
      sortType.value,
      sortOrderType.value,
    );
    dirtyList.value['albumSongs'] = true;
  }

  Future<void> initGetArtistSongs(String uri) async {
    artistSongs.value = await _db.getArtistSongs(
      uri,
      sortType.value,
      sortOrderType.value,
    );
    dirtyList.value['artistSongs'] = true;
  }

  Future<List<MediaItem>> initGetRecentlyPlayedSongs() async {
    recentlyPlayedSongs.value = await _db.getRecentlyPlayedSongs();
    dirtyList.value['recentlyPlayedSongs'] = true;
    return recentlyPlayedSongs.value;
  }

  Future<List<MediaItem>> initGetRadioStations() async {
    radioStations.value = await _db.getRadioStations();
    return radioStations.value;
  }

  Future<List<MediaItem>> initGetMostlyPlayedSongs() async {
    mostlyPlayedSongs.value = await _db.getMostlyPlayedSongs();
    dirtyList.value['mostlyPlayedSongs'] = true;
    return mostlyPlayedSongs.value;
  }

  Future<List<MediaItem>> initGetFavSongs() async {
    favouriteSongs.value = await _db.getFavouriteSongs();
    dirtyList.value['favouriteSongs'] = true;
    return favouriteSongs.value;
  }

  Future<void> searchSongs(String q) async {
    if (q.isEmpty) {
      searchResults.value = [];
    } else {
      searchResults.value = await _db.searchSongs(q);
    }
  }

  Future<void> initGetAllFolders() async {
    folderList.value = await _db.getAllSongFolders();
  }

  Future<void> initGetAllAlbums() async {
    albumList.value = await _db.getAllSongAlbums();
  }

  Future<void> initGetAllArtists() async {
    artistList.value = await _db.getAllSongArtists();
  }
}
