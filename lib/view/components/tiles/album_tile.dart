import 'package:aurasounds/model/type.dart';
import 'package:aurasounds/utils/helpers.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:line_icons/line_icons.dart';
import 'package:on_audio_query/on_audio_query.dart';

class AlbumTile extends StatelessWidget {
  const AlbumTile(
      {Key? key,
      required this.album,
      required this.albumSongs,
      required this.isLast})
      : super(key: key);
  final XAlbumModel album;
  final Function albumSongs;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
          bottom: isLast ? 160 : 0, left: 10, right: 10, top: 4),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14.0),
        ),
        elevation: 0.6,
        margin: const EdgeInsets.all(0),
        child: ListTile(
          onTap: () {
            albumSongs();
          },
          contentPadding: const EdgeInsets.only(left: 8),
          leading: ClipRRect(
            borderRadius: BorderRadius.circular(9),
            child: QueryArtworkWidget(
              id: int.parse(album.albumUri),
              type: ArtworkType.ALBUM,
              artworkBorder: BorderRadius.zero,
              nullArtworkWidget: Image.asset(
                'lib/assets/${getThemedAsset('album.png')}',
                fit: BoxFit.cover,
                height: 48,
              ),
            ),
          ),
          title: Text(
            album.albumName,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          subtitle: Text(
              '${album.numberOfSongs.toString()} song${album.numberOfSongs > 1 ? 's' : ''}'),
        ),
      ),
    );
  }
}
