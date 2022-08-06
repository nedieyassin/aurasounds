import 'package:aurasounds/controller/library_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SortingWidget extends StatelessWidget {
  SortingWidget({Key? key, this.onChange}) : super(key: key);
  final libraryController = Get.find<LibraryController>();
  final Function? onChange;

  @override
  Widget build(BuildContext context) {
    Color fcolor = !Get.isDarkMode ? Colors.black : Colors.white;
    return PopupMenuButton<String>(
      icon: Icon(
        Icons.sort_rounded,
        color: fcolor,
      ),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(15.0),
        ),
      ),
      onSelected: (String? value) async {
        if (value == 'DESC' || value == 'ASC') {
          libraryController.sortOrderType.value = value ?? 'DESC';
        } else {
          libraryController.sortType.value = value ?? 'date_added';
        }
        if (onChange != null) {
          onChange!();
        }
      },
      itemBuilder: (context) => [
        PopupMenuItem<String>(
          value: 'title',
          child: Row(
            children: [
              if (libraryController.sortType.value == 'title')
                Icon(
                  Icons.check_rounded,
                  color: fcolor,
                )
              else
                const SizedBox(width: 10.0),
              const SizedBox(width: 10.0),
              const Text('Title'),
            ],
          ),
        ),
        PopupMenuItem<String>(
          value: 'date_added',
          child: Row(
            children: [
              if (libraryController.sortType.value == 'date_added')
                Icon(
                  Icons.check_rounded,
                  color: fcolor,
                )
              else
                const SizedBox(width: 10.0),
              const SizedBox(width: 10.0),
              const Text('Date Added'),
            ],
          ),
        ),
        PopupMenuItem<String>(
          value: 'artist',
          child: Row(
            children: [
              if (libraryController.sortType.value == 'artist')
                Icon(
                  Icons.check_rounded,
                  color: fcolor,
                )
              else
                const SizedBox(width: 10.0),
              const SizedBox(width: 10.0),
              const Text('Artist'),
            ],
          ),
        ),
        PopupMenuItem<String>(
          value: 'duration',
          child: Row(
            children: [
              if (libraryController.sortType.value == 'duration')
                Icon(
                  Icons.check_rounded,
                  color: fcolor,
                )
              else
                const SizedBox(width: 10.0),
              const SizedBox(width: 10.0),
              const Text('Duration'),
            ],
          ),
        ),
        const PopupMenuDivider(),
        PopupMenuItem<String>(
          value: 'ASC',
          child: Row(
            children: [
              if (libraryController.sortOrderType.value == 'ASC')
                Icon(
                  Icons.check_rounded,
                  color: fcolor,
                )
              else
                const SizedBox(width: 10.0),
              const SizedBox(width: 10.0),
              const Text('Ascending'),
            ],
          ),
        ),
        PopupMenuItem<String>(
          value: 'DESC',
          child: Row(
            children: [
              if (libraryController.sortOrderType.value == 'DESC')
                Icon(
                  Icons.check_rounded,
                  color: fcolor,
                )
              else
                const SizedBox(width: 10.0),
              const SizedBox(width: 10.0),
              const Text('Descending'),
            ],
          ),
        ),
      ],
    );
  }
}
