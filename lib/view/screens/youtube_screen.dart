import 'package:aurasounds/controller/youtube_controller.dart';
import 'package:aurasounds/utils/constants.dart';
import 'package:aurasounds/utils/helpers.dart';
import 'package:aurasounds/view/components/widgets/youtube_search_widget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class YoutubeScreen extends StatelessWidget {
  const YoutubeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color fcolor = Get.isDarkMode ? Colors.white : Colors.black;
    return YoutubeSearchWidget(
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 80,
              ),
              GetX<YoutubeController>(
                builder: (controller) {
                  return CarouselSlider.builder(
                    itemCount: controller.headerList.value.length,
                    options: CarouselOptions(
                      height: 250,
                      viewportFraction: 1.0,
                      autoPlay: true,
                      enlargeCenterPage: true,
                    ),
                    itemBuilder: (
                      BuildContext context,
                      int index,
                      int pageViewIndex,
                    ) =>
                        GestureDetector(
                      onTap: () {},
                      child: Card(
                        elevation: 1,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        margin: const EdgeInsets.symmetric(horizontal: 18),
                        clipBehavior: Clip.antiAlias,
                        child: CachedNetworkImage(
                          fit: BoxFit.cover,
                          imageUrl:
                              controller.headerList.value[index].image.toString(),
                          errorWidget: (context, _, __) => Image(
                            fit: BoxFit.cover,
                            image: AssetImage(
                              'lib/assets/${getThemedAsset('youtubecover.png')}',
                            ),
                          ),
                          placeholder: (context, url) => Image(
                            fit: BoxFit.cover,
                            image: AssetImage(
                              'lib/assets/${getThemedAsset('youtubecover.png')}',
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
              GetX<YoutubeController>(builder: (controller) {
                return ListView.builder(
                  itemCount: controller.bodyList.value.length,
                  physics: const BouncingScrollPhysics(),
                  shrinkWrap: true,
                  padding: const EdgeInsets.only(bottom: 10,),
                  itemBuilder: (context, index) {
                    return Column(
                      children: [
                        Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.fromLTRB(20, 40, 0, 5),
                              child: Text(
                                '${controller.bodyList.value[index]['title']}',
                                style: TextStyle(
                                  color: fcolor,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 200,
                          width: double.infinity,
                          child: ListView.builder(
                            physics: const BouncingScrollPhysics(),
                            scrollDirection: Axis.horizontal,
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            itemCount: (controller.bodyList.value[index]
                                    ['playlists'] as List)
                                .length,
                            itemBuilder: (context, idx) {
                              final item = controller.bodyList.value[index]
                                  ['playlists'][idx];
                              return GestureDetector(
                                onTap: () {
                                  item['type'] == 'video'
                                      ? print('s p')
                                      : print('p p');
                                },
                                child: SizedBox(
                                  width: 180,
                                  child: Column(
                                    children: [
                                      Expanded(
                                        child: Card(
                                          elevation: 1,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              10.0,
                                            ),
                                          ),
                                          clipBehavior: Clip.antiAlias,
                                          child: CachedNetworkImage(
                                            fit: BoxFit.cover,
                                            imageUrl: item.image.toString(),
                                            errorWidget: (context, _, __) =>
                                                 Image(
                                              fit: BoxFit.cover,
                                              image: AssetImage(
                                                'lib/assets/${getThemedAsset('youtube.png')}',
                                              ),
                                            ),
                                            placeholder: (context, url) =>
                                                 Image(
                                              fit: BoxFit.cover,
                                              image: AssetImage(
                                                'lib/assets/${getThemedAsset('youtube.png')}',
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 10.0,
                                        ),
                                        child: Column(
                                          children: [
                                            Text(
                                              '${item.title}',
                                              textAlign: TextAlign.center,
                                              softWrap: false,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            Text(
                                              item.type != 'video'
                                                  ? '${item.count} Tracks | ${item.description}'
                                                  : '${item.count} | ${item.description}',
                                              textAlign: TextAlign.center,
                                              softWrap: false,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                fontSize: 11,
                                                color: Theme.of(context)
                                                    .textTheme
                                                    .caption!
                                                    .color,
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 5.0,
                                            )
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    );
                  },
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}
