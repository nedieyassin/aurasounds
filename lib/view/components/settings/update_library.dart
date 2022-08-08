import 'package:aurasounds/controller/library_controller.dart';
import 'package:aurasounds/controller/settings_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UpdateLibrary extends StatelessWidget {
  const UpdateLibrary({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var settingsController = Get.put(SettingsController());
    final libraryController = Get.find<LibraryController>();
    return SafeArea(
      child: GetX<SettingsController>(
        builder: (controller) {
          return Column(
            children: [
              const Padding(
                padding: EdgeInsets.only(top: 40, left: 30, right: 30),
                child: Text(
                  'Update songs  aurasounds song library',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18),
                ),
              ),
              Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 40),
                  child: controller.syncProgress.value.isNotEmpty
                      ? Column(
                          children: [
                            const CircularProgressIndicator(),
                            const Padding(
                              padding: EdgeInsets.only(top: 20),
                              child: Text('Scanning..'),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 4),
                              child: Text(
                                controller.syncProgress.value,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 30,
                                ),
                              ),
                            ),
                          ],
                        )
                      : Container(),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 28, horizontal: 24),
                child: controller.syncProgress.value.isEmpty
                    ? ElevatedButton(
                        child: const Text('Update Library'),
                        onPressed: () {
                          settingsController.updateLibrary().then((value) {
                            libraryController.initSongs();
                          });
                        },
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                              Theme.of(context).primaryColor),
                          padding: MaterialStateProperty.all(
                            const EdgeInsets.symmetric(
                                vertical: 18, horizontal: 40),
                          ),
                          shape: MaterialStateProperty.all(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(99),
                            ),
                          ),
                          elevation: MaterialStateProperty.all(0),
                        ),
                      )
                    : Container(),
              ),
            ],
          );
        },
      ),
    );
  }
}
