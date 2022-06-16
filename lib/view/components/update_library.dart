import 'package:aurasounds/controller/settings_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UpdateLibrary extends StatelessWidget {
  UpdateLibrary({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var settingsController = Get.put(SettingsController());
    return SafeArea(
      child: GetX<SettingsController>(
        builder: (controller) {
          return Column(
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                child: Text(
                  'Scan & load new songs into aurasounds song library from this devices\' storage',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18),
                ),
              ),
              Center(
                child: Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: controller.isLibrarySongs.value
                      ? const CircularProgressIndicator()
                      : Container(),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 28, horizontal: 24),
                child: !controller.isLibrarySongs.value
                    ? ElevatedButton(
                        child: const Text('Scan & Update Library'),
                        onPressed: () {
                          settingsController.updateLibrary();
                        },
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                              Theme.of(context).primaryColor),
                          padding: MaterialStateProperty.all(
                            const EdgeInsets.symmetric(
                                vertical: 12, horizontal: 20),
                          ),
                          shape: MaterialStateProperty.all(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
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
