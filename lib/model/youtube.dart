import 'dart:convert';

import 'package:aurasounds/model/type.dart';
import 'package:http/http.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

class YouTubeServices {
  static const String searchAuthority = 'www.youtube.com';
  static const Map paths = {
    'search': '/results',
    'channel': '/channel',
    'music': '/music',
    'playlist': '/playlist'
  };
  static const Map<String, String> headers = {
    'User-Agent':
        'Mozilla/5.0 (Windows NT 10.0; rv:96.0) Gecko/20100101 Firefox/96.0'
  };
  final YoutubeExplode yt = YoutubeExplode();

  Future<List<Video>> getPlaylistSongs(String id) async {
    final List<Video> results = await yt.playlists.getVideos(id).toList();
    return results;
  }

  Future<Playlist> getPlaylistDetails(String id) async {
    final Playlist metadata = await yt.playlists.get(id);
    return metadata;
  }

  Future<Map<String, List>> getMusicHome() async {
    final Uri link = Uri.https(
      searchAuthority,
      paths['music'].toString(),
    );
    try {
      final Response response = await get(link);
      if (response.statusCode != 200) {
        return {};
      }
      final String searchResults =
          RegExp(r'(\"contents\":{.*?}),\"metadata\"', dotAll: true)
              .firstMatch(response.body)![1]!;
      final Map data = json.decode('{$searchResults}') as Map;

      final List result = data['contents']['twoColumnBrowseResultsRenderer']
              ['tabs'][0]['tabRenderer']['content']['sectionListRenderer']
          ['contents'] as List;

      final List headResult = data['header']['carouselHeaderRenderer']
          ['contents'][0]['carouselItemRenderer']['carouselItems'] as List;

      final List shelfRenderer = result.map((element) {
        return element['itemSectionRenderer']['contents'][0]['shelfRenderer'];
      }).toList();

      final List finalResult = shelfRenderer.map((element) {
        // print(element);
        if (element['title']['runs'][0]['text'].trim() !=
            'Highlights from Global Citizen Live') {
          return {
            'title': element['title']['runs'][0]['text'],
            'playlists': element['title']['runs'][0]['text'].contains('Charts')
                ? formatChartItems(
                    element['content']['horizontalListRenderer']['items']
                        as List,
                  )
                : element['title']['runs'][0]['text']
                        .toString()
                        .contains('Videos')
                    ? formatVideoItems(
                        element['content']['horizontalListRenderer']['items']
                            as List,
                      )
                    : formatItems(
                        element['content']['horizontalListRenderer']['items']
                            as List,
                      ),
          };
        } else {
          return null;
        }
      }).toList();

      final List finalHeadResult = formatHeadItems(headResult);
      finalResult.removeWhere((element) => element == null);
      finalResult
          .removeWhere((element) => (element['playlists'] as List).isEmpty);

      return {'body': finalResult, 'head': finalHeadResult};
    } catch (e) {
      return {};
    }
  }

  Future<List> getSearchSuggestions({required String query}) async {
    const baseUrl = 'https://suggestqueries.google.com/complete/search?client=firefox&ds=yt&q=';
    //     'https://invidious.snopyta.org/api/v1/search/suggestions?q=';
    final Uri link = Uri.parse(baseUrl + query);
    try {
      final Response response = await get(link, headers: headers);
      if (response.statusCode != 200) {
        return [];
      }
      return jsonDecode(response.body)[1] as List;
    } catch (e) {
      return [];
    }
  }

  List formatVideoItems(List itemsList) {
    try {
      final List<YTVideoItem> result = itemsList.map((e) {
        return YTVideoItem(
          title: e['gridVideoRenderer']['title']['simpleText'],
          type: 'video',
          description: e['gridVideoRenderer']['shortBylineText']['runs'][0]
              ['text'],
          count: e['gridVideoRenderer']['shortViewCountText']['simpleText'],
          videoId: e['gridVideoRenderer']['videoId'],
          firstItemId: e['gridVideoRenderer']['videoId'],
          image: e['gridVideoRenderer']['thumbnail']['thumbnails'].last['url'],
          imageMin: e['gridVideoRenderer']['thumbnail']['thumbnails'][0]['url'],
          imageMedium: e['gridVideoRenderer']['thumbnail']['thumbnails'][1]
              ['url'],
          imageStandard: e['gridVideoRenderer']['thumbnail']['thumbnails'][2]
              ['url'],
          imageMax:
              e['gridVideoRenderer']['thumbnail']['thumbnails'].last['url'],
        );
      }).toList();

      return result;
    } catch (e) {
      return List.empty();
    }
  }

  List formatChartItems(List itemsList) {
    try {
      final List result = itemsList.map((e) {
        return YTChartItem(
          title: e['gridPlaylistRenderer']['title']['runs'][0]['text'],
          type: 'chart',
          description: e['gridPlaylistRenderer']['shortBylineText']['runs'][0]
              ['text'],
          count: e['gridPlaylistRenderer']['videoCountText']['runs'][0]['text'],
          playlistId: e['gridPlaylistRenderer']['navigationEndpoint']
              ['watchEndpoint']['playlistId'],
          firstItemId: e['gridPlaylistRenderer']['navigationEndpoint']
              ['watchEndpoint']['videoId'],
          image: e['gridPlaylistRenderer']['thumbnail']['thumbnails'][0]['url'],
          imageMedium: e['gridPlaylistRenderer']['thumbnail']['thumbnails'][0]
              ['url'],
          imageStandard: e['gridPlaylistRenderer']['thumbnail']['thumbnails'][0]
              ['url'],
          imageMax: e['gridPlaylistRenderer']['thumbnail']['thumbnails'][0]
              ['url'],
        );
      }).toList();

      return result;
    } catch (e) {
      return List.empty();
    }
  }

