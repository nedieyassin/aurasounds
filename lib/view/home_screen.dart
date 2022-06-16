import 'package:aurasounds/utils/constants.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.only(top: 20, left: 16),
                child: Text(
                  'aurasounds',
                  style: xheading.copyWith(
                      fontSize: 38,
                      color: Theme.of(context).primaryColor,
                      fontFamily: 'Cust'),
                ),
              ),
              const HomeSection(
                title: 'Recently Played Songs',
              ),
              const HomeSection(
                title: 'Favourite Songs',
              ),
              const HomeSection(
                title: 'Recently Added Songs',
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class HomeSection extends StatelessWidget {
  const HomeSection({
    Key? key,
    required this.title,
  }) : super(key: key);
  final String title;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 16, left: 16, right: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                title,
                style: xtitle.copyWith(color: Colors.grey.shade600),
              ),
              IconButton(onPressed: () {}, icon: const Icon(EvaIcons.arrowForward))
            ],
          ),
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: const [
                HomeCard(),
                HomeCard(),
                HomeCard(),
                HomeCard(),
                HomeCard(),
              ],
            ),
          ),
        )
      ],
    );
  }
}

class HomeCard extends StatelessWidget {
  const HomeCard({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Image.asset(
              'lib/assets/art.png',
              fit: BoxFit.cover,
              height: 160,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Alive',
                  style: xsubtitle.copyWith(fontSize: 18),
                ),
                Text(
                  'alesso X Angrosso',
                  style: xsubtitle.copyWith(
                      color: Colors.grey.shade600,
                      fontWeight: FontWeight.normal),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
