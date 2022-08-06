import 'package:aurasounds/view/screens/pages/library_page.dart';
import 'package:aurasounds/view/components/widgets/search_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LibraryScreen extends StatelessWidget {
  const LibraryScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SearchWidget(
      body: const Padding(
        padding: EdgeInsets.only(top: 60),
        child: SafeArea(
          child: LibraryPage(),
        ),
      ),
    );
  }
}
