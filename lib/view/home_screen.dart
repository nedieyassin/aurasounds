import 'package:aurasounds/controller/player_controller.dart';
import 'package:aurasounds/utils/constants.dart';
import 'package:aurasounds/view/components/all_songs.dart';
import 'package:aurasounds/view/components/search_widget.dart';
import 'package:aurasounds/view/components/song_tile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 6),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.only(left: 16),
                    child: Text(
                      'aurasounds',
                      style: xheading.copyWith(
                          fontSize: 38,
                          color: Theme.of(context).primaryColor,
                          fontFamily: 'Cust'),
                    ),
                  ),
                  const SearchWidget()
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: const [
                    RecentlyPlayedSection(
                      title: 'Recently Played Songs',
                    ),
                    FavouriteSection(
                      title: 'Most Played',
                    ),
                    FavouriteSection(
                      title: 'Favorite',
                    ),
                    SizedBox(
                      height: 160,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class FavouriteSection extends StatelessWidget {
  const FavouriteSection({
    Key? key,
    required this.title,
  }) : super(key: key);
  final String title;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                title,
                style: xtitle.copyWith(color: Colors.grey.shade600),
              ),
              ElevatedButton(
                child: const Text(
                  'More',
                ),
                onPressed: () {},
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(
                    Theme.of(context).primaryColor.withOpacity(0.01),
                  ),
                  foregroundColor:
                      MaterialStateProperty.all(Theme.of(context).primaryColor),
                  padding: MaterialStateProperty.all(
                    const EdgeInsets.symmetric(horizontal: 26, vertical: 2),
                  ),
                  shape: MaterialStateProperty.all(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(99),
                    ),
                  ),
                  elevation: MaterialStateProperty.all(0),
                ),
              )
            ],
          ),
        ),
        GetX<PlayerController>(
          builder: (controller) {
            MediaItem audio1 = controller.getRecentlyPlayedAudio(0);
            MediaItem audio2 = controller.getRecentlyPlayedAudio(1);
            MediaItem audio3 = controller.getRecentlyPlayedAudio(2);
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: StaggeredGrid.count(
                crossAxisCount: 6,
                mainAxisSpacing: 4,
                crossAxisSpacing: 4,
                children: [
                  StaggeredGridTile.count(
                    crossAxisCellCount: 2,
                    mainAxisCellCount: 2,
                    child: Container(
                      margin: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        border:
                            Border.all(width: 4, color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: QueryArtworkWidget(
                          id: int.parse(audio1.id),
                          type: ArtworkType.AUDIO,
                          artworkBorder: BorderRadius.zero,
                          artworkWidth: 500,
                          nullArtworkWidget: Image.asset(
                            'lib/assets/art.png',
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  ),
                  StaggeredGridTile.count(
                    crossAxisCellCount: 2,
                    mainAxisCellCount: 2,
                    child: Container(
                      margin: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        border:
                            Border.all(width: 4, color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: QueryArtworkWidget(
                          id: int.parse(audio2.id),
                          type: ArtworkType.AUDIO,
                          artworkBorder: BorderRadius.zero,
                          artworkWidth: 500,
                          nullArtworkWidget: Image.asset(
                            'lib/assets/art.png',
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  ),
                  StaggeredGridTile.count(
                    crossAxisCellCount: 2,
                    mainAxisCellCount: 2,
                    child: Container(
                      margin: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        border:
                            Border.all(width: 4, color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: QueryArtworkWidget(
                          id: int.parse(audio3.id),
                          type: ArtworkType.AUDIO,
                          artworkBorder: BorderRadius.zero,
                          artworkWidth: 500,
                          nullArtworkWidget: Image.asset(
                            'lib/assets/art.png',
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        )
      ],
    );
  }
}

class RecentlyPlayedSection extends StatelessWidget {
  const RecentlyPlayedSection({
    Key? key,
    required this.title,
  }) : super(key: key);
  final String title;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 20, right: 20, top: 30),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                title,
                style: xtitle.copyWith(color: Colors.grey.shade600),
              ),
              ElevatedButton(
                child: const Text(
                  'More',
                ),
                onPressed: () {},
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(
                    Theme.of(context).primaryColor.withOpacity(0.01),
                  ),
                  foregroundColor:
                      MaterialStateProperty.all(Theme.of(context).primaryColor),
                  padding: MaterialStateProperty.all(
                    const EdgeInsets.symmetric(horizontal: 26, vertical: 2),
                  ),
                  shape: MaterialStateProperty.all(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(99),
                    ),
                  ),
                  elevation: MaterialStateProperty.all(0),
                ),
              )
            ],
          ),
        ),
        GetX<PlayerController>(
          builder: (controller) {
            MediaItem audio1 = controller.getRecentlyPlayedAudio(0);
            MediaItem audio2 = controller.getRecentlyPlayedAudio(1);
            MediaItem audio3 = controller.getRecentlyPlayedAudio(2);
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: StaggeredGrid.count(
                crossAxisCount: 6,
                mainAxisSpacing: 4,
                crossAxisSpacing: 4,
                children: [
                  StaggeredGridTile.count(
                    crossAxisCellCount: 4,
                    mainAxisCellCount: 4,
                    child: Container(
                      margin: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        border:
                            Border.all(width: 4, color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: QueryArtworkWidget(
                          id: int.parse(audio1.id),
                          type: ArtworkType.AUDIO,
                          artworkBorder: BorderRadius.zero,
                          artworkWidth: 500,
                          nullArtworkWidget: Image.asset(
                            'lib/assets/art.png',
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  ),
                  StaggeredGridTile.count(
                    crossAxisCellCount: 2,
                    mainAxisCellCount: 2,
                    child: Container(
                      margin: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        border:
                            Border.all(width: 4, color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: QueryArtworkWidget(
                          id: int.parse(audio2.id),
                          type: ArtworkType.AUDIO,
                          artworkBorder: BorderRadius.zero,
                          artworkWidth: 500,
                          nullArtworkWidget: Image.asset(
                            'lib/assets/art.png',
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  ),
                  StaggeredGridTile.count(
                    crossAxisCellCount: 2,
                    mainAxisCellCount: 2,
                    child: Container(
                      margin: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        border:
                            Border.all(width: 4, color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: QueryArtworkWidget(
                          id: int.parse(audio3.id),
                          type: ArtworkType.AUDIO,
                          artworkBorder: BorderRadius.zero,
                          artworkWidth: 500,
                          nullArtworkWidget: Image.asset(
                            'lib/assets/art.png',
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        )
      ],
    );
  }
}