  List formatItems(List itemsList) {
    try {
      final List result = itemsList.map((e) {
        return YTChartItem(
          title: e['compactStationRenderer']['title']['simpleText'],
          type: 'playlist',
          description: e['compactStationRenderer']['description']['simpleText'],
          count: e['compactStationRenderer']['videoCountText']['runs'][0]
              ['text'],
          playlistId: e['compactStationRenderer']['navigationEndpoint']
              ['watchEndpoint']['playlistId'],
          firstItemId: e['compactStationRenderer']['navigationEndpoint']
              ['watchEndpoint']['videoId'],
          image: e['compactStationRenderer']['thumbnail']['thumbnails'][0]
              ['url'],
          imageMedium: e['compactStationRenderer']['thumbnail']['thumbnails'][0]
              ['url'],
          imageStandard: e['compactStationRenderer']['thumbnail']['thumbnails']
              [1]['url'],
          imageMax: e['compactStationRenderer']['thumbnail']['thumbnails'][2]
              ['url'],
        );
      }).toList();

      return result;
    } catch (e) {
      return List.empty();
    }
  }

  List formatHeadItems(List itemsList) {
    try {
      final List result = itemsList.map((e) {
        return YTHeadItem(
          title: e['defaultPromoPanelRenderer']['title']['runs'][0]['text'],
          type: 'video',
          description:
              (e['defaultPromoPanelRenderer']['description']['runs'] as List)
                  .map((e) => e['text'])
                  .toList()
                  .join(),
          videoId: e['defaultPromoPanelRenderer']['navigationEndpoint']
              ['watchEndpoint']['videoId'],
          firstItemId: e['defaultPromoPanelRenderer']['navigationEndpoint']
              ['watchEndpoint']['videoId'],
          image: e['defaultPromoPanelRenderer']
                          ['largeFormFactorBackgroundThumbnail']
                      ['thumbnailLandscapePortraitRenderer']['landscape']
                  ['thumbnails']
              .last['url'],
          imageMedium: e['defaultPromoPanelRenderer']
                      ['largeFormFactorBackgroundThumbnail']
                  ['thumbnailLandscapePortraitRenderer']['landscape']
              ['thumbnails'][1]['url'],
          imageStandard: e['defaultPromoPanelRenderer']
                      ['largeFormFactorBackgroundThumbnail']
                  ['thumbnailLandscapePortraitRenderer']['landscape']
              ['thumbnails'][2]['url'],
          imageMax: e['defaultPromoPanelRenderer']
                          ['largeFormFactorBackgroundThumbnail']
                      ['thumbnailLandscapePortraitRenderer']['landscape']
                  ['thumbnails']
              .last['url'],
        );
      }).toList();

      return result;
    } catch (e) {
      return List.empty();
    }
  }

  Future<MediaItem?> formatVideo({
    required Video video,
    required String quality,
    // bool preferM4a = true,
  }) async {
    if (video.duration?.inSeconds == null) return null;
    final List urls = await getUri(video);
    return mapToMediaItem(YTVideo(
      id: video.id.value,
      album: video.author,
      duration: video.duration?.inSeconds.toString(),
      title: video.title,
      artist: video.author,
      image: video.thumbnails.maxResUrl,
      secondImage: video.thumbnails.highResUrl,
      language: 'YouTube',
      genre: 'YouTube',
      url: quality == 'High' ? urls.last : urls.first,
      lowUrl: urls.first,
      highUrl: urls.last,
      year: video.uploadDate?.year.toString(),
      kbps: 'false',
      release_date: video.publishDate.toString(),
      album_id: video.channelId.value,
      subtitle: video.author,
      perma_url: video.url,
    ));
  }

  static MediaItem mapToMediaItem(
    YTVideo song, {
    bool addedByAutoplay = false,
    bool autoplay = true,
  }) {
    return MediaItem(
      id: song.id.toString(),
      album: song.album.toString(),
      artist: song.artist.toString(),
      duration: Duration(
        seconds: int.parse(
          (song.duration == null || song.duration == 'null')
              ? '180'
              : song.duration.toString(),
        ),
      ),
      title: song.title.toString(),
      artUri: Uri.parse(
        song.image
            .toString()
            .replaceAll('50x50', '500x500')
            .replaceAll('150x150', '500x500'),
      ),
      genre: song.language.toString(),
      extras: {
        'uri': song.url,
        'lowUrl': song.lowUrl,
        'highUrl': song.highUrl,
        'year': song.year,
        'language': song.language,
        '320kbps': song.kbps,
        'release_date': song.release_date,
        'album_id': song.album_id,
        'subtitle': song.subtitle,
        'perma_url': song.perma_url,
        'addedByAutoplay': addedByAutoplay,
        'autoplay': autoplay,
        'is_youtube': true,
      },
    );
  }

  Future<List<Video>> fetchSearchResults(String query) async {
    final List<Video> searchResults = await yt.search.getVideos(query);
    return searchResults;
  }

  Future<List<String>> getUri(
    Video video,
    // {bool preferM4a = true}
  ) async {
    final StreamManifest manifest =
        await yt.videos.streamsClient.getManifest(video.id);
    final List<AudioOnlyStreamInfo> sortedStreamInfo =
        manifest.audioOnly.sortByBitrate();

    return [
      sortedStreamInfo.first.url.toString(),
      sortedStreamInfo.last.url.toString(),
    ];
  }
}
