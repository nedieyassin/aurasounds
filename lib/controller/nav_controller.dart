import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class NavController extends GetxController {
  RxInt currentIndex = 0.obs;
  final  pageController = PageController().obs;

  void navigateTo(int value) {
    currentIndex.value = value;
  }
}
