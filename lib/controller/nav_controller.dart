import 'package:get/get.dart';

class NavController extends GetxController {
  RxInt currentIndex = 0.obs;

  void navigateTo(int value) {
    currentIndex.value = value;
  }
}
