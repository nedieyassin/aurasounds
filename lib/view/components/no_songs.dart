import 'package:aurasounds/controller/player_controller.dart';
import 'package:aurasounds/controller/settings_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NoSongs extends StatelessWidget {
  const NoSongs({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var settingsController = Get.put(SettingsController());
    var playerController = Get.find<PlayerController>();
    return SafeArea(
      child: GetX<SettingsController>(
        builder: (controller) {
          return Column(
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 20),
                child: Icon(
                  Icons.error_outline_outlined,
                  size: 60,
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(top: 40, left: 30, right: 30),
                child: Text(
                  'No songs library, scan from this devices\' storage to proceed',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18),
                ),
              ),
              Center(
                child: Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: controller.isLibrarySongs.value
                      ? const CircularProgressIndicator()
                      : GetX<PlayerController>(builder: (pcontroller) {
                          return pcontroller.noOfAllSongs.value > 0
                              ? Container()
                              : Container();
                        }),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 28, horizontal: 24),
                child: !controller.isLibrarySongs.value
                    ? ElevatedButton(
                        child: const Text('Scan'),
                        onPressed: () {
                          settingsController.updateLibrary().then((value) {
                            playerController.initSongs();
                          });
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
