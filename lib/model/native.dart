import 'package:aurasounds/model/database.dart';
import 'package:on_audio_query/on_audio_query.dart';

Stream<String> getNativeSongs() async* {
  final OnAudioQuery _audioQuery = OnAudioQuery();
  final DBModel _db = DBModel();

  final _l = await _audioQuery.querySongs();
  final _dbIds = await _db.getAudioIds();
  List<int> remove = _l
      .map((e) => e.id)
      .toList()
      .where((element) => !_dbIds.contains(element))
      .toList();

  for (int r in remove) {
    await _db.deleteAudioId(r);
  }

  for (int i = 0; i <= _l.length - 1; i++) {
    await _db.updateLibrary(_l[i]);
    yield '${i + 1}/${_l.length}';
  }
}
