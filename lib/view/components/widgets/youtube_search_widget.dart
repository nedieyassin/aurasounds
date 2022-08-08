import 'dart:ui';

import 'package:aurasounds/controller/youtube_controller.dart';
import 'package:aurasounds/model/youtube.dart';
import 'package:aurasounds/view/components/mini_player.dart';
import 'package:aurasounds/view/components/tiles/yt_video_tile.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

class YoutubeSearchWidget extends StatelessWidget {
  const YoutubeSearchWidget({
    Key? key,
    required this.body,
  }) : super(key: key);

  final Widget body;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        body,
        SafeArea(
          child: Hero(
            tag: 'yt_search',
            child: Card(
              margin: const EdgeInsets.fromLTRB(
                18.0,
                10.0,
                18.0,
                15.0,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(
                  10.0,
                ),
              ),
              elevation: 1.0,
              child: GestureDetector(
                onTap: () {
                  // showMaterialModalBottomSheet(
                  //   context: context,
                  //   builder: (context) => SearchResults(),
                  // );
                  Get.to(
                    () => const YTSearchResults(),
                    transition: Transition.upToDown,
                  );
                },
                child: SizedBox(
                  height: 52.0,
                  child: Center(
                    child: TextField(
                        enabled: false,
                        textAlignVertical: TextAlignVertical.center,
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.only(left: 20),
                          focusedBorder: const UnderlineInputBorder(
                            borderSide: BorderSide(
                              width: 1.5,
                              color: Colors.transparent,
                            ),
                          ),
                          fillColor: Theme.of(context).colorScheme.secondary,
                          prefixIcon: const Icon(Icons.search_rounded),
                          border: InputBorder.none,
                          hintText: 'Search youtube..',
                        )),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class YTSearchResults extends StatefulWidget {
  const YTSearchResults({
    Key? key,
    this.autofocus = true,
    this.query = '',
  }) : super(key: key);
  final bool autofocus;
  final String query;

  @override
  State<YTSearchResults> createState() => _YTSearchResultsState();
}

class _YTSearchResultsState extends State<YTSearchResults> {
  final TextEditingController _controller = TextEditingController();

  String tempQuery = '';
  String query = '';
  bool isLoading = false;
  List suggestionsList = [];
  List<Video> searchResult = <Video>[];

  @override
  void initState() {
    super.initState();
    _controller.text = widget.query;
    query = widget.query;
    if (query.isNotEmpty) {
      search(query);
    }
  }

  void search(String q) {
    _controller.text = q;

    setState(() {
      isLoading = true;
    });

    YouTubeServices().fetchSearchResults(q).then((list) {
      setState(() {
        searchResult = list;
        suggestionsList = [];
        isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          body: SafeArea(
            child: Stack(
              children: [
                isLoading
                    ? const Center(
                        child: CircularProgressIndicator(),
                      )
                    : ListView.builder(
                        itemCount: searchResult.length,
                        physics: const BouncingScrollPhysics(),
                        itemBuilder: (context, index) {
                          if (index == 0) {
                            return Column(
                              children: [
                                const SizedBox(
                                  height: 90,
                                ),
                                YTVideoTile(
                                  video: searchResult[index],
                                  index: index,
                                  isLast: index + 1 == searchResult.length,
                                  onSearch: (String q) {
                                    search(q);
                                  },
                                )
                              ],
                            );
                          } else {
                            return YTVideoTile(
                              video: searchResult[index],
                              index: index,
                              isLast: index + 1 == searchResult.length,
                              onSearch: (String q) {
                                search(q);
                              },
                            );
                          }
                        },
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
              ],
            ),
          ),
          resizeToAvoidBottomInset: false,
        ),
        suggestionsList.isEmpty
            ? const SizedBox()
            : Card(
                margin:
                    const EdgeInsets.only(left: 18.0, right: 18.0, top: 106),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                    10.0,
                  ),
                ),
                elevation: 8.0,
                child: SizedBox(
                  height: MediaQuery.of(context).size.height - 350.0,
                  child: ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.only(
                      top: 10,
                      bottom: 10,
                    ),
                    shrinkWrap: true,
                    itemExtent: 70.0,
                    itemCount: suggestionsList.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        leading: const Icon(Icons.search),
                        title: Text(
                          suggestionsList[index].toString(),
                          overflow: TextOverflow.ellipsis,
                        ),
                        onTap: () {
                          search(suggestionsList[index].toString());
                          setState(() {
                            suggestionsList = [];
                          });
                        },
                      );
                    },
                  ),
                ),
              ),
        SafeArea(
          child: Hero(
            tag: 'yt_search',
            child: Card(
              margin: const EdgeInsets.fromLTRB(
                18.0,
                10.0,
                18.0,
                15.0,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(
                  10.0,
                ),
              ),
              elevation: 2.0,
              child: SizedBox(
                height: 52.0,
                child: Center(
                    child: TextField(
                  controller: _controller,
                  textAlignVertical: TextAlignVertical.center,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.only(left: 20),
                    focusedBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(
                        width: 1.5,
                        color: Colors.transparent,
                      ),
                    ),
                    fillColor: Theme.of(context).colorScheme.secondary,
                    prefixIcon: IconButton(
                      icon: const Icon(Icons.arrow_back),
                      onPressed: () {
                        Get.back();
                      },
                    ),
                    border: InputBorder.none,
                    hintText: 'Search youtube..',
                  ),
                  autofocus: widget.autofocus,
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.search,
                  onChanged: (val) {
                    if (val.isEmpty) {
                      setState(() {
                        suggestionsList = [];
                      });
                    }
                    ;
                    tempQuery = val;
                    Future.delayed(
                      const Duration(
                        milliseconds: 400,
                      ),
                      () async {
                        if (tempQuery == val &&
                            tempQuery.trim() != '' &&
                            tempQuery != query) {
                          query = tempQuery;
                          YouTubeServices()
                              .getSearchSuggestions(query: query)
                              .then((value) {
                            setState(() {
                              suggestionsList = value;
                            });
                          });
                        }
                      },
                    );
                  },
                  onSubmitted: (_query) {
                    if (_query.trim() != '') {}
                  },
                )),
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
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
  }
}
