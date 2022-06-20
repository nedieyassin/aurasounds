import 'package:aurasounds/controller/player_controller.dart';
import 'package:aurasounds/utils/constants.dart';
import 'package:aurasounds/view/components/search_widget.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:on_audio_query/on_audio_query.dart';

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
              padding: const EdgeInsets.symmetric(vertical: 10),
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
                ],
              ),
            ))
          ],
        ),
      ),
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
          padding: const EdgeInsets.only(top: 16, left: 26, right: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                title,
                style: xtitle.copyWith(color: Colors.grey.shade600),
              ),
              IconButton(
                  onPressed: () {}, icon: const Icon(EvaIcons.arrowForward))
            ],
          ),
        ),
        GetX<PlayerController>(
          builder: (controller) {
            SongModel audio1 = controller.getRecentlyPlayedAudio(0);
            SongModel audio2 = controller.getRecentlyPlayedAudio(1);
            SongModel audio3 = controller.getRecentlyPlayedAudio(2);
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Flexible(
                    flex: 3,
                    child: Center(
                      child: SizedBox(
                        height: 260,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: QueryArtworkWidget(
                            id: audio1.id,
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
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  Flexible(
                    flex: 2,
                    child: SizedBox(
                      height: 260,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(16),
                              child: QueryArtworkWidget(
                                id: audio2.id,
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
                          const SizedBox(height: 20),
                          Expanded(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(16),
                              child: QueryArtworkWidget(
                                id: audio3.id,
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
                        ],
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
