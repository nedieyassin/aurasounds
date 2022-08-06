import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BouncyImageSliverScrollView extends StatelessWidget {
  final ScrollController? scrollController;
  final SliverList sliverList;
  final bool shrinkWrap;
  final List<Widget>? actions;
  final String title;
  final String? imageUrl;
  final bool localImage;
  final bool isWidgetImage;
  final Widget? imageWidget;
  final String placeholderImage;

  BouncyImageSliverScrollView({
    Key? key,
    this.scrollController,
    this.shrinkWrap = false,
    required this.sliverList,
    required this.title,
    this.placeholderImage = 'lib/assets/light-art.png',
    this.localImage = false,
    this.isWidgetImage = false,
    this.imageWidget,
    this.imageUrl,
    this.actions,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Widget image = imageUrl == null
        ? isWidgetImage
            ? imageWidget ?? Container()
            : Image(
                fit: BoxFit.cover,
                image: AssetImage(placeholderImage),
              )
        : localImage
            ? Image(
                image: FileImage(
                  File(
                    imageUrl!,
                  ),
                ),
                fit: BoxFit.cover,
              )
            : CachedNetworkImage(
                fit: BoxFit.cover,
                errorWidget: (context, _, __) => Image(
                  fit: BoxFit.cover,
                  image: AssetImage(placeholderImage),
                ),
                imageUrl: imageUrl!,
                placeholder: (context, url) => Image(
                  fit: BoxFit.cover,
                  image: AssetImage(placeholderImage),
                ),
              );

    final double expandedHeight = MediaQuery.of(context).size.height * 0.35;

    Color bcolor = Get.isDarkMode ? Colors.black : Colors.white;
    Color fcolor = Get.isDarkMode ? Colors.white : Colors.black;

    return CustomScrollView(
      controller: scrollController,
      shrinkWrap: shrinkWrap,
      physics: const BouncingScrollPhysics(),
      slivers: [
        SliverAppBar(
          elevation: 0,
          stretch: true,
          pinned: true,
          centerTitle: true,
          // floating: true,
          backgroundColor: bcolor,
          expandedHeight: expandedHeight,
          actions: actions,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: fcolor,
            ),
            onPressed: () {
              Get.back();
            },
          ),
          flexibleSpace: FlexibleSpaceBar(
            title: Text(
              title,
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(color: fcolor),
            ),
            centerTitle: true,
            background: SizedBox.expand(
              child: ShaderMask(
                shaderCallback: (rect) {
                  return LinearGradient(
                    begin: Alignment.center,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withOpacity(.8),
                      Colors.transparent,
                    ],
                  ).createShader(
                    Rect.fromLTRB(
                      0,
                      0,
                      rect.width,
                      rect.height,
                    ),
                  );
                },
                blendMode: BlendMode.dstIn,
                child: image,
              ),
            ),
          ),
        ),
        sliverList,
      ],
    );
  }
}
