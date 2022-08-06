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

class XAlbumModel {
  const XAlbumModel({
    required this.albumName,
    required this.albumUri,
    required this.numberOfSongs,
  });

  final String albumName;
  final String albumUri;
  final int numberOfSongs;
}

class XArtistModel {
  const XArtistModel({
    required this.artistName,
    required this.artistUri,
    required this.numberOfSongs,
  });

  final String artistName;
  final String artistUri;
  final int numberOfSongs;
}

class YTVideoItem {
  const YTVideoItem({
    required this.title,
    required this.type,
    required this.description,
    required this.count,
    required this.videoId,
    required this.firstItemId,
    required this.image,
    required this.imageMin,
    required this.imageMedium,
    required this.imageStandard,
    required this.imageMax,
  });

  final String title;
  final String type;
  final String description;
  final String count;
  final String videoId;
  final String firstItemId;
  final String image;
  final String imageMin;
  final String imageMedium;
  final String imageStandard;
  final String imageMax;
}

class YTChartItem {
  const YTChartItem({
    required this.title,
    required this.type,
    required this.description,
    required this.count,
    required this.playlistId,
    required this.firstItemId,
    required this.image,
    required this.imageMedium,
    required this.imageStandard,
    required this.imageMax,
  });

  final String title;
  final String type;
  final String description;
  final String count;
  final String playlistId;
  final String firstItemId;
  final String image;
  final String imageMedium;
  final String imageStandard;
  final String imageMax;
}

class YTItem {
  const YTItem({
    required this.title,
    required this.type,
    required this.description,
    required this.count,
    required this.playlistId,
    required this.firstItemId,
    required this.image,
    required this.imageMedium,
    required this.imageStandard,
    required this.imageMax,
  });

  final String title;
  final String type;
  final String description;
  final String count;
  final String playlistId;
  final String firstItemId;
  final String image;
  final String imageMedium;
  final String imageStandard;
  final String imageMax;
}

class YTHeadItem {
  const YTHeadItem({
    required this.title,
    required this.type,
    required this.description,
    required this.videoId,
    required this.firstItemId,
    required this.image,
    required this.imageMedium,
    required this.imageStandard,
    required this.imageMax,
  });

  final String title;
  final String type;
  final String description;
  final String videoId;
  final String firstItemId;
  final String image;
  final String imageMedium;
  final String imageStandard;
  final String imageMax;
}

class YTVideo {
  YTVideo({
    required this.id,
    required this.album,
    required this.duration,
    required this.title,
    required this.artist,
    required this.image,
    required this.secondImage,
    required this.language,
    required this.genre,
    required this.url,
    required this.lowUrl,
    required this.highUrl,
    required this.year,
    required this.kbps,
    required this.release_date,
    required this.album_id,
    required this.subtitle,
    required this.perma_url,
  });

  final String id;
  final String album;
  final String? duration;
  final String title;
  final String artist;
  final String image;
  final String secondImage;
  final String language;
  final String genre;
  final String url;
  final String lowUrl;
  final String highUrl;
  final String? year;
  final String kbps;
  final String release_date;
  final String album_id;
  final String subtitle;
  final String perma_url;
}
