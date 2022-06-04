import 'dart:convert';
import 'package:flutter/services.dart';

const _platform = MethodChannel('com.nedieyassin/auro');

Future<List<dynamic>> nativeGetPlaylist() async {
  try {
    int lastSynced = await _platform.invokeMethod('lastSynced');
    bool invoke = await _platform.invokeMethod('invokeList');
    int isLastSynced = lastSynced;
    String playlist = '[]';

    while (invoke) {
      if (lastSynced != isLastSynced) {
        playlist = await _platform.invokeMethod('getPlaylist');
        break;
      }
      isLastSynced = await _platform.invokeMethod('lastSynced');
    }
    // print(json.decode(playlist)[0]);
    return json.decode(playlist);
  } on PlatformException catch (e) {
    return [];
  }
}
