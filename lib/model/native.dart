import 'package:aurasounds/model/database.dart';
import 'package:on_audio_query/on_audio_query.dart';

Future<List<SongModel>> getNativeSongs() async {
  final OnAudioQuery _audioQuery = OnAudioQuery();
  final DBModel _db = DBModel();

  await _audioQuery.permissionsRequest();
  final _l = await _audioQuery.querySongs();
  await _db.updateLibrary(_l);

  return _l;
}
