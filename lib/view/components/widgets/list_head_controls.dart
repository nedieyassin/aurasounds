import 'package:flutter/material.dart';

class ListHeadControls extends StatelessWidget {
  const ListHeadControls({
    Key? key,
    required this.onPlay,
    required this.onShuffle,
  }) : super(key: key);

  final void Function() onPlay;
  final void Function() onShuffle;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
      child: Row(
        children: [
          Expanded(
            child: ElevatedButton(
              onPressed: onPlay,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(
                    Icons.play_arrow_rounded,
                    size: 20,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text('PLAY'),
                ],
              ),
              style: ButtonStyle(
                padding: MaterialStateProperty.all(
                  const EdgeInsets.symmetric(
                    vertical: 12,
                    horizontal: 20,
                  ),
                ),
                elevation: MaterialStateProperty.all(0),
                shape: MaterialStateProperty.all(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(99),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(
            width: 10,
          ),
          Expanded(
            child: ElevatedButton(
              onPressed: onShuffle,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(
                    Icons.shuffle_rounded,
                    size: 20,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text('SHUFFLE'),
                ],
              ),
              style: ButtonStyle(
                padding: MaterialStateProperty.all(
                  const EdgeInsets.symmetric(
                    vertical: 12,
                    horizontal: 20,
                  ),
                ),
                elevation: MaterialStateProperty.all(0),
                foregroundColor:
                MaterialStateProperty.all(Theme.of(context).primaryColor),
                backgroundColor: MaterialStateProperty.all(
                    Theme.of(context).primaryColor.withOpacity(.2)),
                shape: MaterialStateProperty.all(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(99),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}