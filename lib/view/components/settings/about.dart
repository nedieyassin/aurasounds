import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: const [
          Padding(
            padding: EdgeInsets.symmetric(vertical: 6),
            child: Text(
                'Aurasounds is a feature rich music player made by music lover for music lovers.',
                style: TextStyle(fontSize: 18)),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 6),
            child: Text(
                'It is a small yet powerful offline music player for Android, which organises and plays local audio-files stored on your device.',
                style: TextStyle(fontSize: 18)),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 6),
            child: Text(
                'It is capable of fetching lyrics from internet.',
                style: TextStyle(fontSize: 18)),
          ),
        ],
      ),
    );
  }
}
