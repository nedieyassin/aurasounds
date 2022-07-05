import 'dart:typed_data';
import 'dart:io';

import 'package:aurasounds/model/database.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:path_provider/path_provider.dart';

Future<List<SongModel>> getNativeSongs() async {
  final OnAudioQuery _audioQuery = OnAudioQuery();
  final DBModel _db = DBModel();

  await _audioQuery.permissionsRequest();
  final _l = await _audioQuery.querySongs();
  await _db.updateLibrary(_l);

  return _l;
}

Future<String> saveArtWork({
  required int id,
  int size = 200,
  int quality = 100,
  ArtworkFormat format = ArtworkFormat.JPEG,
}) async {
  final tempPath = (await getTemporaryDirectory()).path;
  final File file = File('$tempPath/$id.jpg');
  final OnAudioQuery _audioQuery = OnAudioQuery();

  if (!await file.exists()) {
    await file.create();
    final Uint8List? image = await _audioQuery.queryArtwork(
      id,
      ArtworkType.AUDIO,
      format: format,
      size: size,
      quality: quality,
    );
    file.writeAsBytesSync(image!);
  }
  return file.path;
}
