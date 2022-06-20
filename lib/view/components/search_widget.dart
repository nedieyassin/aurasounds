import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';

class SearchWidget extends StatelessWidget {
  const SearchWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.only(right: 10),
        child: ElevatedButton(
          child: Row(
            children: [
              Text(
                'Search',
                style: TextStyle(color: Colors.grey.shade500),
              ),
              const SizedBox(
                width: 10,
              ),
              const Icon(EvaIcons.search),
            ],
          ),
          onPressed: () {},
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(Colors.grey.shade200),
            foregroundColor: MaterialStateProperty.all(Colors.grey.shade800),
            padding: MaterialStateProperty.all(
              const EdgeInsets.only(left: 20, bottom: 10, top: 10, right: 10),
            ),
            shape: MaterialStateProperty.all(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(99),
              ),
            ),
            elevation: MaterialStateProperty.all(0),
          ),
        ));
  }
}
