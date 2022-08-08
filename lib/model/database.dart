import 'dart:io';
import 'dart:typed_data';
import 'package:aurasounds/model/type.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:flutter/services.dart' show rootBundle;

class DBModel {
  Future<Database> _initDB() async {
    String databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'audio.db');
    return await openDatabase(path, version: 1, onOpen: (Database db) async {
      await db.execute('''
   CREATE TABLE IF NOT EXISTS "music" (
	"id"	INTEGER UNIQUE,
	"audio_id"	INTEGER UNIQUE,
	"artist_id"	INTEGER,
	"album_id"	INTEGER,
	"data"	TEXT,
	"uri"	TEXT,
	"title"	TEXT,
	"artist"	TEXT,
	"album"	TEXT,
	"play_count"	INTEGER,
	"size"	INTEGER,
	"duration"	INTEGER,
	"folder_uri"	TEXT,
	"folder"	TEXT,
	"favourite"	INTEGER,
	"date_added"	INTEGER,
	"date_last_played"	INTEGER,
	"art_path"	TEXT,
	"lyrics"	TEXT,
	PRIMARY KEY("id" AUTOINCREMENT)
);
          ''');
    });
  }

  MediaItem _toMediaItem(Map<String, dynamic> info) {
    // print(info['art_path']);
    return MediaItem(
        id: info['audio_id'].toString(),
        title: info['title'],
        artist: info['artist'],
        album: info['album'],
        playable: true,
        duration: Duration(milliseconds: info['duration']),
        artUri: Uri.parse(info['art_path']),
        extras: {
          'uri': info['uri'],
          'art_path': info['art_path'],
          'artist_id': info['artist_id'],
          'album_id': info['album_id'],
          'favourite': info['favourite'],
          'play_count': info['play_count'] ?? 0,
        });
  }

  MediaItem _toRadioMediaItem(Map<String, dynamic> info) {
    // print(info['art_path']);
    return MediaItem(
        id: info['id'].toString(),
        title: info['title'],
        artist: 'Live Stream',
        album: 'On Air',
        playable: true,
        duration: const Duration(milliseconds: 0),
        extras: {
          'uri': info['uri'],
          'favourite': 0,
          'play_count': 0,
          'alias': info['alias'],
          'is_radio': true,
        });
  }

  FolderModel _toFolderModel(Map<String, dynamic> info) {
    return FolderModel(
      folder: info['folder'],
      folderUri: info['folder_uri'],
      numberOfSongs: info['number_of_songs'],
    );
  }

  XAlbumModel _toAlbumModel(Map<String, dynamic> info) {
    return XAlbumModel(
      albumName: info['album'],
      albumUri: info['album_id'].toString(),
      numberOfSongs: info['number_of_songs'],
    );
  }

  XArtistModel _toArtistModel(Map<String, dynamic> info) {
    return XArtistModel(
      artistName: info['artist'],
      artistUri: info['artist_id'].toString(),
      numberOfSongs: info['number_of_songs'],
    );
  }

  Future<List<MediaItem>> getAllSongs(String sv, String so) async {
    Database _database = await _initDB();
    List<Map<String, dynamic>> _sl = await _database.rawQuery(
      'SELECT * FROM music ORDER BY $sv $so',
    );
    return _sl.map((rs) => _toMediaItem(rs)).toList();
  }

  Future<Map?> getFavourite(int songId) async {
    Database _database = await _initDB();
    List<Map<String, dynamic>> _sl = await _database.rawQuery(
      'SELECT favourite FROM music WHERE audio_id=$songId',
    );
    return _sl.isNotEmpty ? _sl.first : null;
  }

  Future<List<MediaItem>> getFolderSongs(
      String fl, String sv, String so) async {
    Database _database = await _initDB();
    List<Map<String, dynamic>> _sl = await _database.rawQuery(
      '''SELECT * FROM music WHERE folder_uri='$fl' ORDER BY $sv $so''',
    );
    return _sl.map((rs) => _toMediaItem(rs)).toList();
  }

  Future<List<MediaItem>> getAlbumSongs(String fl, String sv, String so) async {
    Database _database = await _initDB();
    List<Map<String, dynamic>> _sl = await _database.rawQuery(
      '''SELECT * FROM music WHERE album_id=$fl ORDER BY $sv $so''',
    );
    return _sl.map((rs) => _toMediaItem(rs)).toList();
  }

  Future<List<MediaItem>> getArtistSongs(
      String fl, String sv, String so) async {
    Database _database = await _initDB();
    List<Map<String, dynamic>> _sl = await _database.rawQuery(
      '''SELECT * FROM music WHERE artist_id=$fl ORDER BY $sv $so''',
    );
    return _sl.map((rs) => _toMediaItem(rs)).toList();
  }

  Future<void> setFavourite(int songId, int val) async {
    Database _database = await _initDB();
    int _sl = await _database.rawUpdate(
      '''UPDATE music SET favourite=$val WHERE audio_id=$songId''',
    );
  }

  Future<void> setPlayCount(int songId) async {
    Database _database = await _initDB();
    List<Map<String, dynamic>> _sl = await _database.rawQuery(
      'SELECT play_count FROM music WHERE audio_id=$songId',
    );
    await _database.rawUpdate(
      '''UPDATE music SET play_count=${(_sl.last['play_count'] ?? 0) + 1},date_last_played=${DateTime.now().millisecondsSinceEpoch} WHERE audio_id=$songId''',
    );
  }

  Future<List<MediaItem>> getRecentlyPlayedSongs() async {
    Database _database = await _initDB();
    List<Map<String, dynamic>> _sl = await _database.rawQuery(
      '''SELECT * FROM music ORDER BY date_last_played DESC''',
    );
    return _sl.map((rs) => _toMediaItem(rs)).toList();
  }

  Future<List<MediaItem>> getMostlyPlayedSongs() async {
    Database _database = await _initDB();
    List<Map<String, dynamic>> _sl = await _database.rawQuery(
      '''SELECT * FROM music ORDER BY play_count DESC''',
    );
    return _sl.map((rs) => _toMediaItem(rs)).toList();
  }

  Future<List<MediaItem>> getFavouriteSongs() async {
    Database _database = await _initDB();
    List<Map<String, dynamic>> _sl = await _database.rawQuery(
      '''SELECT * FROM music  WHERE favourite =1 ORDER BY date_last_played DESC''',
    );
    return _sl.map((rs) => _toMediaItem(rs)).toList();
  }

  Future<List<MediaItem>> searchSongs(q) async {
    Database _database = await _initDB();
    List<Map<String, dynamic>> _sl = await _database.rawQuery(
      ''' SELECT * FROM music  WHERE title LIKE '%$q%' OR artist LIKE '%$q%' OR album LIKE '%$q%' ''',
    );
    return _sl.map((rs) => _toMediaItem(rs)).toList();
  }

  Future<List<MediaItem>> getMostPlayedSongs() async {
    Database _database = await _initDB();
    List<Map<String, dynamic>> _sl = await _database.rawQuery(
      '''SELECT * FROM music ORDER BY play_count DESC''',
    );
    return _sl.map((rs) => _toMediaItem(rs)).toList();
  }

  Future<List<FolderModel>> getAllSongFolders() async {
    Database _database = await _initDB();
    List<Map<String, dynamic>> _sl = await _database.rawQuery(
      '''SELECT folder, folder_uri, COUNT(folder_uri) as number_of_songs FROM 'music'  GROUP BY folder, folder_uri''',
    );
    return _sl.map((rs) => _toFolderModel(rs)).toList();
  }

  Future<List<XAlbumModel>> getAllSongAlbums() async {
    Database _database = await _initDB();
    List<Map<String, dynamic>> _sl = await _database.rawQuery(
      '''SELECT album, album_id, COUNT(album_id) as number_of_songs FROM 'music'  GROUP BY album, album_id ORDER BY album  ASC''',
    );
    return _sl.map((rs) => _toAlbumModel(rs)).toList();
  }

  Future<List<XArtistModel>> getAllSongArtists() async {
    Database _database = await _initDB();
    List<Map<String, dynamic>> _sl = await _database.rawQuery(
      '''SELECT artist, artist_id, COUNT(artist_id) as number_of_songs FROM 'music'  GROUP BY artist, artist_id ORDER BY artist  ASC''',
    );
    return _sl.map((rs) => _toArtistModel(rs)).toList();
  }

  Future<List<int>> getAudioIds() async {
    Database _database = await _initDB();
    List<Map<String, Object?>> _sl = await _database.rawQuery(
      '''SELECT audio_id FROM music''',
    );
    return _sl.map((rs) => rs['audio_id'] as int).toList();
  }

  Future<int> deleteAudioId(int id) async {
    Database _database = await _initDB();
    int _sl = await _database.rawDelete(
      '''DELETE FROM music WHERE audio_id=$id''',
    );
    return _sl;
  }

  Future<bool> updateLibrary(SongModel song) async {
    if (!song.isMusic!) return false;
    if (song.isRingtone!) return false;
    if (song.isAlarm!) return false;
    if (song.duration! < 60000) return false;

    Database _database = await _initDB();
    List<Map> _sl = await _database
        .rawQuery('SELECT * FROM music WHERE audio_id = ?', [song.id]);

    Directory directory = Directory(song.data);

    String folderUri = directory.parent.path;
    String folder = directory.parent.path.split("/").last;

    String artPath = await saveArtWork(song.id);

    // print(folder);

    if (_sl.isEmpty) {
      await _database.transaction((txn) async {
        int id = await txn.rawInsert('''INSERT INTO music(
              audio_id,
              artist_id,
              album_id,
              data,
              uri,
              title,
              artist,
              album,
              duration,
              folder_uri,
              folder,
              date_added,
              size,
              art_path,
              lyrics
              ) VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)''', [
          song.id,
          song.artistId,
          song.albumId,
          song.data,
          song.uri,
          song.title.split('(')[0],
          song.artist ?? '<unknown>',
          song.album ?? '<unknown>',
          song.duration,
          folderUri.replaceAll('/', '-'),
          folder,
          song.dateAdded,
          song.size,
          artPath,
          ''
        ]);
      });
    } else {
      await _database.rawUpdate(
        '''UPDATE music SET folder_uri='${folderUri.replaceAll('/', '-')}', folder='$folder' WHERE audio_id=${song.id}''',
      );
    }
    return true;
  }

  Future<String> saveArtWork(int id) async {
    Uint8List? _byte = await OnAudioQuery().queryArtwork(
      id,
      ArtworkType.AUDIO,
    );

    Directory tempDir = await getTemporaryDirectory();
    String tempPath = tempDir.path;
    String _fPath = '';

    if (_byte != null && _byte.isNotEmpty) {
      final File _file = File('$tempPath/$id.jpg');
      await _file.writeAsBytes(_byte);
      _fPath = _file.path;
    } else {
      final File _file2 = File('$tempPath/default-art.jpg');
      if (!await _file2.exists()) {
        final byteData = await rootBundle.load('lib/assets/light-cover.png');
        await _file2.writeAsBytes(
          byteData.buffer.asUint8List(
            byteData.offsetInBytes,
            byteData.lengthInBytes,
          ),
        );
      }
      _fPath = _file2.path;
    }

    return _fPath;
  }

  Future<List<MediaItem>> getRadioStations() async {
    List<Map<String, dynamic>> _sl = [
      {
        'id': 1,
        'title': 'Zodiak Radio',
        'alias': '',
        'uri': 'https://ice31.securenetsystems.net/0079',
      },
      {
        'id': 2,
        'title': 'Times Radio',
        'alias': '',
        'uri': 'https://ice1.securenetsystems.net/DEMOSTN',
      },
      {
        'id': 200,
        'title': 'MBC Radio 2',
        'alias': '',
        'uri': 'http://154.66.125.13:86/broadwavehigh.mp3?src=1',
      },
      {
        'id': 3,
        'title': 'Capital FM',
        'alias': 'mw.capitalfmmalawi',
        'uri': 'https://node.stream-africa.com:8443/CapitalFM',
      },
      {
        'id': 4,
        'title': 'Ufulu FM',
        'alias': '',
        'uri': 'https://s5.voscast.com:9463/live',
      },
      {
        'id': 5,
        'title': 'Beyond FM',
        'alias': '',
        'uri': 'https://exclusive.streamafrica.net:8070/radio.mp3',
      },
      {
        'id': 6,
        'title': 'Angaliba Radio',
        'alias': '',
        'uri': 'https://exclusive.streamafrica.net/radio/8040/radio.mp3',
      },
      {
        'id': 7,
        'title': 'PL FM',
        'alias': '',
        'uri': 'https://exclusive.streamafrica.net:8220/plfm',
      },
      {
        'id': 8,
        'title': 'Umunthu',
        'alias': '',
        'uri': 'https://exclusive.streamafrica.net:8150/radio.Aac+',
      },
      {
        'id': 9,
        'title': 'Mzati FM',
        'alias': '',
        'uri': 'https://exclusive.streamafrica.net/radio/8100/mzati.AAC',
      },
      {
        'id': 10,
        'title': 'Chisomo Radio',
        'alias': '',
        'uri': 'https://exclusive.streamafrica.net/radio/8010/radio.mp3',
      },
      {
        'id': 11,
        'title': 'Voice of Livingstonia Radio',
        'alias': '',
        'uri': 'https://exclusive.streamafrica.net/radio/8270/vol',
      },
      {
        'id': 12,
        'title': 'Nkhotakota Community Radio',
        'alias': '',
        'uri': 'https://exclusive.streamafrica.net:8260/kkradio',
      },
      {
        'id': 14,
        'title': 'Kasupe Radio',
        'alias': '',
        'uri': 'https://s45.radiolize.com/radio/8060/radio.mp3',
      },
      {
        'id': 15,
        'title': 'Kuwala FM',
        'alias': '',
        'uri': 'https://exclusive.streamafrica.net:8330/radio.mp3',
      },
      {
        'id': 17,
        'title': 'Story Club FM',
        'alias': 'mw.storyclub',
        'uri': 'https://exclusive.streamafrica.net/radio/8350/storyclub',
      },
      {
        'id': 18,
        'title': 'Ndirande FM',
        'alias': '',
        'uri': 'https://exclusive.streamafrica.net:8130/ndirande.Aac+',
      },
      {
        'id': 19,
        'title': 'Hosanna FM',
        'alias': '',
        'uri': 'https://exclusive.streamafrica.net:8370/hosanna',
      },
      {
        'id': 20,
        'title': 'Tigawane Radio',
        'alias': '',
        'uri': 'https://exclusive.streamafrica.net/radio/8110/tigawane',
      },
      {
        'id': 21,
        'title': 'TWR',
        'alias': '',
        'uri': 'https://exclusive.streamafrica.net:8210/twr.mp3',
      },
      {
        'id': 22,
        'title': 'Hitz Radio Malawi',
        'alias': 'mw.hitzmalawi',
        'uri': 'https://exclusive.streamafrica.net:8300/radio.mp3',
      },
      {
        'id': 23,
        'title': 'Likoma Community Radio',
        'alias': 'mw.likomacommunity',
        'uri': 'https://exclusive.streamafrica.net:8390/likoma',
      },
      {
        'id': 24,
        'title': 'Mlatho Radio',
        'alias': 'mw.mlatho',
        'uri': 'http://s33.myradiostream.com:15154/listen.mp3',
      },
    ];

    return _sl.map((rs) => _toRadioMediaItem(rs)).toList();
  }
}
