import 'dart:ui';
import 'package:aurasounds/controller/player_controller.dart';
import 'package:aurasounds/controller/youtube_controller.dart';
import 'package:aurasounds/model/type.dart';
import 'package:aurasounds/utils/helpers.dart';
import 'package:aurasounds/view/components/mini_player.dart';
import 'package:aurasounds/view/components/silver_view.dart';
import 'package:aurasounds/view/components/tiles/yt_video_tile.dart';
import 'package:aurasounds/view/components/widgets/youtube_search_widget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:line_icons/line_icons.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

class YTChartSliverPage extends StatelessWidget {
  YTChartSliverPage({
    Key? key,
    required this.chart,
    required this.getContent,
  }) : super(key: key);

  final playerController = Get.find<PlayerController>();
  final youtubeController = Get.find<YoutubeController>();

  final YTChartItem chart;
  final Future<bool> getContent;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
          future: getContent,
          builder: (context, snap) {
            if (snap.hasData) {
              return Stack(
                children: [
                  BouncyImageSliverScrollView(
                    title: chart.title,
                    isWidgetImage: true,
                    imageWidget: CachedNetworkImage(
                      fit: BoxFit.cover,
                      imageUrl: chart.image.toString(),
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
                    sliverList: SliverList(
                      delegate: youtubeController.chartSongs.value.isNotEmpty
                          ? SliverChildBuilderDelegate(
                              (context, int index) {
                                Video video =
                                    youtubeController.chartSongs.value[index];
                                return YTVideoTile(
                                  video: video,
                                  index: index,
                                  isLast: index + 1 ==
                                      youtubeController.chartSongs.value.length,
                                  onSearch: (String q) {
                                    Get.to(() => YTSearchResults(
                                          autofocus: false,
                                          query: q,
                                        ));
                                  },
                                );
                              },
                              childCount:
                                  youtubeController.chartSongs.value.length,
                            )
                          : SliverChildListDelegate([
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 100),
                                child: Center(
                                  child: Column(
                                    children: const [
                                      Icon(
                                        LineIcons.frowningFace,
                                        size: 50,
                                      ),
                                      Text('No content found')
                                    ],
                                  ),
                                ),
                              )
                            ]),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    child: ClipRRect(
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 30.0, sigmaY: 30.0),
                        child: const SafeArea(
                          top: false,
                          child: MiniPlayer(),
                        ),
                      ),
                    ),
                  ),
                  GetX<YoutubeController>(builder: (controller) {
                    if (controller.isLoadingStream.value) {
                      return Center(
                        child: SizedBox.square(
                          dimension: 180,
                          child: Card(
                            elevation: 10,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            clipBehavior: Clip.antiAlias,
                            child: Center(
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      Theme.of(context).primaryColor,
                                    ),
                                    strokeWidth: 4,
                                  ),
                                  const Text(
                                    'Fetching Music',
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    } else {
                      return const SizedBox();
                    }
                  })
                ],
              );
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          }),
    );
  }
}
