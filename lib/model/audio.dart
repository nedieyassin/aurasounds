import 'package:aurasounds/utils/helpers.dart';

class XAudio {
  final int? id;
  final String? data;
  final String? title;
  final String? album;
  final String? artist;
  final int? albumId;
  final int? duration;
  final String? albumPathUri;

  String durationText() {
    return formatDuration(Duration(milliseconds: duration!));
  }

  const XAudio({
    this.id,
    this.data,
    this.title,
    this.album,
    this.artist,
    this.albumId,
    this.duration,
    this.albumPathUri,
  });
}
