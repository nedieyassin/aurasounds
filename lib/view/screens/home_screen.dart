import 'package:aurasounds/view/components/sections/discover_section.dart';
import 'package:aurasounds/view/components/sections/favourite_section.dart';
import 'package:aurasounds/view/components/sections/recently_played_section.dart';
import 'package:aurasounds/view/components/widgets/search_widget.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SearchWidget(
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              const SizedBox(
                height: 60,
              ),
              RecentlyPlayedSection(
                title: 'Recently Played',
              ),
              DiscoverSection(
                title: 'Discover',
              ),
              // MostlyPlayedSection(
              //   title: 'Most Played',
              // ),
              FavouriteSection(
                title: 'Favourite',
              ),
              const SizedBox(
                height: 160,
              ),
            ],
          ),
        ),
      ),
    );
  }
}







