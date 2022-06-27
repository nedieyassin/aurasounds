import 'dart:io';

import 'package:just_audio_background/just_audio_background.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

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
	PRIMARY KEY("id" AUTOINCREMENT)
);
          ''');

      print('table created');
    });
  }

  MediaItem _toMediaItem(Map<String, dynamic> info) {
    return MediaItem(
        id: info['audio_id'].toString(),
        title: info['title'],
        artist: info['artist'],
        album: info['album'],
        playable: true,
        duration: Duration(milliseconds: info['duration']),
        extras: {'uri': info['uri']});
  }

  FolderModel _toFolderModel(Map<String, dynamic> info) {
    return FolderModel(
      folder: info['folder'],
      folderUri: info['folder_uri'],
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

  Future<List<MediaItem>> getFolderSongs(
      String fl, String sv, String so) async {
    Database _database = await _initDB();
    List<Map<String, dynamic>> _sl = await _database.rawQuery(
      '''SELECT * FROM music WHERE folder_uri='$fl' ORDER BY $sv $so''',
    );
    return _sl.map((rs) => _toMediaItem(rs)).toList();
  }

  Future<List<MediaItem>> getRecentlyPlayedSongs() async {
    Database _database = await _initDB();
    List<Map<String, dynamic>> _sl = await _database.rawQuery(
      '''SELECT * FROM music ORDER BY date_last_played DESC''',
    );
    return _sl.map((rs) => _toMediaItem(rs)).toList();
  }

  Future<List<MediaItem>> getFavouriteSongs() async {
    Database _database = await _initDB();
    List<Map<String, dynamic>> _sl = await _database.rawQuery(
      '''SELECT * FROM music  WHERE favourite =1 ORDER BY title DESC ''',
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
      '''SELECT folder, folder_uri,COUNT(folder_uri) as number_of_songs FROM 'music'  GROUP BY folder, folder_uri''',
    );
    return _sl.map((rs) => _toFolderModel(rs)).toList();
  }

  Future<bool> updateLibrary(List<SongModel> songs) async {
    for (SongModel song in songs) {
      if (!song.isMusic!) continue;
      if (song.isRingtone!) continue;
      if (song.isAlarm!) continue;
      if (song.duration! < 60000) continue;

      Database _database = await _initDB();
      List<Map> _sl = await _database
          .rawQuery('SELECT * FROM music WHERE audio_id = ?', [song.id]);

      Directory directory = Directory(song.data);

      String folderUri = directory.parent.path;
      String folder = directory.parent.path.split("/").last;

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
              size
              ) VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?)''', [
            song.id,
            song.artistId,
            song.albumId,
            song.data,
            song.uri,
            song.title.split('(')[0],
            song.artist,
            song.album,
            song.duration,
            folderUri.replaceAll('/', '-'),
            folder,
            song.dateAdded,
            song.size
          ]);
        });
      } else {}
    }
    return true;
  }
}

class FolderModel {
  const FolderModel({
    required this.folder,
    required this.folderUri,
    required this.numberOfSongs,
  });

  final String folder;
  final String folderUri;
  final int numberOfSongs;
}
