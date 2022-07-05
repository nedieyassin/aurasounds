import 'package:flutter/material.dart';

class TermsScreen extends StatelessWidget {
  const TermsScreen({Key? key}) : super(key: key);

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
                'Aurasounds is copyrighted to its developers, it should not be sold or used for any intent other than audio playing.',
                style: TextStyle(fontSize: 18)),
          ),

          Padding(
            padding: EdgeInsets.symmetric(vertical: 6),
            child: Text(
                'Warning: Listening to music too  loudly for extended periods of time, can cause damage to your hearing over time.',
                style: TextStyle(fontSize: 18)),
          ),

          Padding(
            padding: EdgeInsets.symmetric(vertical: 6),
            child: Text(
                'All logos are intellectual property and trademarks of their respective owners ',
                style: TextStyle(fontSize: 16)),
          ),
        ],
      ),
    );
  }
}
