import 'package:flutter/material.dart';
import 'package:get/get.dart';

class YoutubeSearchWidget extends StatelessWidget {
  YoutubeSearchWidget({
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
            tag: 'local_search',
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
                    () => SearchResults(),
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
                          hintText: 'Search songs..',
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

class SearchResults extends StatelessWidget {
  SearchResults({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    Color fcolor = Get.isDarkMode ? Colors.white : Colors.black;
    return Stack(
      children: [
        Scaffold(
          body: Container(),
        ),
        SafeArea(
          child: Hero(
            tag: 'local_search',
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
                    hintText: 'Search songs..',
                  ),
                  autofocus: true,
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.search,
                  onChanged: (val) {

                  },
                  onSubmitted: (_query) {
                    if (_query.trim() != '') {}
                  },
                )),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
