import 'dart:io';

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

  SongModel _toSongModel(Map<String, dynamic> info) {
    Map _map = {
      '_id': info['audio_id'],
      'artist_id': info['artist_id'],
      'album_id': info['album_id'],
      '_data': info['data'],
      '_uri': info['uri'],
      'title': info['title'],
      '_display_name': info['title'],
      '_display_name_wo_ext': info['title'],
      'artist': info['artist'],
      'album': info['album'],
      'duration': info['duration'],
      '_size': info['size'],
      'file_extension': "." + info['data'].split('.').last,
      'date_added': info['date_added'],
    };

    return SongModel(_map);
  }

  FolderModel _toFolderModel(Map<String, dynamic> info) {
    return FolderModel(
      folder: info['folder'],
      folderUri: info['folder_uri'],
      numberOfSongs: info['number_of_songs'],
    );
  }

  Future<List<SongModel>> getAllSongs(String sv, String so) async {
    Database _database = await _initDB();
    List<Map<String, dynamic>> _sl = await _database.rawQuery(
      'SELECT * FROM music ORDER BY $sv $so',
    );
    return _sl.map((rs) => _toSongModel(rs)).toList();
  }

  Future<List<SongModel>> getFolderSongs(String fl) async {
    Database _database = await _initDB();
    List<Map<String, dynamic>> _sl = await _database.rawQuery(
      '''SELECT * FROM music WHERE folder_uri='$fl' ORDER BY title ASC''',
    );
    return _sl.map((rs) => _toSongModel(rs)).toList();
  }

  Future<List<SongModel>> getRecentlyPlayedSongs() async {
    Database _database = await _initDB();
    List<Map<String, dynamic>> _sl = await _database.rawQuery(
      '''SELECT * FROM music ORDER BY date_last_played DESC LIMIT 3''',
    );
    return _sl.map((rs) => _toSongModel(rs)).toList();
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
      if (song.duration! < 120000) continue;

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
            song.title,
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
