import 'package:aurasounds/controller/app_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChangeTheme extends StatelessWidget {
   ChangeTheme({Key? key}) : super(key: key);
  var appController = Get.find<AppController>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Column(
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Text(
            'Select colour  from pallets below',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 18),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {
                      appController.changeTheme(Colors.pink);
                    },
                    child: Container(
                      height: 60,
                      width: 60,
                      color: Colors.pink,
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  GestureDetector(
                    onTap: () {
                      appController.changeTheme(Colors.purple);
                    },
                    child: Container(
                      height: 60,
                      width: 60,
                      color: Colors.purple,
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  GestureDetector(
                    onTap: () {
                      appController.changeTheme(Colors.green);
                    },
                    child: Container(
                      height: 60,
                      width: 60,
                      color: Colors.green,
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  GestureDetector(
                    onTap: () {
                      appController.changeTheme(Colors.orange);
                    },
                    child: Container(
                      height: 60,
                      width: 60,
                      color: Colors.orange,
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {
                      appController.changeTheme(Colors.indigo);
                    },
                    child: Container(
                      height: 60,
                      width: 60,
                      color: Colors.indigo,
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  GestureDetector(
                    onTap: () {
                      appController.changeTheme(Colors.brown);
                    },
                    child: Container(
                      height: 60,
                      width: 60,
                      color: Colors.brown,
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  GestureDetector(
                    onTap: () {
                      appController.changeTheme(Colors.red);
                    },
                    child: Container(
                      height: 60,
                      width: 60,
                      color: Colors.red,
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  GestureDetector(
                    onTap: () {
                      appController.changeTheme(Colors.teal);
                    },
                    child: Container(
                      height: 60,
                      width: 60,
                      color: Colors.teal,
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {
                      appController.changeTheme(Colors.blue);
                    },
                    child: Container(
                      height: 60,
                      width: 60,
                      color: Colors.blue,
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  GestureDetector(
                    onTap: () {
                      appController.changeTheme(Colors.lime);
                    },
                    child: Container(
                      height: 60,
                      width: 60,
                      color: Colors.lime,
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  GestureDetector(
                    onTap: () {
                      appController.changeTheme(Colors.cyan);
                    },
                    child: Container(
                      height: 60,
                      width: 60,
                      color: Colors.cyan,
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  GestureDetector(
                    onTap: () {
                      appController.changeTheme(Colors.amber);
                    },
                    child: Container(
                      height: 60,
                      width: 60,
                      color: Colors.amber,
                    ),
                  ),
                ],
              )
            ],
          ),
        )
      ],
    ));
  }
}
