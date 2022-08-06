import 'package:aurasounds/model/type.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:line_icons/line_icons.dart';
import 'package:on_audio_query/on_audio_query.dart';

class ArtistTile extends StatelessWidget {
  const ArtistTile(
      {Key? key,
      required this.artist,
      required this.artistSongs,
      required this.isLast})
      : super(key: key);
  final XArtistModel artist;
  final Function artistSongs;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
          bottom: isLast ? 160 : 0, left: 10, right: 10, top: 8),
      child:Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14.0),
        ),
        elevation: 0.6,
        margin: const EdgeInsets.all(0),
        child: ListTile(
          onTap: () {
            artistSongs();
          },
          contentPadding: const EdgeInsets.only(left: 8),
          leading:ClipRRect(
            borderRadius: BorderRadius.circular(9),
            child: QueryArtworkWidget(
              id: int.parse(artist.artistUri),
              type: ArtworkType.ARTIST,
              artworkBorder: BorderRadius.zero,
              nullArtworkWidget:const Icon(
                LineIcons.user,
                size: 26,
              ),
            ),
          ),
          title: Text(
            artist.artistName,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          subtitle: Text(
              '${artist.numberOfSongs.toString()} song${artist.numberOfSongs > 1 ? 's' : ''}'),
        ),
      ),
    );
  }
}
