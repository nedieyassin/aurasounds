import 'package:aurasounds/controller/library_controller.dart';
import 'package:aurasounds/controller/player_controller.dart';
import 'package:aurasounds/controller/youtube_controller.dart';
import 'package:aurasounds/model/type.dart';
import 'package:aurasounds/model/youtube.dart';
import 'package:aurasounds/utils/constants.dart';
import 'package:aurasounds/utils/helpers.dart';
import 'package:aurasounds/view/components/widgets/youtube_search_widget.dart';
import 'package:aurasounds/view/screens/pages/album_sliver_page.dart';
import 'package:aurasounds/view/screens/pages/artist_sliver_page.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

class YTVideoTile extends StatelessWidget {
  YTVideoTile({
    Key? key,
    required this.video,
    required this.index,
    required this.isLast,
    this.showNumber = false,
    this.showPlayCount = false,
    this.isFav = false,
    required this.onSearch,
  }) : super(key: key);
  final Video video;
  final int index;
  final bool isLast;
  final bool showNumber;
  final bool showPlayCount;
  final bool isFav;
  final Function onSearch;

  final playerController = Get.find<PlayerController>();
  final youtubeController = Get.find<YoutubeController>();

  @override
  Widget build(BuildContext context) {
    return GetX<PlayerController>(builder: (controller) {
      return Container(
        margin: EdgeInsets.only(
            bottom: isLast ? 160 : 0, left: 10, right: 10, top: 4),
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(16)),
          border: controller.getCurrentAudioId.value == video.id.value
              ? Border.all(width: 2, color: Theme.of(context).primaryColor)
              : Border.all(
                  width: 0, color: Theme.of(context).scaffoldBackgroundColor),
        ),
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14.0),
          ),
          elevation: 0.6,
          margin: const EdgeInsets.all(0),
          child: ListTile(
            onTap: () async {
              youtubeController.isLoadingStream.value = true;
              MediaItem? item = await YouTubeServices()
                  .formatVideo(video: video, quality: '');
              youtubeController.isLoadingStream.value = false;
              if (item != null) {
                playerController.startPlaylist(
                  playlist: 'youtube',
                  music: [item],
                  falseOpen: true,
                );
              }
            },
            contentPadding: const EdgeInsets.only(left: 10),
            leading: SizedBox(
              width: 50,
              height: 50,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(9),
                child: CachedNetworkImage(
                  fit: BoxFit.cover,
                  imageUrl: video.thumbnails.lowResUrl,
                  errorWidget: (context, _, __) => Image(
                    fit: BoxFit.cover,
                    image: AssetImage(
                      'lib/assets/${getThemedAsset('youtube.png')}',
                    ),
                  ),
                  placeholder: (context, url) => Image(
                    fit: BoxFit.cover,
                    image: AssetImage(
                      'lib/assets/${getThemedAsset('youtube.png')}',
                    ),
                  ),
                ),
              ),
            ),
            title: Text(
              video.title,
              maxLines: 1,
              style: xtitle.copyWith(fontSize: 14),
              overflow: TextOverflow.ellipsis,
            ),
            subtitle: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    video.author,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Text(
                  video.duration
                      .toString()
                      .split('.')[0]
                      .replaceFirst('0:0', ''),
                ),
              ],
            ),
            trailing: PopupMenuButton<int>(
              icon: const Icon(Icons.more_vert_rounded),
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(15.0),
                ),
              ),
              onSelected: (int? value) async {
                if (value == 1) {
                  if (onSearch != null) {
                    onSearch!(video.title);
                  }
                }
                if (value == 2) {
                  await launchUrl(Uri.parse(video.url),
                      mode: LaunchMode.externalApplication);
                }
              },
              itemBuilder: (context) => [
                PopupMenuItem<int>(
                  value: 1,
                  child: Row(
                    children: const [
                      Icon(Icons.search),
                      SizedBox(width: 10.0),
                      Text('Search Related Content'),
                    ],
                  ),
                ),
                const PopupMenuDivider(),
                PopupMenuItem<int>(
                  value: 2,
                  child: Row(
                    children: const [
                      Icon(Icons.ondemand_video_rounded),
                      SizedBox(width: 10.0),
                      Text('Watch Video'),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
